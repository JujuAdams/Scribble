varying vec2 v_vTexcoord;
varying vec4 v_vColour;

vec3 srgb_from_linear_srgb(vec3 x) {

    vec3 xlo = 12.92*x;
    vec3 xhi = 1.055 * pow(x, vec3(0.4166666666666667)) - 0.055;
    
    return mix(xlo, xhi, step(vec3(0.0031308), x));

}

vec3 oklab_to_rgb(vec3 c) 
{
    float l_ = c.x + 0.3963377774 * c.y + 0.2158037573 * c.z;
    float m_ = c.x - 0.1055613458 * c.y - 0.0638541728 * c.z;
    float s_ = c.x - 0.0894841775 * c.y - 1.2914855480 * c.z;

    float l = l_*l_*l_;
    float m = m_*m_*m_;
    float s = s_*s_*s_;

    vec3 rgbResult;
    rgbResult.r = + 4.0767245293*l - 3.3072168827*m + 0.2307590544*s;
    rgbResult.g = - 1.2681437731*l + 2.6093323231*m - 0.3411344290*s;
    rgbResult.b = - 0.0041119885*l - 0.7034763098*m + 1.7068625689*s;
    
    rgbResult = srgb_from_linear_srgb(rgbResult);
    
    return rgbResult;
}

void main()
{
    gl_FragColor = vec4(oklab_to_rgb(v_vColour.rgb), v_vColour.a)*texture2D(gm_BaseTexture, v_vTexcoord);
}