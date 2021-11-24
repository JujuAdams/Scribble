//   @jujuadams   v7.1.2   2021-03-16
precision highp float;

#define PROPORTIONAL_BORDER_SCALE false
#define PREMULTIPLY_ALPHA false

varying vec2  v_vTexcoord;
varying vec4  v_vColour;
varying float v_fPixelScale;
varying float v_fTextScale;

uniform vec2  u_vTexel;
uniform float u_fMSDFRange;
uniform float u_fMSDFThicknessOffset;
uniform vec4  u_vShadowColour;
uniform vec3  u_vShadowOffsetAndSoftness;
uniform vec3  u_vBorderColour;
uniform float u_fBorderThickness;
uniform float u_fSecondDraw;

float median(vec3 v)
{
    return max(min(v.x, v.y), min(max(v.x, v.y), v.z));
}

float MSDFSignedDistance(vec2 texOffset)
{
    return median(texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel*texOffset).rgb) + u_fMSDFThicknessOffset - 0.5;
}

//TODO - Need to find out why MTSDF atlases are wrong before this feature can be used
//
// float SDFSignedDistance(vec2 texOffset)
// {
//     return texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel*texOffset).a + u_fMSDFThicknessOffset - 0.5;
// }

float MSDFAlpha(float signedDistance, float pixelSize, float outerBorder)
{
    return clamp(u_fMSDFRange*pixelSize*signedDistance + outerBorder + 0.5, 0.0, 1.0);
}

void main()
{
    float distBase = MSDFSignedDistance(vec2(0.0));
    float alphaBase = MSDFAlpha(distBase, v_fPixelScale, 0.0);
    gl_FragColor = vec4(v_vColour.rgb, alphaBase);
    
    if (u_fSecondDraw < 0.5)
    {
        if (u_fBorderThickness > 0.0)
        {
            float alphaBorder = MSDFAlpha(distBase, v_fPixelScale, PROPORTIONAL_BORDER_SCALE? (v_fPixelScale*u_fBorderThickness) : u_fBorderThickness);
            gl_FragColor.rgb = mix(u_vBorderColour, gl_FragColor.rgb, gl_FragColor.a);
            gl_FragColor.a = max(gl_FragColor.a, alphaBorder);
        }
        
        if (u_vShadowColour.a > 0.0)
        {
            float shadowDist = MSDFSignedDistance(u_vShadowOffsetAndSoftness.xy/v_fPixelScale);
            float alphaShadow = u_vShadowColour.a*(1.0 - min(1.0, -2.0*shadowDist/u_vShadowOffsetAndSoftness.z));
            //Old method = MSDFAlpha(shadowDist, v_fPixelScale, PROPORTIONAL_BORDER_SCALE? (v_fPixelScale*u_fBorderThickness) : u_fBorderThickness);
            vec4 shadowColour = vec4(u_vShadowColour.rgb, alphaShadow);
            
            float preAlpha = gl_FragColor.a;
            gl_FragColor = mix(shadowColour, gl_FragColor, gl_FragColor.a);
            gl_FragColor.a = max(preAlpha, alphaShadow);
        }
    }
    
    if (PREMULTIPLY_ALPHA)
    {
        gl_FragColor *= v_vColour.a;
    }
    else
    {
        gl_FragColor.a *= v_vColour.a;
    }
}