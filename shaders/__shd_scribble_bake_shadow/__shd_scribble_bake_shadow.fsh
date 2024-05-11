//   @jujuadams   v8.0.0   2021-12-15
precision highp float;

const float PI = 3.14159265359;

varying vec2 v_vTexcoord;
varying vec4 v_vColor;

uniform vec2 u_vTexel;
uniform vec4 u_vShadowColor;
uniform vec2 u_vShadowDelta;

float InsideTexture(vec2 point)
{
    vec2 result = step(0.0, point) - step(1.0, point);
    return result.x*result.y;   
}

void main()
{
    vec2 texcoord = v_vTexcoord - u_vTexel*u_vShadowDelta;
    vec4 newColor = vec4(u_vShadowColor.rgb, u_vShadowColor.a*texture2D(gm_BaseTexture, texcoord).a*InsideTexture(texcoord));
    vec4 sample = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = v_vColor*mix(newColor, sample, sample.a);
    gl_FragColor.a = max(newColor.a,sample.a);
}