/// Tries to add all fonts in your project to Scribble

function scribble_font_add_all()
{
	global.__scribble_autoscanning = true;
    
    var _using_tags = false;
	var _i = 0;
	repeat(9999)
	{
		if (!font_exists(_i)) break;
        var _name = font_get_name(_i);
        if (string_copy(_name, 1, 9) != "__newfont") //Don't scan fonts created at runtime (e.g. by font_add_sprite())
        {
            if (asset_has_any_tag(_i, "Scribble", asset_font)
            ||  asset_has_any_tag(_i, "scribble", asset_font)
            ||  asset_has_any_tag(_i, "SCRIBBLE", asset_font))
            {
                if (SCRIBBLE_VERBOSE) __scribble_trace("Found a font with a \"Scribble\" tag. We'll filter fonts accordingly");
                _using_tags = true;
                break;
            }
        }
        
		++_i;
	}
    
	var _i = 0;
	repeat(9999)
	{
		if (!font_exists(_i)) break;
        var _name = font_get_name(_i);
        if (string_copy(_name, 1, 9) != "__newfont") //Don't scan fonts created at runtime (e.g. by font_add_sprite())
        {
            if (!_using_tags
            ||  asset_has_any_tag(_i, "Scribble", asset_font)
            ||  asset_has_any_tag(_i, "scribble", asset_font)
            ||  asset_has_any_tag(_i, "SCRIBBLE", asset_font))
            {
                scribble_add_font(_name);
            }
            else
            {
                __scribble_trace("Font \"" + font_get_name(_i) + "\" doesn't have a \"Scribble\" tag, ignoring it");
            }
        }
        
		++_i;
	}
    
	global.__scribble_autoscanning = false;
}