/// Returns: The separation value for a glyph (not including kerning pairs)
/// @param fontName    The target font, as a string
/// @param character   Target character, as a string

function scribble_glyph_separation_get(_font, _character)
{
    return __scribble_glyph_get(_font, _character, __SCRIBBLE_GLYPH.__SEPARATION);
}