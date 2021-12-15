//   @jujuadams   v8.0.0   2021-12-15
precision highp float;

const float PI = 3.14159265359;

varying vec2 v_vTexcoord;
varying vec4 v_vColor;

uniform vec2 u_vTexel;
uniform vec3 u_vOutlineColor;

const int  u_iOutlineSamples = 8;
const int  u_iOutlineSize    = 2;

void main()
{
    vec4 outlineColor = vec4(u_vOutlineColor, 1.0);
    vec4 newColor = vec4(u_vOutlineColor, 0.0);
    
    for(int iAngle = 0; iAngle < u_iOutlineSamples; iAngle++)
    {
        float fAngle = 2.0*PI*float(iAngle) / float(u_iOutlineSamples);
        for(int radius = 1; radius <= u_iOutlineSize; radius++)
        {
            newColor = mix(newColor, outlineColor, texture2D(gm_BaseTexture, v_vTexcoord + u_vTexel*(float(radius)*vec2(cos(fAngle), sin(fAngle)))).a);
        }
    }
    
    vec4 sample = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = v_vColor*mix(newColor, sample, sample.a);
}