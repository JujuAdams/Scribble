const int MAX_EFFECTS = 6;
//By default, the effect indexes are:
//0 = is an animated sprite
//1 = wave
//2 = shake
//3 = rainbow
//4 = wobble
//5 = swell

const int MAX_DATA_FIELDS = 7;
//By default, the data fields are:
//0 = wave size
//1 = wave frequency
//2 = wave speed
//3 = shake size
//4 = shake speed
//5 = rainbow weight

const float MAX_LINES = 1000.0; //Change SCRIBBLE_MAX_LINES in __scribble_config() if you change this value!



//--------------------------------------------------------------------------------------------------------
// Attributes, Varyings, and Uniforms


attribute vec3 in_Position;     //{Centre X, Centre Y, Packed character & line index}
attribute vec3 in_Normal;       //{Delta X, Delta Y, Bitpacked effect flags}
attribute vec4 in_Colour;       //Colour. This attribute is used for sprite data if this character is a sprite
attribute vec2 in_TextureCoord; //UVs

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4  u_vColourBlend;
uniform float u_fTime;
uniform float u_fZ;

uniform float u_fTypewriterMethod;
uniform float u_fTypewriterSmoothness;
uniform float u_fTypewriterT;

uniform float u_aDataFields[MAX_DATA_FIELDS];
//uniform vec2 u_vTexel; //Used in the fragment shader



//--------------------------------------------------------------------------------------------------------
// Functions
// Scroll all the way down to see the main() function for the vertex shader

//Bitwise unpacking of effect flags
//The effect bits are stored in the Z-channel of the Normal attribute
void unpackFlags(float flagValue, inout float array[MAX_EFFECTS])
{
    float check = pow(2.0, float(MAX_EFFECTS)-1.0);
    for(int i = MAX_EFFECTS-1; i >= 0; i--)
    {
        if (flagValue >= check)
        {
            array[i] = 1.0;
            flagValue -= check;
        }
        else
        {
            array[i] = 0.0;
        }
        check /= 2.0;
    }
}

//Oscillate the character
float wave(float characterIndex, float amplitude, float frequency, float speed)
{
    return amplitude*sin(frequency*characterIndex + speed*u_fTime);
}

//Rotate the character
vec2 rotate(vec2 position, vec2 centre, float angle)
{
    vec2 delta = position.xy - centre;
    float _sin = sin(0.00872664625*angle);
    float _cos = cos(0.00872664625*angle);
    return centre + vec2(delta.x*_cos - delta.y*_sin, delta.x*_sin + delta.y*_cos);
}

//Scale the character
vec2 scale(vec2 position, vec2 centre, float scale)
{
    return centre + scale*(position - centre);
}

//*That* randomisation function.
//I haven't found a better method yet, and this is sufficient for our purposes
float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

//Shake the character along the x/y axes
//We use integer time steps so that at low speeds characters don't jump around too much
//Lots of magic numbers in here to try to get a nice-looking shake
vec2 shake(float characterIndex, float magnitude, float speed)
{
    float time = speed*u_fTime + 0.5;
    float floorTime = floor(time);
    float merge = 1.0 - abs(2.0*(time - floorTime) - 1.0);
    
    //Use some misc prime numbers to try to get a varied-looking shake
    vec2 delta = vec2(rand(vec2(149.0*characterIndex + 13.0*floorTime, 727.0*characterIndex - 331.0*floorTime)),
                      rand(vec2(501.0*characterIndex - 19.0*floorTime, 701.0*characterIndex + 317.0*floorTime)));
    
    return magnitude*merge*(2.0*delta-1.0);
}

