varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    gl_FragColor = v_vColour*vec4(vec3(texture2D(gm_BaseTexture, v_vTexcoord).a), 1.0);
}
