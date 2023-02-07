#macro __font_delete__  font_delete
#macro font_delete      __scribble_font_delete_from_file

function __scribble_font_delete_from_file(_font)
{
    var _name = font_get_name(_font);
    
    //Delete after getting the name otherwise we get <undefined>
    var _result = __font_delete__(_font);
    
    var _font_original_name_dict = __scribble_get_state().__font_original_name_dict;
    var _font_struct = _font_original_name_dict[$ _name];
    
    if (!is_struct(_font_struct))
    {
        __scribble_trace("Warning! Trying to delete font \"", font_get_name(_font), "\" but it could not be found");
        return;
    }
    
    _font_struct.__destroy();
    
    return _result;
}