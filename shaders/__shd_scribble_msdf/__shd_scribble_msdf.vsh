//   @jujuadams   v7.1.2   2021-03-16
precision highp float;

const int MAX_EFFECTS = 10;
//By default, the effect indexes are:
//0 = is an animated sprite
//1 = wave
//2 = shake
//3 = rainbow
//4 = wobble
//5 = pulse
//6 = wheel
//7 = cycle
//8 = jitter
//9 = blink

const int MAX_ANIM_FIELDS = 20;
//By default, the data fields are:
// 0 = wave amplitude
// 1 = wave frequency
// 2 = wave speed
// 3 = shake amplitude
// 4 = shake speed
// 5 = rainbow weight
// 6 = rainbow speed
// 7 = wobble angle
// 8 = wobble frequency
// 9 = pulse scale
//10 = pulse speed
//11 = wheel amplitude
//12 = wheel frequency
//13 = wheel speed
//14 = cycle speed
//15 = cycle saturation
//16 = cycle value
//17 = jitter minimum scale
//18 = jitter maximum scale
//19 = jitter speed

const int EASE_METHOD_COUNT = 15;
// 0 = None
// 1 = Linear
// 2 = Quadratic
// 3 = Cubic
// 4 = Quartic
// 5 = Quintic
// 6 = Sine
// 7 = Exponential
// 8 = Circular
// 9 = Back
//10 = Elastic
//11 = Bounce
//12 = Custom 1
//13 = Custom 2
//14 = Custom 3

const float MAX_LINES = 1000.0; //Change __SCRIBBLE_MAX_LINES in scribble_init() if you change this value!

const int WINDOW_COUNT = 4;

const float PI = 3.14159265359;



//--------------------------------------------------------------------------------------------------------
// Attributes, Varyings, and Uniforms


attribute vec3  in_Position;     //{X, Y, Packed character & line index}
attribute vec3  in_Normal;       //{dX, Sprite data, Bitpacked effect flags}
attribute vec4  in_Colour;       //Colour. This attribute is used for sprite data if this character is a sprite
attribute vec2  in_TextureCoord; //UVs
attribute vec2  in_Colour2;      //{Scale, dY}

varying vec2  v_vTexcoord;
varying vec4  v_vColour;
varying float v_fPixelScale;
varying float v_fTextScale;

uniform vec4  u_vColourBlend;                           //4
uniform vec4  u_vGradient;                              //4
uniform float u_fTime;                                  //1
uniform float u_aDataFields[MAX_ANIM_FIELDS];           //18
uniform vec2  u_aBezier[3];                             //6
uniform float u_fBlinkState;                            //1

uniform int   u_iTypewriterMethod;                      //1
uniform int   u_iTypewriterCharMax;                     //1
uniform float u_fTypewriterWindowArray[2*WINDOW_COUNT]; //8
uniform float u_fTypewriterSmoothness;                  //1
uniform vec2  u_vTypewriterStartPos;                    //2
uniform vec2  u_vTypewriterStartScale;                  //2
uniform float u_fTypewriterStartRotation;               //1
uniform float u_fTypewriterAlphaDuration;               //1

uniform vec2  u_vOutputSize;                            //2



//--------------------------------------------------------------------------------------------------------
// Functions
// Scroll all the way down to see the main() function for the vertex shader

//*That* randomisation function.
//I haven't found a better method yet, and this is sufficient for our purposes
float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

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

//Rotate by vector
vec2 rotate_by_vector(vec2 position, vec2 centre, vec2 vector)
{
    //Normally I'd do this with a mat2() but for some reason this had issues cross-platform
    vec2 delta = position - centre;
    return centre + vec2(delta.x*vector.x - delta.y*vector.y, delta.x*vector.y + delta.y*vector.x);
}

//Rotate the character
vec2 rotate(vec2 position, vec2 centre, float angle)
{
    return rotate_by_vector(position, centre, vec2(cos(0.00872664625*angle), -sin(0.00872664625*angle)));
}

