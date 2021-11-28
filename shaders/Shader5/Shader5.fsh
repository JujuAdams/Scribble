varying vec2  v_vTexcoord;
varying vec4  v_vColour;

const float u_fMSDFRange  = 10.0;
const float v_fPixelScale =  1.0;

float median(vec3 v)
{
    return max(min(v.x, v.y), min(max(v.x, v.y), v.z));
}

float MSDFSignedDistance(vec4 sample)
{
    return median(sample.rgb) - 0.5;
}

float MSDFAlpha(float signedDistance, float pixelSize, float outerBorder)
{
    return clamp(u_fMSDFRange*pixelSize*signedDistance + outerBorder + 0.5, 0.0, 1.0);
}

void main()
{
    vec4 sample = texture2D(gm_BaseTexture, v_vTexcoord);
    float distBase = MSDFSignedDistance(sample);
    float alphaBase = MSDFAlpha(distBase, v_fPixelScale, 0.0);
    gl_FragColor = vec4(v_vColour.rgb, alphaBase);
}