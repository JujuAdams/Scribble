#extension GL_OES_standard_derivatives : enable

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2  u_vTexel;
uniform float u_fMSDFRange;
uniform vec4  u_vShadowColour;
uniform vec2  u_vShadowOffset;
uniform vec3  u_vBorderColour;
uniform float u_fBorderThickness;

float median(vec3 v)
{
    return max(min(v.x, v.y), min(max(v.x, v.y), v.z));
}

float MSDFSignedDistance(vec2 texOffset)
{
    return median(texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel*texOffset*0.5).rgb) - 0.5;
}

float MSDFAlpha(float signedDistance, float pixelSize, float outerBorder)
{
    return clamp(u_fMSDFRange*pixelSize*signedDistance + outerBorder + 0.5, 0.0, 1.0);
}

void main()
{
    float dx = dFdx(v_vTexcoord.x)/u_vTexel.x;
    float dy = dFdy(v_vTexcoord.y)/u_vTexel.y;
    float pixelSize = inversesqrt(dx*dx + dy*dy);
    
    float distBase = MSDFSignedDistance(vec2(0.0));
    float alphaBase = MSDFAlpha(distBase, pixelSize, 0.0);
    gl_FragColor = vec4(v_vColour.rgb, v_vColour.a*alphaBase);
    
    if (u_fBorderThickness > 0.0)
    {
        float alphaBorder = MSDFAlpha(distBase, pixelSize, u_fBorderThickness);
        gl_FragColor.rgb = mix(u_vBorderColour, gl_FragColor.rgb, gl_FragColor.a);
        gl_FragColor.a = max(gl_FragColor.a, alphaBorder);
    }
    
    if (length(u_vShadowOffset) > 0.0)
    {
        float alphaShadow = u_vShadowColour.a*MSDFAlpha(MSDFSignedDistance(u_vShadowOffset), pixelSize, u_fBorderThickness);
        gl_FragColor.rgb = mix(u_vShadowColour.rgb, gl_FragColor.rgb, gl_FragColor.a);
        gl_FragColor.a = max(gl_FragColor.a, alphaShadow);
    }
    
    //float dx = dFdx(v_vTexcoord.x)/u_vTexel.x;
    //float dy = dFdy(v_vTexcoord.y)/u_vTexel.y;
    //float pixelDist = 20.0*inversesqrt(dx*dx + dy*dy);
    //
    //float alphaOuter = clamp(0.5 + pixelDist*(signedDist-0.5) + 3.0, 0.0, 1.0);
    //float alphaInner = clamp(0.5 + pixelDist*(signedDist-0.5)      , 0.0, 1.0);
    //
    //gl_FragColor = vec4(0.0);
    //gl_FragColor = mix(gl_FragColor, vec4(0.0, 0.0, 0.0, 1.0), alphaOuter);
    //gl_FragColor = mix(gl_FragColor, v_vColour, alphaInner);
}