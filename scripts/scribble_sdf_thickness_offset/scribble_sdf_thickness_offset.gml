// Feather disable all
/// @param offset

function scribble_sdf_thickness_offset(_offset)
{
    static _scribble_state = __scribble_get_state();
    _scribble_state.__sdf_thickness_offset = _offset;
}
