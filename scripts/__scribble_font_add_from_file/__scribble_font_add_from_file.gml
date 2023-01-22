#macro __font_add__ font_add
#macro font_add __scribble_font_add_from_file

function __scribble_font_add_from_file(_name, _size, _bold, _italic, _first, _last) 
{
    var _font = __font_add__(_name, _size, _bold, _italic, _first, _last);
    
    // Font file doesn't exist, uh oh.
    if (_font == -1) {
        return -1; 
    }
	
	// We need to cache every single glpyh beforehand.
	// As otherwise Scribble cannot access any of these glpyhs.
    var _i = 0;
    var _font_glyph_array = array_create(_last-_first, undefined);
    repeat(_last-_first) {
        var _glyph = _i+_first;
        _font_glyph_array[_i] = chr(_glyph);
        font_cache_glyph(_font, _glyph);
        ++_i;
    }

	
	// Adds the font to the project
    var _fileName = filename_name(_name);
	__scribble_font_add_parse_from_file(_fileName, _font, _font_glyph_array);

	// We return the font ID provided by font_add
	return _font
}