attribute vec3 in_Position;
attribute vec3 in_Normal; //Character / Line index / (wave+shake+rainbow)
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;



varying vec2 v_vTexcoord;
varying vec4 v_vColour;



uniform float u_fPremultiplyAlpha;

uniform vec4 u_vColour;

uniform vec3  u_vOptions; //Wave size / Shake size / Rainbow weight
uniform float u_fTime;

uniform float u_fCharFadeT;
uniform float u_fCharFadeSmoothness;

uniform float u_fLineFadeT;
uniform float u_fLineFadeSmoothness;



float rand( vec2 co )
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 hsv2rgb( vec3 c )
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 P = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(P - K.xxx, 0.0, 1.0), c.y);
}



void main()
{
    float charPc = in_Normal.x;
    float linePc = in_Normal.y;
    float flags  = in_Normal.z;
    
    //Unpack flags into individual components
    float wave    = 0.0;
    float shake   = 0.0;
    float rainbow = 0.0;
    
    if (flags >= 4.0)
    {
        rainbow = u_vOptions.b;
        flags -= 4.0;
    }
    
    if (flags >= 2.0)
    {
        shake = u_vOptions.g;
        flags -= 2.0;
    }
    
    if (flags >= 1.0)
    {
        wave = u_vOptions.r;
        flags -= 1.0;
    }
    
    
    
    vec4 pos = vec4( in_Position.xyz, 1.0 );
    pos.xy += shake*( vec2( rand( vec2( charPc + 2.0*u_fTime, charPc - 0.5*u_fTime ) ), rand( vec2( charPc - 2.0*u_fTime, charPc + 0.5*u_fTime ) ) ) - 0.5 );
    pos.y += wave*sin( 10.*( charPc + u_fTime ) );
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * pos;
    
    
    
    v_vColour = in_Colour;
    v_vColour.rgb = mix( v_vColour.rgb, hsv2rgb( vec3( charPc + u_fTime, 1.0, 1.0 ) ), rainbow );
    v_vColour.rgb *= u_vColour.rgb;
    
    
    
    float alpha = u_vColour.a;
    
    if ( u_fCharFadeT < (1. + u_fCharFadeSmoothness) )
    {
         alpha *= clamp( ( u_fCharFadeT - charPc ) / u_fCharFadeSmoothness, 0.0, 1.0 );
    }
    else
    {
         alpha *= 1. - clamp( ( u_fCharFadeT - (1. + u_fCharFadeSmoothness) - charPc ) / u_fCharFadeSmoothness, 0.0, 1.0 );
    }
    
    if ( u_fLineFadeT < (1. + u_fLineFadeSmoothness) )
    {
         alpha *= clamp( ( u_fLineFadeT - linePc ) / u_fLineFadeSmoothness, 0.0, 1.0 );
    }
    else
    {
         alpha *= 1.0 - clamp( ( u_fLineFadeT - (1.0 + u_fLineFadeSmoothness) - linePc ) / u_fLineFadeSmoothness, 0.0, 1.0 );
    }
    
    v_vColour.a *= alpha;
    if ( u_fPremultiplyAlpha > 0.5 ) v_vColour.rgb *= v_vColour.a;
    
    
    
    v_vTexcoord = in_TextureCoord;
}