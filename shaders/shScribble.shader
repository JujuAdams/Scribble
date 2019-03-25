const int MAX_FLAGS = 6;       //Change SCRIBBLE_MAX_FLAGS in __scribble_config() if you change this value!
const int MAX_DATA_FIELDS = 6; //Change SCRIBBLE_MAX_DATA_FIELDS in __scribble_config() if you change this value!

attribute vec3 in_Position;
attribute vec3 in_Normal; //Character / Line index / Flags
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fPremultiplyAlpha;
uniform vec4  u_vColourBlend;
uniform float u_fTime;
uniform float u_fCharFadeT;
uniform float u_fCharFadeSmoothness;
uniform float u_fLineFadeT;
uniform float u_fLineFadeSmoothness;

uniform float u_aDataFields[MAX_DATA_FIELDS];
//By default, the data fields are:
//0 = wave size
//1 = wave frequency
//2 = wave speed
//3 = shake size
//4 = shake speed
//5 = rainbow weight

float rand( vec2 co ) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 hsv2rgb( vec3 c ) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 P = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(P - K.xxx, 0.0, 1.0), c.y);
}

void unpackFlags( float flagValue, inout float array[MAX_FLAGS] ) {
    float check = pow( 2.0, float(MAX_FLAGS)-1.0 );
    for( int i = MAX_FLAGS-1; i >= 0; i-- ) {
        if (flagValue >= check) {
            array[i] = 1.0;
            flagValue -= check;
        }
        check /= 2.0;
    }
}

void applyWave( float amplitude, float frequency, float speed, inout vec4 pos ) {
    pos.y += amplitude*sin( frequency*in_Normal.x + speed*u_fTime );
}

void applyShake( float magnitude, float speed, inout vec4 pos ) {
    float time = u_fTime*speed + 0.5;
    float floorTime = floor( time );
    float merge = 1.0 - abs(2.0*(time - floorTime) - 1.0);
    
    //Use some misc prime numbers to try to get a varied-looking shake
    vec2 delta = vec2( rand( vec2( 149.0*in_Normal.x + 13.0*floorTime, 727.0*in_Normal.x - 331.0*floorTime ) ),
                       rand( vec2( 501.0*in_Normal.x - 19.0*floorTime, 701.0*in_Normal.x + 317.0*floorTime ) ) );
    
    pos.xy += magnitude*merge*(2.0*delta-1.0);
}

void applyRainbow( float weight, inout vec4 colour ) {
    colour.rgb = mix( colour.rgb, hsv2rgb( vec3( in_Normal.x + u_fTime, 1.0, 1.0 ) ), weight );
}

void applyColourBlend( vec4 colourInput, inout vec4 colourTarget ) {
    colourTarget *= colourInput;
}

void applyPremultiplyAlpha( inout vec4 colour ) {
    if ( u_fPremultiplyAlpha > 0.5 ) colour.rgb *= colour.a;
}

void applyPerCharacterFade( float time, float smoothness, inout vec4 colour ) {
    if ( time < (1.0 + smoothness) ) {
         colour.a *= clamp( (time - in_Normal.x) / smoothness, 0.0, 1.0 );
    } else {
         colour.a *= 1.0 - clamp( (time - (1.0 + smoothness) - in_Normal.x) / smoothness, 0.0, 1.0 );
    }
}

void applyPerLineFade( float time, float smoothness, inout vec4 colour ) {
    if ( time < (1.0 + smoothness) ) {
         colour.a *= clamp( (time - in_Normal.y) / smoothness, 0.0, 1.0 );
    } else {
         colour.a *= 1.0 - clamp( (time - (1.0 + smoothness) - in_Normal.y) / smoothness, 0.0, 1.0 );
    }
}

void main() {
    //Unpack the flag value into an array
    float flagArray[MAX_FLAGS];
    unpackFlags( in_Normal.z, flagArray );
    
    //Vertex animation
    vec4 pos = vec4( in_Position.xyz, 1.0 );
    applyWave( flagArray[0]*u_aDataFields[0], u_aDataFields[1], u_aDataFields[2], pos );
    applyShake( flagArray[1]*u_aDataFields[3], u_aDataFields[4], pos );
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * pos;
    
    //Colour
    v_vColour = in_Colour;
    applyRainbow( flagArray[2]*u_aDataFields[5], v_vColour );
    applyColourBlend( u_vColourBlend, v_vColour );
    applyPerCharacterFade( u_fCharFadeT, u_fCharFadeSmoothness, v_vColour );
    applyPerLineFade( u_fLineFadeT, u_fLineFadeSmoothness, v_vColour );
    applyPremultiplyAlpha( v_vColour );
    
    //Texture
    v_vTexcoord = in_TextureCoord;
}
//######################_==_YOYO_SHADER_MARKER_==_######################@~varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
}
