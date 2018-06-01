attribute vec3 in_Position;
attribute vec2 in_TextureCoord;
attribute vec4 in_Colour;
attribute vec4 in_Colour2; //Character / Word / Line index / Sprite+Image index
attribute vec3 in_Colour3; //Extra data

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec4 v_vColour2;
varying vec3 v_vColour3;

void main() {
    
    v_vColour2 = in_Colour2;
    v_vColour3 = in_Colour3;
    
    vec4 pos = vec4( in_Position.xyz, 1.0 );
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
    
}