//   @jujuadams   v8.0.0   2021-12-15
precision highp float;

varying vec2 v_vTexcoord;
varying vec4 v_vColor;

uniform vec2 u_vTexel;
uniform vec4 u_vShadowColor;
uniform vec2 u_vShadowDelta;

void main()
{
    vec4 newColor = vec4(u_vShadowColor.rgb, u_vShadowColor.a*texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel*u_vShadowDelta).a);
    vec4 sample = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = v_vColor*mix(newColor, sample, sample.a);
}