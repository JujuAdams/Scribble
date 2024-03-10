//   @jujuadams   v8.0.0   2021-12-15
precision highp float;

#define PROPORTIONAL_BORDER_SCALE false
#define PREMULTIPLY_ALPHA false

varying vec2  v_vTexcoord;
varying vec4  v_vColour;
varying float v_fPixelScale;
varying float v_fTextScale;

uniform vec2  u_vTexel;
uniform float u_fSDFRange;
uniform float u_fSDFThicknessOffset;
uniform vec4  u_vShadowColour;
uniform vec3  u_vShadowOffsetAndSoftness;
uniform vec3  u_vBorderColour;
uniform float u_fBorderThickness;
uniform float u_fSecondDraw;
uniform vec4  u_vFlash;

float median(vec3 v)
{
    return max(min(v.x, v.y), min(max(v.x, v.y), v.z));
}

float SDFSignedDistance(vec4 sample)
{
    return sample.a + u_fSDFThicknessOffset - 0.5;
}

float SDFAlpha(float signedDistance, float pixelSize, float outerBorder)
{
    return clamp(u_fSDFRange*pixelSize*signedDistance + outerBorder + 0.5, 0.0, 1.0);
}

float SDFAlphaSoft(float signedDistance, float pixelSize, float outerBorder, float softness)
{
    return clamp((u_fSDFRange*pixelSize*signedDistance + outerBorder)/softness + 0.5, 0.0, 1.0);
}

void main()
{
    vec4 sample = texture2D(gm_BaseTexture, v_vTexcoord);
    float distBase = SDFSignedDistance(sample);
    gl_FragColor = vec4(v_vColour.rgb, SDFAlpha(distBase, v_fPixelScale, 0.0));
    
    if (u_fSecondDraw < 0.5)
    {
        if (u_fBorderThickness > 0.0)
        {
            float borderDist = SDFSignedDistance(sample);
            float alphaBorder = SDFAlpha(borderDist, v_fPixelScale, PROPORTIONAL_BORDER_SCALE? (v_fPixelScale*u_fBorderThickness) : u_fBorderThickness);
            gl_FragColor.rgb = mix(u_vBorderColour, gl_FragColor.rgb, gl_FragColor.a);
            gl_FragColor.a = max(gl_FragColor.a, alphaBorder);
        }
        
        if (u_vShadowColour.a > 0.0)
        {
            vec4 shadowSample = texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel*u_vShadowOffsetAndSoftness.xy/v_fPixelScale);
            float shadowDist = SDFSignedDistance(shadowSample);
            float alphaShadow = SDFAlphaSoft(shadowDist, v_fPixelScale, PROPORTIONAL_BORDER_SCALE? (v_fPixelScale*u_fBorderThickness) : u_fBorderThickness, u_vShadowOffsetAndSoftness.z);
            
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