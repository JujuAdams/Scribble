function scribble_add_fonts_auto()
{
	global.__scribble_autoscanning = true;
    
	var _i = 0;
	repeat(999)
	{
		if (!font_exists(_i)) break;
        var _name = font_get_name(_i);
        if (string_copy(_name, 1, 9) != "__newfont") scribble_add_font(_name); //Don't scan fonts created at runtime (e.g. by font_add_sprite())
		++_i;
	}
    
	global.__scribble_autoscanning = false;
}