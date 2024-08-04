precision highp float;

const float PI = 3.14159265359;

varying vec2 v_vTexcoord;
varying vec4 v_vColor;

uniform vec2 u_vTexel;
uniform vec2 u_vShadowDelta;

const int u_iOutlineSamples = 4;
const int u_iOutlineSize    = 1;

float InsideTexture(vec2 point)
{
    vec2 result = step(0.0, point) - step(1.0, point);
    return result.x*result.y;   
}

void main()
{
    vec2 shadowTexcoord = v_vTexcoord - u_vTexel*u_vShadowDelta;
    
    float outlineAlpha = 0.0;
    for(int iAngle = 0; iAngle < u_iOutlineSamples; iAngle++)
    {
        float angle = 2.0*PI*float(iAngle) / float(u_iOutlineSamples);
        for(int radius = 1; radius <= u_iOutlineSize; radius++)
        {
            outlineAlpha = mix(outlineAlpha, 1.0, texture2D(gm_BaseTexture, v_vTexcoord + u_vTexel*(float(radius)*vec2(cos(angle), sin(angle)))).a);
        }
    }
    
    gl_FragColor = vec4(texture2D(gm_BaseTexture, v_vTexcoord).a,
                        outlineAlpha,
                        texture2D(gm_BaseTexture, shadowTexcoord).a*InsideTexture(shadowTexcoord).a,
                        1.0);
}