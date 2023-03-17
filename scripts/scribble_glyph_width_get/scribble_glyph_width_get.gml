/// Returns: The height of the glyph
/// @param fontName    The target font, as a string
/// @param character   Target character, as a string

function scribble_glyph_height_set(_font, _character)
{
    return __scribble_glyph_get(_font, _character, __SCRIBBLE_GLYPH.__HEIGHT);
}