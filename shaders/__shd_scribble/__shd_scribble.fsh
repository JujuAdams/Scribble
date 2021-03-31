//   @jujuadams   v7.1.2   2020-03-16
precision highp float;

#define PREMULTIPLY_ALPHA false

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_vFog;

void main()
{
    gl_FragColor = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor.rgb = mix(v_vColour.rgb*gl_FragColor.rgb, u_vFog.rgb, u_vFog.a);
    
    if (PREMULTIPLY_ALPHA)
    {
        gl_FragColor *= v_vColour.a;
    }
    else
    {
        gl_FragColor.a *= v_vColour.a;
    }
}