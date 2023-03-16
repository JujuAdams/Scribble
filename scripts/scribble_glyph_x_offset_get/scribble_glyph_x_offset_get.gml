/// Returns: The relative x-offset for the glyph
/// @param fontName    The target font, as a string
/// @param character   Target character, as a string

function scribble_glyph_x_offset_get(_font, _character)
{
    return __scribble_glyph_get(_font, _character, SCRIBBLE_GLYPH.X_OFFSET);
}