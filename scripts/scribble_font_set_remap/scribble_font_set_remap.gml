// Feather disable all

/// Remaps a font reference to point to a different font. Remapping only applies when Scribble is
/// parsing text and preparing text for rendering. When the Scribble sees a font reference that is
/// remapped during text parsing, Scribble will instead internally use the new font. This allows
/// you to conveniently swap out one font for another which is helpful for many localisation tasks.
/// 
/// Both the `originalFont` and `remapFont` parameters must be the name of the font as a string. To
/// unset remapping, you may use `undefined` for the `remapFont` parameter. Remapping is not
/// recursive. If you remap Font A to Font B and separately remap Font B to Font C then this will
/// **not** cause Font A to remap to Font C.
/// 
/// N.B. Remapping a font will cause every text element to regenerate because font references might
///      be invalid after remapping. This function will call `scribble_flush_everything()` to
///      achieve this.
/// 
/// N.B. Different fonts rarely perfectly line up. You will usually want to tweak font positioning
///      by using `scribble_glyph_set()`, specifically targeting x/y offsets and font height.
/// 
/// @param originalFont
/// @param remapFont

function scribble_font_set_remap(_original_font, _remap_font)
{
    with(__scribble_get_font_data(_original_font))
    {
        if (__remap != _remap_font)
        {
            __remap = _remap_font;
            scribble_flush_everything();
        }
    }
}