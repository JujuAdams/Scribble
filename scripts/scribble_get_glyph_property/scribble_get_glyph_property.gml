/// Returns: Real-value for the specified property
/// @param fontName     The target font, as a string
/// @param character    Target character, as a string
/// @param property     Property to return, see below
/// 
/// Three properties are available:
/// SCRIBBLE_GLYPH.X_OFFSET:   The relative x-offset to draw the glyph
/// SCRIBBLE_GLYPH.Y_OFFSET:   The relative y-offset to draw the glyph
/// SCRIBBLE_GLYPH.SEPARATION: Effective width of the glyph, the distance between this glyph's left edge and the
///                            left edge of the next glyph. This can be a negative value!

function scribble_get_glyph_property(_font, _character, _property)
{
	if ( !variable_global_exists("__scribble_lcg") )
	{
	    show_error("Scribble:\nscribble_get_glyph_property() should be called after initialising Scribble.\n ", false);
	    exit;
	}

	var _font_data = global.__scribble_font_data[? _font ];

	var _array = _font_data[ __SCRIBBLE_FONT.GLYPHS_ARRAY ];
	if (_array == undefined)
	{
	    //If the glyph array doesn't exist for this font, use the ds_map fallback
	    var _map = _font_data[ __SCRIBBLE_FONT.GLYPHS_MAP ];
	    var _glyph_data = _map[? ord(_character) ];
	}
	else
	{
	    var _glyph_data = _array[ ord(_character) - _font_data[ __SCRIBBLE_FONT.GLYPH_MIN ] ];
	}

	if (_glyph_data == undefined)
	{
	    show_error("Scribble:\nCharacter \"" + _character + "\" not found for font \"" + _font + "\"", false);
	    return undefined;
	}

	return _glyph_data[_property];
}