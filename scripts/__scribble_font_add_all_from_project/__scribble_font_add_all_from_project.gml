// Feather disable all

function __scribble_font_add_all_from_project()
{
    //Try to add all fonts in the project to Scribble
    var _fontArray = asset_get_ids(asset_font);
    
    var _i = 0;
    repeat(array_length(_fontArray))
    {
        var _font = _fontArray[_i];
        if (not font_exists(_font)) continue;
        
        var _skip = false;
        
        var _tagArray = asset_get_tags(_fontArray[_i], asset_font);
        var _j = 0;
        repeat(array_length(_tagArray))
        {
            if (string_lower(_tagArray[_j]) == "scribble skip")
            {
                _skip = true;
                break;
            }
            
            ++_j;
        }
        
        var _name = font_get_name(_fontArray[_i]);
        if (string_copy(_name, 1, 9) == "__newfont") //Don't scan fonts created at runtime (e.g. by font_add_sprite())
        {
            _skip = true;
        }
        
        if (not _skip)
        {
            __scribble_font_add_from_project(_fontArray[_i]);
        }
        
        ++_i;
    }
}
