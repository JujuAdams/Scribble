precision highp float;

attribute vec3  in_Position;     //{X, Y, Packed character & line index}
attribute vec3  in_Normal;       //{Animation index, Sprite data, Bitpacked effect flags}
attribute vec4  in_Colour;       //Colour
attribute vec2  in_TextureCoord; //UVs
attribute vec3  in_Colour2;      //{dX, dY, Cycle V-coord}

varying vec3  v_Position;    
varying vec3  v_Normal;      
varying vec4  v_Colour;      
varying vec2  v_TextureCoord;
varying vec3  v_Colour2;     

void main()
{
    gl_Position = gm_Matrices[MATRIX_PROJECTION]*gm_Matrices[MATRIX_VIEW]*vec4(in_Position.xy, 0.0, 1.0);
    
    v_Position     = in_Position;    
    v_Normal       = in_Normal;      
    v_Colour       = in_Colour;      
    v_TextureCoord = in_TextureCoord;
    v_Colour2      = in_Colour2;     
}