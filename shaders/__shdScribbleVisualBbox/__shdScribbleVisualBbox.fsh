varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fThreshold;

void main()
{
    if (texture2D(gm_BaseTexture, v_vTexcoord).a <= u_fThreshold)
    {
        gl_FragColor = vec4(1.0);
    }
    else
    {
        gl_FragColor = vec4(v_vTexcoord, 1.0 - v_vTexcoord);
    }
}