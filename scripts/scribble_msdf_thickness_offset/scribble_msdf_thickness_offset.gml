/// @param offset

function scribble_msdf_thickness_offset(_offset)
{
    static _scribble_state = __scribble_get_state();
    _scribble_state.__msdf_thickness_offset = _offset;
}