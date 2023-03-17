/// Returns: The relative y-offset for the glyph
/// @param fontName     The target font, as a string
/// @param character    Target character, as a string

function scribble_glyph_y_offset_get(_font, _character)
{
    return __scribble_glyph_get(_font, _character, __SCRIBBLE_GLYPH.__Y_OFFSET);
}