//Use RGBA 
vec4 handleSprites(float isSprite, vec4 colour)
{
    if (isSprite == 1.0)
    {
        float myImage    = colour.r*255.0;       //First byte is the index of this sprite
        float imageMax   = 1.0 + colour.g*255.0; //Second byte is the maximum number of images in the sprite
        float imageSpeed = colour.b;             //Third byte is half of the image speed
        float imageStart = colour.a*255.0;       //Fourth byte is the image offset
        
        float displayImage = floor(mod(imageSpeed*u_fTime + imageStart, imageMax));
        return vec4((abs(myImage-displayImage) < 1.0/255.0)? 1.0 : 0.0);
    }
    else
    {
        return colour;
    }
}

//HSV->RGB conversion function
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 P = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(P - K.xxx, 0.0, 1.0), c.y);
}

//Colour cycling for the rainbow effect
vec4 rainbow(float characterIndex, float weight, float speed, vec4 colour)
{
    return vec4(mix(colour.rgb, hsv2rgb(vec3(characterIndex + speed*u_fTime, 1.0, 1.0)), weight), colour.a);
}

//Fade effect for typewriter etc.
float fade(float time, float smoothness, float limit)
{
    float multiplier = 1.0;
    
    if (smoothness > 0.0)
    {
        float adjustedTime = time*(1.0 + smoothness);
        multiplier = clamp((adjustedTime - limit)/smoothness, 0.0, 1.0);
    }
    else
    {
        multiplier = 1.0 - step(time, limit);
    }
        
    if (u_fTypewriterMethod < 0.0) multiplier = 1.0 - multiplier;
    
    return multiplier;
}



//--------------------------------------------------------------------------------------------------------



void main()
{
    //Unpack character/line index
    float characterIndex = floor(in_Position.z / MAX_LINES);
    float lineIndex      = in_Position.z - characterIndex*MAX_LINES;
    
    //Unpack data fields into variables
    //This isn't strictly necessary but it makes the shader easier to read
    float waveAmplitude  = u_aDataFields[0];
    float waveFrequency  = u_aDataFields[1];
    float waveSpeed      = u_aDataFields[2];
    float shakeMagnitude = u_aDataFields[3];
    float shakeSpeed     = u_aDataFields[4];
    float rainbowWeight  = u_aDataFields[5];
    float rainbowSpeed   = u_aDataFields[6];
    
    //Unpack the effect flag bits into an array, then into variables for readability
    float flagArray[MAX_EFFECTS]; unpackFlags(in_Normal.z, flagArray);
    float spriteFlag  = flagArray[0];
    float waveFlag    = flagArray[1];
    float shakeFlag   = flagArray[2];
    float rainbowFlag = flagArray[3];
    
    //Use the input vertex position from the vertex attributes. Use our Z uniform because the z-component is used for other data
    vec2 centre = in_Position.xy;
    vec2 delta = in_Normal.xy;
    vec4 pos = vec4(centre + delta, u_fZ, 1.0);
    
    //Vertex animation
    pos.xy  = scale(pos.xy, centre, 1.0);
    pos.xy  = rotate(pos.xy, centre, 0.0);
    pos.y  += wave(characterIndex, waveFlag*waveAmplitude, waveFrequency, waveSpeed); //Apply the wave effect
    pos.xy += shake(characterIndex, shakeFlag*shakeMagnitude, shakeSpeed); //Apply the shake effect
    
    //Colour
    v_vColour  = handleSprites(spriteFlag, in_Colour); //Use RGBA information to filter out sprites
    v_vColour  = rainbow(characterIndex, rainbowFlag*rainbowWeight, rainbowSpeed, v_vColour); //Cycle colours for the rainbow effect
    v_vColour *= u_vColourBlend; //And then blend with the blend colour/alpha
    
    //Apply fade (if we're given a method)
    if (u_fTypewriterMethod != 0.0)
    {
        //Choose our limit based on what method's being used: if the method value == 1.0 then we're using character indexes, otherwise we use line indexes
        float limit = (abs(u_fTypewriterMethod) == 1.0)? characterIndex : lineIndex;
        v_vColour.a *= fade(u_fTypewriterT, u_fTypewriterSmoothness, limit);
    }
    
    //Texture
    v_vTexcoord = in_TextureCoord;
    
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*pos;
}