#extension GL_OES_standard_derivatives : enable

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_vTexel;

float median(vec3 v)
{
    return max(min(v.x, v.y), min(max(v.x, v.y), v.z));
}

void main()
{
    vec3 sample = texture2D(gm_BaseTexture, v_vTexcoord).rgb;
    float signedDist = median(sample);
    
    float dx = dFdx(v_vTexcoord.x)/u_vTexel.x;
    float dy = dFdy(v_vTexcoord.y)/u_vTexel.y;
    float alpha = clamp(0.5 + 4.0*inversesqrt(dx*dx + dy*dy)*(signedDist-0.5), 0.0, 1.0);
    gl_FragColor = vec4(v_vColour.rgb, v_vColour.a*alpha);
}