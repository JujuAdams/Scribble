attribute vec3 in_Position;
attribute vec2 in_TextureCoord;
attribute vec4 in_Colour;
attribute vec4 in_Colour2; //Character / Line index / Unused / Unused
attribute vec3 in_Colour3; //Extra data (wave/shake/rainbow)



varying vec2 v_vTexcoord;
varying vec4 v_vColour;



uniform float u_fPremultiplyAlpha;

uniform vec4 u_vColour;

uniform vec3  u_vOptions;
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
    float charPc = in_Colour2.r;
    float linePc = in_Colour2.g;
    
    float wave    = in_Colour3.r*u_vOptions.r;
    float shake   = in_Colour3.g*u_vOptions.g;
    float rainbow = in_Colour3.b*u_vOptions.b;
    
    
    
    vec4 pos = vec4( in_Position.xyz, 1.0 );
    pos.xy += shake*( vec2( rand( vec2( charPc + 2.*u_fTime, charPc - .5*u_fTime ) ), rand( vec2( charPc - 2.*u_fTime, charPc + .5*u_fTime ) ) ) - 0.5 );
    pos.y += wave*sin( 10.*( charPc + u_fTime ) );
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * pos;
    
    
    
    v_vColour = in_Colour;
    v_vColour.rgb = mix( v_vColour.rgb, hsv2rgb( vec3( charPc + u_fTime, 1., 1. ) ), rainbow );
    v_vColour.rgb *= u_vColour.rgb;
    
    
    
    float alpha = u_vColour.a;
    
    if ( u_fCharFadeT < (1. + u_fCharFadeSmoothness) )
    {
         alpha *= clamp( ( u_fCharFadeT - charPc ) / u_fCharFadeSmoothness, 0., 1. );
    }
    else
    {
         alpha *= 1. - clamp( ( u_fCharFadeT - (1. + u_fCharFadeSmoothness) - charPc ) / u_fCharFadeSmoothness, 0., 1. );
    }
    
    if ( u_fLineFadeT < (1. + u_fLineFadeSmoothness) )
    {
         alpha *= clamp( ( u_fLineFadeT - linePc ) / u_fLineFadeSmoothness, 0., 1. );
    }
    else
    {
         alpha *= 1. - clamp( ( u_fLineFadeT - (1. + u_fLineFadeSmoothness) - linePc ) / u_fLineFadeSmoothness, 0., 1. );
    }
    
    v_vColour.a *= alpha;
    if ( u_fPremultiplyAlpha > 0.5 ) v_vColour.rgb *= v_vColour.a;
    
    
    
    v_vTexcoord = in_TextureCoord;
}