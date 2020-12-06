#extension GL_OES_standard_derivatives : enable

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

float median(vec3 v)
{
    return max(min(v.x, v.y), min(max(v.x, v.y), v.z));
}

void main()
{
    vec3 sample = texture2D(gm_BaseTexture, v_vTexcoord).rgb;
    float signedDist = median(sample);
    
    float width = fwidth(signedDist);
    float alpha = smoothstep(0.5 - width, 0.5 + width, signedDist);
    gl_FragColor = vec4(v_vColour.rgb, v_vColour.a*alpha);
}