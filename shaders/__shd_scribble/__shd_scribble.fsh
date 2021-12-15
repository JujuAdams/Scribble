//   @jujuadams   v8.0.0   2020-03-16
precision highp float;

#define PREMULTIPLY_ALPHA false

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    gl_FragColor = v_vColour*texture2D(gm_BaseTexture, v_vTexcoord);
    
    if (PREMULTIPLY_ALPHA)
    {
        gl_FragColor.rgb *= v_vColour.a;
    }
    else
    {
        gl_FragColor.a *= v_vColour.a;
    }
}