precision highp float;

varying vec3  v_Position;    
varying vec3  v_Normal;      
varying vec4  v_Colour;      
varying vec2  v_TextureCoord;
varying vec3  v_Colour2;    

void main()
{
    gl_FragColor = texture2D(gm_BaseTexture, v_TextureCoord);
}