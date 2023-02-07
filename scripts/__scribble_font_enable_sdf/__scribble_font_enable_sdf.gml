#macro __font_enable_sdf__  font_enable_sdf
#macro font_enable_sdf      __scribble_font_enable_sdf

function __scribble_font_enable_sdf(_font, _state)
{
    var _asset_name = font_get_name(_font);
    
    var _old_state = font_get_sdf_enabled(_font);
    var _result = __font_enable_sdf__(_font, _state);
    
    //If the state hasn't changed then don't do anything else
    //I presume GM is doing a similar thing internally but you never know...
    if (_old_state == _state) return _result;
    
    static _font_original_name_dict = __scribble_get_state().__font_original_name_dict;
    if (!variable_struct_exists(_font_original_name_dict, _asset_name))
    {
        __scribble_trace("Warning! font_enable_sdf() was called for font \"", _asset_name, "\" but that doesn't exist within Scribble");
        return _result;
    }
    
    var _font_struct = _font_original_name_dict[$ _asset_name];
    __scribble_font_add_from_file_internal(_font,
                                           _font_struct.__font_add_data.__filename,
                                           _font_struct.__font_add_data.__point_size,
                                           _font_struct.__font_add_data.__bold,
                                           _font_struct.__font_add_data.__italic,
                                           _font_struct.__font_add_data.__first,
                                           _font_struct.__font_add_data.__last);
    
    return _result;
}