//Scale the character equally on both x and y axes
vec2 scale(vec2 position, vec2 centre, float scale)
{
    return centre + scale*(position - centre);
}

vec2 scale(vec2 position, vec2 centre, vec2 scale)
{
    return centre + scale*(position - centre);
}

//Scale the character on the x-axis
float xscale(vec2 position, vec2 centre, float scale)
{
    return centre.x + scale*(position.x - centre.x);
}

//Scale the character on the y-axis
float yscale(vec2 position, vec2 centre, float scale)
{
    return centre.y + scale*(position.y - centre.y);
}

//Oscillate the character
vec2 wave(vec2 position, float characterIndex, float amplitude, float frequency, float speed)
{
    return vec2(position.x, position.y + amplitude*sin(frequency*characterIndex + speed*u_fTime));
}

//Wheel the character around
vec2 wheel(vec2 position, float characterIndex, float amplitude, float frequency, float speed)
{
    float time = frequency*characterIndex + speed*u_fTime;
    return position.xy + amplitude*vec2(cos(time), -sin(time));
}

//Wobble the character by rotating around its central point
vec2 wobble(vec2 position, vec2 centre, float angle, float frequency)
{
    return rotate(position, centre, angle*sin(frequency*u_fTime));
}

//Pulse the character by scaling it up and down
vec2 pulse(vec2 position, vec2 centre, float characterIndex, float scale_, float frequency)
{
    float adjustedScale = 1.0 + scale_*(0.5 + 0.5*sin(frequency*(250.0*characterIndex + u_fTime)));
    return scale(position, centre, adjustedScale);
}

//Shake the character along the x/y axes
//We use integer time steps so that at low speeds characters don't jump around too much
//Lots of magic numbers in here to try to get a nice-looking shake
vec2 shake(vec2 position, float characterIndex, float magnitude, float speed)
{
    float time = speed*u_fTime + 0.5;
    float floorTime = floor(time);
    float merge = 1.0 - abs(2.0*(time - floorTime) - 1.0);
    
    //Use some misc prime numbers to try to get a varied-looking shake
    vec2 delta = vec2(rand(vec2(characterIndex/149.0 + floorTime/13.0, characterIndex/727.0 - floorTime/331.0)),
                      rand(vec2(characterIndex/501.0 - floorTime/19.0, characterIndex/701.0 + floorTime/317.0)));
    
    return position + magnitude*merge*(2.0*delta - 1.0);
}

//Jitter the character scale, using a similar method to above
vec2 jitter(vec2 position, vec2 centre, float characterIndex, float mini, float maxi, float speed)
{
    float floorTime = floor(speed*u_fTime + 0.5);
    
    //Use some misc prime numbers to try to get a varied-looking jitter
    float delta = rand(vec2(characterIndex/149.0 + floorTime/13.0, characterIndex/727.0 - floorTime/331.0));
    
    return scale(position, centre, mix(mini, maxi, delta));
}

