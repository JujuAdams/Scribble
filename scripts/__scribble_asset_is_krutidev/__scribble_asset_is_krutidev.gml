function __scribble_asset_is_krutidev(_asset, _asset_type)
{
    static _font_original_name_dict = __scribble_get_state().__font_original_name_dict;
    
    //If this is a "__newfont" and also a font-type asset then we're analyzing a font_add() font
    //We can't tag font_add() fonts so instead we look for Krutidev in the source filename
    var _asset_name = font_get_name(_asset);
    if ((_asset_type == asset_font) && (string_copy(_asset_name, 1, 9) == "__newfont"))
    {
        var _font_data = _font_original_name_dict[$ _asset_name];
        if (!is_struct(_font_data))
        {
            __scribble_trace("Warning! Font \"", _asset_name, "\" has not been added to Scribble");
            return false;
        }
        
        return (string_pos("krutidev", string_lower(string(_font_data.__filename))) > 0);
    }
    
    //Other types of asset can be tagged so let's check for that
    var _tags_array = asset_get_tags(_asset, _asset_type);
    var _i = 0;
    repeat(array_length(_tags_array))
    {
        var _tag = _tags_array[_i];
        if ((_tag == "scribble krutidev") || (_tag == "Scribble krutidev") || (_tag == "Scribble Krutidev")) return true;
        ++_i;
    }
    
    return false;
}