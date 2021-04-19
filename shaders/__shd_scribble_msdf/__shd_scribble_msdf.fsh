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
uniform vec4  u_vFog;
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
    return median(texture2D(gm_BaseTexture, v_vTexcoord - u_vTexel*texOffset).rgb) - 0.5;
}

float MSDFAlpha(float signedDistance, float pixelSize, float outerBorder)
{
    return clamp(u_fMSDFRange*pixelSize*signedDistance + outerBorder + 0.5, 0.0, 1.0);
}

void main()
{
    float distBase = MSDFSignedDistance(vec2(0.0));
    float alphaBase = MSDFAlpha(distBase, v_fPixelScale, 0.0);
    gl_FragColor = vec4(v_vColour.rgb, alphaBase);
    
    if (u_fBorderThickness > 0.0)
    {
        float alphaBorder = MSDFAlpha(distBase, v_fPixelScale, PROPORTIONAL_BORDER_SCALE? (v_fPixelScale*u_fBorderThickness) : u_fBorderThickness);
        gl_FragColor.rgb = mix(u_vBorderColour, gl_FragColor.rgb, gl_FragColor.a);
        gl_FragColor.a = max(gl_FragColor.a, alphaBorder);
    }
    
    if (length(u_vShadowOffset) > 0.0)
    {
        float alphaShadow = u_vShadowColour.a*MSDFAlpha(MSDFSignedDistance(u_vShadowOffset/v_fPixelScale), v_fPixelScale, PROPORTIONAL_BORDER_SCALE? (v_fPixelScale*u_fBorderThickness) : u_fBorderThickness);
        gl_FragColor.rgb = mix(u_vShadowColour.rgb, gl_FragColor.rgb, gl_FragColor.a);
        gl_FragColor.a = max(gl_FragColor.a, alphaShadow);
    }
    
    gl_FragColor.rgb = mix(gl_FragColor.rgb, u_vFog.rgb, u_vFog.a);
    
    if (PREMULTIPLY_ALPHA)
    {
        gl_FragColor *= v_vColour.a;
    }
    else
    {
        gl_FragColor.a *= v_vColour.a;
    }
}