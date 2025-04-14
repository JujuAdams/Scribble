// Feather disable all

function __scribble_font_add_all_from_bundle()
{
    //Try to add all fonts in the project to Scribble
    var _fontArray = asset_get_ids(asset_font);
    
    var _i = 0;
    repeat(array_length(_fontArray))
    {
        var _font = _fontArray[_i];
        if (font_exists(_font))
        {
            var _skip = false;
            
            var _tagArray = asset_get_tags(_font, asset_font);
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
            
            var _name = font_get_name(_font);
            if (string_copy(_name, 1, 9) == "__newfont") //Don't scan fonts created at runtime (e.g. by `font_add_sprite()`)
            {
                _skip = true;
            }
            
            if (not _skip)
            {
                __scribble_font_add_from_bundle(_font);
            }
        }
        
        ++_i;
    }
}
