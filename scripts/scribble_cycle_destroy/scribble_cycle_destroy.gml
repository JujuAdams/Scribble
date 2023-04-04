/// @param name

function scribble_cycle_destroy(_name)
{
    static _scribble_state = __scribble_get_state();
    static _open_array = _scribble_state.__cycle_open_array;
    static _cycle_dict = _scribble_state.__cycle_dict;
    
    var _cycle_struct = _cycle_dict[$ _name];
    if (is_struct(_cycle_struct))
    {
        surface_set_target(__scribble_ensure_cycle_surface());
        draw_sprite_ext(__scribble_white_pixel, 0, 0, _cycle_struct.__y, SCRIBBLE_CYCLE_ACCURACY, 1, 0, c_white, 1);
        surface_reset_target();
        
        array_push(_open_array, _cycle_struct.__y);
        variable_struct_remove(_cycle_dict, _name);
    }
}