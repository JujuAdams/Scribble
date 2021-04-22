attribute vec3  in_Position;     //{X, Y, Packed character & line index}
attribute vec3  in_Normal;       //{dX, Sprite data, Bitpacked effect flags}
attribute vec4  in_Colour;       //Colour. This attribute is used for sprite data if this character is a sprite
attribute vec2  in_TextureCoord; //UVs
attribute vec2  in_Colour2;      //{Scale, dY}

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*vec4(in_Position.xy, 0.0, 1.0);
    
    v_vColour   = in_Colour;
    v_vTexcoord = in_TextureCoord;
    
    vec3 test1 = in_Normal;
    vec2 test2 = in_Colour2;
}
