/// Returns: N/A (undefined)
/// @param fontName          The target font, as a string
/// @param offset            a
/// @param [relative=false]  v

function scribble_font_set_sdf_thickness_offset(_font, _offset, _relative = false)
{
    static _font_data_map = __scribble_get_state().__font_data_map;
    
    if (_font == all)
    {
        var _names_array = ds_map_keys_to_array(_font_data_map);
        var _i = 0;
        repeat(array_length(_names_array))
        {
            __scribble_get_font_data(_names_array[_i]).__set_sdf_thickness_offset(_offset, _relative, true);
            ++_i;
        }
    }
    else
    {
        __scribble_get_font_data(_font).__set_sdf_thickness_offset(_offset, _relative, false);
    }
}