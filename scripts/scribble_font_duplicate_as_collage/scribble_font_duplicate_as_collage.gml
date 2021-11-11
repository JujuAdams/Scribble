/// @param oldFontName
/// @param newFontName

function scribble_font_duplicate_as_collage(_old, _new)
{
    scribble_font_collage_create(_new);
    scribble_font_collage_glyph_copy_all(_new, _old, true);
}