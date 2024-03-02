varying vec4 v_vColour;
varying vec2 v_vTexcoord;

void main()
{
    gl_FragColor = v_vColour*texture2D(gm_BaseTexture, v_vTexcoord);
}
