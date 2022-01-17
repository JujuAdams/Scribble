/// @param offset

function scribble_msdf_thickness_offset(_offset)
{
    global.__scribble_msdf_thickness_offset = _offset;
    
    //TODO - Optimise
    shader_set(__shd_scribble_msdf);
    shader_set_uniform_f(global.__scribble_msdf_u_fMSDFThicknessOffset, _offset);
    shader_reset();
}