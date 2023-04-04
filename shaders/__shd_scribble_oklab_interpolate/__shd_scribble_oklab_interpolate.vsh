attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

vec3 linear_srgb_from_srgb(vec3 x) {

    vec3 xlo = x / 12.92;
    vec3 xhi = pow((x + 0.055)/(1.055), vec3(2.4));
    
    return mix(xlo, xhi, step(vec3(0.04045), x));

}

vec3 rgb_to_oklab(vec3 c) 
{
    c = linear_srgb_from_srgb(c);
    
    float l = 0.4121656120 * c.r + 0.5362752080 * c.g + 0.0514575653 * c.b;
    float m = 0.2118591070 * c.r + 0.6807189584 * c.g + 0.1074065790 * c.b;
    float s = 0.0883097947 * c.r + 0.2818474174 * c.g + 0.6302613616 * c.b;

    float l_ = pow(l, 1./3.);
    float m_ = pow(m, 1./3.);
    float s_ = pow(s, 1./3.);

    vec3 labResult;
    labResult.x = 0.2104542553*l_ + 0.7936177850*m_ - 0.0040720468*s_;
    labResult.y = 1.9779984951*l_ - 2.4285922050*m_ + 0.4505937099*s_;
    labResult.z = 0.0259040371*l_ + 0.7827717662*m_ - 0.8086757660*s_;
    return labResult;
}

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vTexcoord = in_TextureCoord;
    v_vColour   = vec4(rgb_to_oklab(in_Colour.rgb), in_Colour.a);
}
