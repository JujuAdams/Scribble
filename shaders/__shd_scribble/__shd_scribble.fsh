//   @jujuadams   v7.0.3   2020-01-02
precision highp float;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_vFog;

void main()
{
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, u_vFog.rgb, u_vFog.a);
}