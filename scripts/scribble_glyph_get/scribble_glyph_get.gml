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

function scribble_glyph_get(_font, _character, _property)
{
    var _font_data = global.__scribble_font_data[? _font ];

    var _array = _font_data.glyphs_array; 
    var _map   = _font_data.glyphs_map;
    
    if (_array == undefined)
    {
        var _glyph_data = _map[? ord(_character)];
    }
    else
    {
        var _glyph_data = _array[ord(_character) - _font_data.glyph_min];
    }

    if (_glyph_data == undefined)
    {
        __scribble_error("Character \"", _character, "\" not found for font \"", _font, "\"");
        return undefined;
    }

    return _glyph_data[_property];
}