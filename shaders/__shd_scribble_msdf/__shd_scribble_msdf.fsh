//   @jujuadams   v7.0.0   2020-10-03
precision highp float;

#extension GL_OES_standard_derivatives : enable

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2  u_vTexel;
uniform float u_fMSDFRange;
uniform vec4  u_vFog;

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
    //TODO - Mac/iOS have issues with this right now. Figure out a way to get around that
    float dx = dFdx(v_vTexcoord.x)/u_vTexel.x;
    float dy = dFdy(v_vTexcoord.y)/u_vTexel.y;
    float pixelSize = inversesqrt(dx*dx + dy*dy);
    
    float distBase = MSDFSignedDistance(vec2(0.0));
    float alphaBase = MSDFAlpha(distBase, pixelSize, 0.0);
    gl_FragColor = vec4(v_vColour.rgb, alphaBase);
    
    gl_FragColor.a *= v_vColour.a;
    gl_FragColor.rgb = mix(gl_FragColor.rgb, u_vFog.rgb, u_vFog.a);
}