const int MAX_FLAGS = 4;
//By default, the flags are:
//0 = is an animated sprite
//1 = wave
//2 = shake
//3 = rainbow

const int MAX_DATA_FIELDS = 7;
//By default, the data fields are:
//0 = wave size
//1 = wave frequency
//2 = wave speed
//3 = shake size
//4 = shake speed
//5 = rainbow weight

attribute vec3 in_Position;
attribute vec3 in_Normal; //Character / Line index / Flags
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4  u_vColourBlend;
uniform float u_fTime;

uniform float u_fTypewriterMethod;
uniform float u_fTypewriterT;
uniform float u_fTypewriterSmoothness;
uniform float u_fTypewriterCount;

uniform float u_aDataFields[MAX_DATA_FIELDS];

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 P = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(P - K.xxx, 0.0, 1.0), c.y);
}

void unpackFlags(float flagValue, inout float array[MAX_FLAGS])
{
    float check = pow(2.0, float(MAX_FLAGS)-1.0);
    for(int i = MAX_FLAGS-1; i >= 0; i--)
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

float wave(float amplitude, float frequency, float speed)
{
    return amplitude*sin(frequency*in_Normal.x + speed*u_fTime);
}

vec2 shake(float magnitude, float speed)
{
    float time = speed*u_fTime + 0.5;
    float floorTime = floor(time);
    float merge = 1.0 - abs(2.0*(time - floorTime) - 1.0);
    
    //Use some misc prime numbers to try to get a varied-looking shake
    vec2 delta = vec2(rand(vec2(149.0*in_Normal.x + 13.0*floorTime, 727.0*in_Normal.x - 331.0*floorTime)),
                      rand(vec2(501.0*in_Normal.x - 19.0*floorTime, 701.0*in_Normal.x + 317.0*floorTime)));
    
    return magnitude*merge*(2.0*delta-1.0);
}

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

vec4 applyRainbow(float weight, float speed, vec4 colour)
{
    return vec4(mix(colour.rgb, hsv2rgb(vec3(in_Normal.x + speed*u_fTime, 1.0, 1.0)), weight), colour.a);
}

void applyTypewriterFade(float time, float smoothness, float param, inout vec4 colour)
{
    float multiplier = 1.0;
    
    if (smoothness > 0.0)
    {
        float adjustedTime = time*(1.0 + smoothness);
        multiplier = clamp((adjustedTime - param)/smoothness, 0.0, 1.0);
    }
    else
    {
        multiplier = 1.0 - step(time, param);
    }
        
    if (u_fTypewriterMethod >= 0.0) multiplier = 1.0 - multiplier;
    
    colour.a *= multiplier;
}

void main()
{
    //Unpack the flag value into an array
    float flagArray[MAX_FLAGS];
    unpackFlags(in_Normal.z, flagArray);
    
    //Vertex animation
    vec4 pos = vec4(in_Position.xyz, 1.0);
    pos.y  += wave(flagArray[1]*u_aDataFields[0], u_aDataFields[1], u_aDataFields[2]);
    pos.xy += shake(flagArray[2]*u_aDataFields[3], u_aDataFields[4]);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * pos;
    
    //Colour
    v_vColour  = handleSprites(flagArray[0], in_Colour);
    v_vColour  = applyRainbow(flagArray[3]*u_aDataFields[5], u_aDataFields[6], v_vColour);
    v_vColour *= u_vColourBlend;
    
    //if (u_fTypewriterMethod != 0.0)
    //{
    //    applyTypewriterFade(u_fTypewriterT,
    //                        u_fTypewriterSmoothness,
    //                        ((abs(u_fTypewriterMethod) == 1.0)? in_Normal.x : in_Normal.y)/u_fTypewriterCount,
    //                        v_vColour);
    //}
    
    //Texture
    v_vTexcoord = in_TextureCoord;
}