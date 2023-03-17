/// Returns: Real-value for the specified property
/// @param fontName     The target font, as a string
/// @param character    Target character, as a string
/// @param property     Property to return, see below
/// 
/// Three properties are available:
/// __SCRIBBLE_GLYPH.__X_OFFSET:   The relative x-offset to draw the glyph
/// __SCRIBBLE_GLYPH.__Y_OFFSET:   The relative y-offset to draw the glyph
/// __SCRIBBLE_GLYPH.__SEPARATION: Effective width of the glyph, the distance between this glyph's left edge and the
///                            left edge of the next glyph. This can be a negative value!

function __scribble_glyph_get(_font, _character, _property)
{
    var _font_data = __scribble_get_font_data(_font);

    var _grid = _font_data.__glyph_data_grid;
    var _map  = _font_data.__glyphs_map;
    var _unicode = is_real(_character)? _character : ord(_character);
    var _glyph_index = _map[? _unicode];
    
    if (_glyph_index == undefined)
    {
        __scribble_error("Character \"", _character, "\" not found for font \"", _font, "\"");
        return undefined;
    }

    return _grid[# _glyph_index, _property];
}