float filterSprite(float spriteData)
{
    float imageSpeed = floor(spriteData / 4096.0);
    float imageMax   = floor((spriteData - 4096.0*imageSpeed) / 64.0);
    float image      = spriteData - (4096.0*imageSpeed + 64.0*imageMax);
    
    float displayImage = floor(mod(imageSpeed*u_fTime/1024.0, imageMax));
    return ((abs(image-displayImage) < 1.0/255.0)? 1.0 : 0.0);
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
                           
//Colour cycling through a defined palette
vec4 cycle(float characterIndex, float speed, float saturation, float value, vec4 colour)
{
    float max_h = 4.0; //Default to a 4-colour cycle
    
    //Special cases for 0- and 1-colour cycles
    if (colour.r < 0.003) return colour;
    if (colour.g < 0.003) return vec4(hsv2rgb(vec3(colour.r, saturation/255.0, value/255.0)), 1.0);
    if (colour.a < 0.003) max_h = 3.0; //3-colour cycle
    if (colour.b < 0.003) max_h = 2.0; //2-colour cycle
    
    float h = abs(mod((speed*u_fTime - characterIndex)/10.0, max_h));
    vec3 rgbA = hsv2rgb(vec3(colour[int(h)], saturation/255.0, value/255.0));
    vec3 rgbB = hsv2rgb(vec3(colour[int(mod(h + 1.0, max_h))], saturation/255.0, value/255.0));
    
    return vec4(mix(rgbA, rgbB, fract(h)), 1.0);
}

//Fade effect for typewriter etc.
float fade(float windowArray[2*WINDOW_COUNT], float smoothness, float index, bool invert)
{
    float result = 0.0;
    float f      = 1.0;
    float head   = 0.0;
    float tail   = 0.0;
    
    for(int i = 0; i < 2*WINDOW_COUNT; i += 2)
    {
        head = windowArray[i  ];
        tail = windowArray[i+1];
        
        if (u_fTypewriterSmoothness > 0.0)
        {
            f = 1.0 - min(max((index - tail) / smoothness, 0.0), 1.0);
        }
        else
        {
            f = 1.0;
        }
        
        f *= step(index, head);
        
        result = max(f, result);
    }
    
    if (invert) result = 1.0 - result;
    
    return result;
}

vec2 bezier(float t, vec2 p1, vec2 p2, vec2 p3)
{
    float inv_t = 1.0 - t;
    return 3.0*inv_t*inv_t*t*p1 + 3.0*inv_t*t*t*p2 + t*t*t*p3;
}

vec2 bezierDerivative(float t, vec2 p1, vec2 p2, vec2 p3)
{
    float inv_t = 1.0 - t;
    return 3.0*inv_t*inv_t*p1 + 6.0*inv_t*t*(p2 - p1) + 3.0*t*t*(p3 - p2);
}



//--------------------------------------------------------------------------------------------------------



float easeQuad(float time)
{
	return time*time;
}

float easeCubic(float time)
{
	return time*time*time;
}

float easeQuart(float time)
{
	return time*time*time*time;
}

float easeQuint(float time)
{
	return time*time*time*time*time;
}

float easeSine(float time)
{
    return 1.0 - cos(0.5*(time*PI));
}

float easeExpo(float time)
{
    if (time == 0.0) return 0.0;
    return pow(2.0, 10.0*time - 10.0);
}

float easeCirc(float time)
{
    return 1.0 - sqrt(1.0 - time*time);
}

float easeBack(float time)
{
    float param = 1.70158;
	return time*time*((param + 1.0)*time - param);
}

float easeElastic(float time)
{
    if (time == 0.0) return 0.0;
    if (time == 1.0) return 1.0;
    return -pow(2.0, 10.0*time - 10.0) * sin((time*10.0 - 10.75) * (2.0*PI) / 3.0);
}

float easeBounce(float time)
{
	float n1 = 7.5625;
	float d1 = 2.75;
    
    time = 1.0 - time;
    
	if (time < 1.0 / d1)
    {
		return 1.0 - n1*time*time;
	}
    else if (time < 2.0 / d1)
    {
        time -= 1.5/d1;
		return 1.0 - (n1*time*time + 0.75);
	}
    else if (time < 2.5 / d1)
    {
        time -= 2.25/d1;
		return 1.0 - (n1*time*time + 0.9375);
	}
    else
    {
        time -= 2.625/d1;
		return 1.0 - (n1*time*time + 0.984375);
	}
}



//--------------------------------------------------------------------------------------------------------



void main()
{
    //Find the scaling factor for the MVP matrix
    v_fTextScale = in_Colour2.x;
    
    mat4 wvpMatrix = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION];
    vec2 pixelScale = vec2(length(vec3(wvpMatrix[0][0], wvpMatrix[0][1], wvpMatrix[0][2])),
                           length(vec3(wvpMatrix[1][0], wvpMatrix[1][1], wvpMatrix[1][2])));
    pixelScale *= u_vOutputSize;
    v_fPixelScale = 0.25*v_fTextScale*length(pixelScale);
    
    
    //Unpack character/line index
    float characterIndex = floor(in_Position.z / MAX_LINES);
    float lineIndex      = in_Position.z - characterIndex*MAX_LINES;
    
    //Unpack data fields into variables
    //This isn't strictly necessary but it makes the shader easier to read
    float waveAmplitude   = u_aDataFields[ 0];
    float waveFrequency   = u_aDataFields[ 1];
    float waveSpeed       = u_aDataFields[ 2];
    float shakeAmplitude  = u_aDataFields[ 3];
    float shakeSpeed      = u_aDataFields[ 4];
    float rainbowWeight   = u_aDataFields[ 5];
    float rainbowSpeed    = u_aDataFields[ 6];
    float wobbleAngle     = u_aDataFields[ 7];
    float wobbleFrequency = u_aDataFields[ 8];
    float pulseScale      = u_aDataFields[ 9];
    float pulseSpeed      = u_aDataFields[10];
    float wheelAmplitude  = u_aDataFields[11];
    float wheelFrequency  = u_aDataFields[12];
    float wheelSpeed      = u_aDataFields[13];
    float cycleSpeed      = u_aDataFields[14];
    float cycleSaturation = u_aDataFields[15];
    float cycleValue      = u_aDataFields[16];
    float jitterMinimum   = u_aDataFields[17];
    float jitterMaximum   = u_aDataFields[18];
    float jitterSpeed     = u_aDataFields[19];
    
    //Unpack the effect flag bits into an array, then into variables for readability
    float flagArray[MAX_EFFECTS]; unpackFlags(in_Normal.z, flagArray);
    float spriteFlag  = flagArray[0];
    float waveFlag    = flagArray[1];
    float shakeFlag   = flagArray[2];
    float rainbowFlag = flagArray[3];
    float wobbleFlag  = flagArray[4];
    float pulseFlag   = flagArray[5];
    float wheelFlag   = flagArray[6];
    float cycleFlag   = flagArray[7];
    float jitterFlag  = flagArray[8];
    float blinkFlag   = flagArray[9];
    
    //Use the input vertex position from the vertex attributes. We ignore the z-component because it's used for other data
    vec2 pos = in_Position.xy;
    
    
    
    //Unpack the glyph centre
    vec2 centreDelta = vec2(in_Normal.x, in_Colour2.y);
    
    
    
    vec2 centre;
    
    //If we have a valid Bezier curve, apply it
    if ((u_aBezier[2].x != 0.0) || (u_aBezier[2].y != 0.0))
    {
        centre = bezier(in_Position.x, u_aBezier[0], u_aBezier[1], u_aBezier[2]);
        
        vec2 orientation = bezierDerivative(in_Position.x, u_aBezier[0], u_aBezier[1], u_aBezier[2]);
        pos = rotate_by_vector(centre - centreDelta, centre, normalize(orientation));
        
        vec2 perpendicular = normalize(vec2(-u_aBezier[2].y, u_aBezier[2].x));
        pos += in_Position.y*perpendicular;
    }
    else
    {
        centre = pos + centreDelta;
    }
    
    
    
    //Colour
    v_vColour = in_Colour;
    
    if (pos.y > centre.y) v_vColour.rgb = mix(v_vColour.rgb, u_vGradient.rgb, u_vGradient.a);
    
    if (cycleFlag > 0.5) v_vColour = cycle(characterIndex, cycleSpeed, cycleSaturation, cycleValue, v_vColour); //Cycle colours through the defined palette
    v_vColour = rainbow(characterIndex, rainbowFlag*rainbowWeight, rainbowSpeed, v_vColour); //Cycle colours for the rainbow effect
    v_vColour *= u_vColourBlend; //And then blend with the blend colour/alpha
    if (spriteFlag > 0.5) v_vColour.a *= filterSprite(in_Normal.y); //Use packed sprite data to filter out sprite frames that we don't want
    if ((blinkFlag > 0.5) && (u_fBlinkState < 0.5)) v_vColour.a = 0.0;
    
    
    
    //Vertex animation
    pos.xy = wobble(pos, centre, wobbleFlag*wobbleAngle, wobbleFrequency);
    pos.xy = pulse( pos, centre, characterIndex, pulseFlag*pulseScale, pulseSpeed);
    if (jitterFlag > 0.5) pos.xy = jitter(pos, centre, characterIndex, jitterMinimum, jitterMaximum, jitterSpeed); //Apply the jitter effect
    
    
    
    //Apply fade (if we're given a method)
    int easeMethod = u_iTypewriterMethod;
    
    bool fadeOut = (easeMethod >= EASE_METHOD_COUNT);
    if (fadeOut) easeMethod -= EASE_METHOD_COUNT;
    
    if (easeMethod > 0)
    {
        float fadeIndex = characterIndex + 1.0;
        if (u_iTypewriterCharMax > 0) fadeIndex = float(u_iTypewriterCharMax) - fadeIndex;
        
        float time = fade(u_fTypewriterWindowArray, u_fTypewriterSmoothness, fadeIndex, fadeOut);
        
        if (u_fTypewriterAlphaDuration == 0.0)
        {
            if (time <= 0.0) v_vColour.a = 0.0;
        }
        else
        {
            v_vColour.a *= clamp(time / u_fTypewriterAlphaDuration, 0.0, 1.0);
        }
        
             if (easeMethod ==  2) { time = 1.0 - easeQuad(   1.0 - time); }
        else if (easeMethod ==  3) { time = 1.0 - easeCubic(  1.0 - time); }
        else if (easeMethod ==  4) { time = 1.0 - easeQuart(  1.0 - time); }
        else if (easeMethod ==  5) { time = 1.0 - easeQuint(  1.0 - time); }
        else if (easeMethod ==  6) { time = 1.0 - easeSine(   1.0 - time); }
        else if (easeMethod ==  7) { time = 1.0 - easeExpo(   1.0 - time); }
        else if (easeMethod ==  8) { time = 1.0 - easeCirc(   1.0 - time); }
        else if (easeMethod ==  9) { time = 1.0 - easeBack(   1.0 - time); }
        else if (easeMethod == 10) { time = 1.0 - easeElastic(1.0 - time); }
        else if (easeMethod == 11) { time = 1.0 - easeBounce( 1.0 - time); }
        else if (easeMethod == 12) { /*Custom ease slot 1*/ }
        else if (easeMethod == 13) { /*Custom ease slot 2*/ }
        else if (easeMethod == 14) { /*Custom ease slot 3*/ }
        
        pos = scale(pos, centre, mix(u_vTypewriterStartScale, vec2(1.0), time));
        pos = rotate(pos, centre, mix(-u_fTypewriterStartRotation, 0.0, time));
        pos.xy += mix(u_vTypewriterStartPos, vec2(0.0), time);
    }
    
    
    
    //Vertex
    pos.xy = wave(  pos, characterIndex, waveFlag*waveAmplitude, waveFrequency, waveSpeed); //Apply the wave effect
    pos.xy = wheel( pos, characterIndex, wheelFlag*wheelAmplitude, wheelFrequency, wheelSpeed); //Apply the wheel effect
    pos.xy = shake( pos, characterIndex, shakeFlag*shakeAmplitude, shakeSpeed); //Apply the shake effect
    
    
    
    //Final positioning
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*vec4(pos, 0.0, 1.0);
    
    
    
    //Texture
    v_vTexcoord = in_TextureCoord;
}