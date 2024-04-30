// Feather disable all
function __scribble_font_add_all_from_project()
{
    //Try to add all fonts in the project to Scribble
    var _fonts = asset_get_ids(asset_font);
	
	for (var _i=0, _n=array_length(_fonts); _i<_n; _i++) {
	
        if (!font_exists(_fonts[_i])) break;
        
        var _skip = false;
        
        var _tags = asset_get_tags(_fonts[_i], asset_font);
        var _j = 0;
        repeat(array_length(_tags))
        {
            if (string_lower(_tags[_j]) == "scribble skip")
            {
                _skip = true;
                break;
            }
            
            ++_j;
        }
        
        var _name = font_get_name(_fonts[_i]);
        if (string_copy(_name, 1, 9) == "__newfont") //Don't scan fonts created at runtime (e.g. by font_add_sprite())
        {
            _skip = true;
        }
        
        if (!_skip)
        {
            __scribble_font_add_from_project(_fonts[_i]);
        }
    
    }
}
