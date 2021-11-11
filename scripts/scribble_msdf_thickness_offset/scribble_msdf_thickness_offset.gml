/// @param [offset=0]

function scribble_msdf_thickness_offset(_offset = 0)
{
    global.__scribble_msdf_thickness_offset = _offset;
    
    //TODO - Optimise
    shader_set(__shd_scribble_msdf);
    shader_set_uniform_f(global.__scribble_msdf_u_fMSDFThicknessOffset, _offset);
    shader_reset();
}