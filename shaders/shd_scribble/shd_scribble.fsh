//   @jujuadams   v6.0.14a   2020-10-18
precision highp float;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_vFog;

void main()
{
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, u_vFog.rgb, u_vFog.a);
}