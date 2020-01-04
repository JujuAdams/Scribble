varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_vTexel; //The size of a texel for this texture. Unused by default, but might be of use for custom effects

void main()
{
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
}