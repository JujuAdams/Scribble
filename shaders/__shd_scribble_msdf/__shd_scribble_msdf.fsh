//   @jujuadams   v8.0.0   2021-12-15
precision highp float;

#define PREMULTIPLY_ALPHA false

varying vec2  v_vTexcoord;
varying vec4  v_vColour;
varying float v_fPixelScale;

uniform vec2  u_vTexel;
uniform float u_fMSDFRange;
uniform float u_fMSDFThicknessOffset;
uniform vec4  u_vShadowColour;
uniform vec3  u_vShadowOffsetAndSoftness;
uniform vec3  u_vBorderColour;
uniform float u_fBorderThickness;
uniform float u_fSecondDraw;
uniform vec4  u_vFlash;

float SDFValue(vec2 texcoord)
{
    vec4 sample = texture2D(gm_BaseTexture, texcoord);
    return max(sample.r, max(sample.g, sample.b));
}

void main()
{
    float smoothness = 0.5;
    
    float baseDist = SDFValue(v_vTexcoord);
    float spread = max(fwidth(baseDist), 0.001);    
    
    float alpha = smoothstep(0.5 - smoothness*spread, 0.5 + smoothness*spread, baseDist);   
    gl_FragColor = vec4(v_vColour.rgb, alpha*v_vColour.a);
    
    if (u_fSecondDraw < 0.5)
    {
        float borderOffset = u_fBorderThickness*length(fwidth(v_vTexcoord)/u_vTexel);
        
        if (u_fBorderThickness > 0.0)
        {
            gl_FragColor.rgb = mix(u_vBorderColour, gl_FragColor.rgb, gl_FragColor.a);
            gl_FragColor.a = max(gl_FragColor.a, smoothstep(0.5 - smoothness*spread, 0.5 + smoothness*spread, baseDist + borderOffset));
        }
        
        if (u_vShadowColour.a > 0.0)
        {
            float alphaShadow = smoothstep(0.5 - spread*u_vShadowOffsetAndSoftness.z, 0.5 + spread*u_vShadowOffsetAndSoftness.z, SDFValue(v_vTexcoord - u_vShadowOffsetAndSoftness.xy*fwidth(v_vTexcoord)) + borderOffset);   
            float preAlpha = gl_FragColor.a;
            gl_FragColor = mix(vec4(u_vShadowColour.rgb, alphaShadow), gl_FragColor, gl_FragColor.a);
            gl_FragColor.a = max(preAlpha, u_vShadowColour.a*alphaShadow);
        }
    }
    
    gl_FragColor.rgb = mix(gl_FragColor.rgb, u_vFlash.rgb, u_vFlash.a);
    gl_FragColor.a *= v_vColour.a;
    
    if (PREMULTIPLY_ALPHA)
    {
        gl_FragColor.rgb *= gl_FragColor.a;
    }
}
