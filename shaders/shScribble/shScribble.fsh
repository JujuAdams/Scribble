varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fPremultiplyAlpha;

void main()
{
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    if (u_fPremultiplyAlpha > 0.5) gl_FragColor.rgb *= gl_FragColor.a;
}