varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying float v_fLine;
varying float v_fIndex;

uniform float u_fTime;
uniform float u_fMaxTime;
uniform float u_fSmoothness;
uniform vec4  u_vColour;
uniform float u_fRainbowTime;

//This is stolen from somewhere too, though I forget where
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    
    vec4 colour = v_vColour;
    if ( v_vNormal.x > 0.0 ) colour.rgb = hsv2rgb( vec3( u_fRainbowTime, 1.0, 1.0 ) );
    gl_FragColor = u_vColour * colour * texture2D( gm_BaseTexture, v_vTexcoord );
    
}