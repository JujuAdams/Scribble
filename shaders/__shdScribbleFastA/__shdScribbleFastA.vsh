attribute vec2 in_Position;
attribute vec2 in_TextureCoord;

varying vec4 v_vColour;
varying vec2 v_vTexcoord;

uniform vec4 u_vPositionAlphaScale;
uniform int  u_iColour;

void main()
{
    //Unpack the colour integer
    //TODO - Surely there's a better way of doing this
    int colourB = (u_iColour / 256) / 256;
    int colourG = (u_iColour / 256) - colourB*256;
    int colourR = u_iColour - colourB*256*256 - colourG*256;
    
    v_vColour.rgb = vec3(colourR, colourG, colourB) / 255.0;
    v_vColour.a = u_vPositionAlphaScale.z;
    
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*vec4(in_Position*u_vPositionAlphaScale.w + u_vPositionAlphaScale.xy, 0.0, 1.0);
    v_vTexcoord = in_TextureCoord;
}
