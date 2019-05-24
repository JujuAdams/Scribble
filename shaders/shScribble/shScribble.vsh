const int MAX_FLAGS = 6;       //Change SCRIBBLE_MAX_FLAGS in __scribble_config() if you change this value!
//By default, the flags are:
//0 = is an animated sprite
//1 = wave
//2 = shake
//3 = rainbow
//4 = wobble
//6 = swell
const int MAX_DATA_FIELDS = 11; //Change SCRIBBLE_MAX_DATA_FIELDS in __scribble_config() if you change this value!
//By default, the data fields are:
// 0 = wave size
// 1 = wave frequency
// 2 = wave speed
// 3 = shake size
// 4 = shake speed
// 5 = rainbow weight
// 6 = rainbow speed
// 7 = wobble angle
// 8 = wobble frequency
// 9 = swell scale
//10 = swell speed
const float MAX_LINES = 1000.0; //Change SCRIBBLE_MAX_LINES in __scribble_config() if you change this value!



attribute vec3 in_Position; // dx, dy, Packed character/line percentages
attribute vec3 in_Normal;   // cX, cY, Packed flags
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;



varying vec2 v_vTexcoord;
varying vec4 v_vColour;



uniform vec4  u_vColourBlend;
uniform float u_fTime;
uniform float u_fCharFadeT;
uniform float u_fCharFadeSmoothness;
uniform float u_fCharFadeCount;
uniform float u_fLineFadeT;
uniform float u_fLineFadeSmoothness;
uniform float u_fLineFadeCount;
uniform float u_fZ;
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

void applyWave(float charPC, float amplitude, float frequency, float speed, inout vec4 pos)
{
    pos.y += amplitude*sin(frequency*charPC + speed*u_fTime);
}

void applyShake(float charPC, float magnitude, float speed, inout vec4 pos)
{
    float time = speed*u_fTime + 0.5;
    float floorTime = floor(time);
    float merge = 1.0 - abs(2.0*(time - floorTime) - 1.0);
    
    //Use some misc prime numbers to try to get a varied-looking shake
    vec2 delta = vec2(rand(vec2(149.0*charPC + 13.0*floorTime, 727.0*charPC - 331.0*floorTime)),
                      rand(vec2(501.0*charPC - 19.0*floorTime, 701.0*charPC + 317.0*floorTime)));
    
    pos.xy += magnitude*merge*(2.0*delta-1.0);
}

void applySprite(float isSprite, inout vec4 colour)
{
    if (isSprite == 1.0)
    {
        float myImage    = in_Colour.r*255.0;     //First byte is the index of this sprite
        float imageMax   = 1.0+in_Colour.g*255.0; //Second byte is the maximum number of images in the sprite
        float imageSpeed = in_Colour.b;           //Third byte is half of the image speed
        float imageStart = in_Colour.a*255.0;     //Fourth byte is the image offset
        
        float displayImage = floor(mod(imageSpeed*u_fTime + imageStart, imageMax));
        colour = vec4((abs(myImage-displayImage) < 1.0/255.0)? 1.0 : 0.0);
    }
}

void applyRainbow(float charPC, float weight, float speed, inout vec4 colour)
{
    colour.rgb = mix(colour.rgb, hsv2rgb(vec3(charPC + speed*u_fTime, 1.0, 1.0)), weight);
}

void applyColourBlend(vec4 colourInput, inout vec4 colourTarget)
{
    colourTarget *= colourInput;
}

void applyTypewriterFade(float time, float smoothness, float param, inout vec4 colour)
{
    if (time < 1.0)
    {
         float adjustedTime = time*(1.0 + smoothness);
         colour.a *= clamp((adjustedTime - param)/smoothness, 0.0, 1.0);
    }
    else
    {
         float adjustedTime = (time - 1.0)*(1.0 + smoothness);
         colour.a *= 1.0 - clamp((adjustedTime - param)/smoothness, 0.0, 1.0);
    }
}

void rotateCharacter(inout vec4 position, vec2 centre, float angle)
{
    vec2 delta = position.xy - centre;
    float _sin = sin(0.00872664625*angle);
    float _cos = cos(0.00872664625*angle);
    position.xy = centre + vec2(delta.x*_cos - delta.y*_sin, delta.x*_sin + delta.y*_cos);
}

void scaleCharacter(inout vec2 position, vec2 centre, float scale)
{
    position = centre + scale*(position - centre);
}



void main()
{
    //Unpack character and line percentages
    float charPC = fract(in_Position.z*0.1)*10.0;
    float linePC = floor(in_Position.z*0.1)*10.0 / MAX_LINES;
    
    //Unpack the flag value into an array
    float flagArray[MAX_FLAGS];
    unpackFlags(in_Normal.z, flagArray);
    
    //Vertex animation
    vec4 pos = vec4(in_Position.xy + in_Normal.xy, u_fZ, 1.0);
    scaleCharacter(pos.xy, in_Normal.xy, 1.0 + flagArray[5]*u_aDataFields[9]*(0.5 + 0.5*sin(u_aDataFields[10]*(250.0*charPC - u_fTime))));
    rotateCharacter(pos, in_Normal.xy, flagArray[4]*u_aDataFields[7]*sin(u_aDataFields[8]*u_fTime));
    applyWave(charPC, flagArray[1]*u_aDataFields[0], u_aDataFields[1], u_aDataFields[2], pos);
    applyShake(charPC, flagArray[2]*u_aDataFields[3], u_aDataFields[4], pos);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * pos;
    
    //Colour
    v_vColour = in_Colour;
    applySprite(flagArray[0], v_vColour);
    applyRainbow(charPC, flagArray[3]*u_aDataFields[5], u_aDataFields[6], v_vColour);
    applyColourBlend(u_vColourBlend, v_vColour);
    applyTypewriterFade(u_fCharFadeT, u_fCharFadeSmoothness, charPC/u_fCharFadeCount, v_vColour);
    applyTypewriterFade(u_fLineFadeT, u_fLineFadeSmoothness, linePC/u_fLineFadeCount, v_vColour);
    
    //Texture
    v_vTexcoord = in_TextureCoord;
}