/// Modifies the relative x-offset for characters in a font
/// 
/// Properties can be adjusted at any time, but existing/cached Scribble text will not be updated to match new properties.
/// 
/// Returns: The new value of the property that was modified.
/// @param fontName           The target font, as a string
/// @param glyphRange         Range of glyphs to target
/// @param value              The value to set
/// @param [relative=false]   Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to false, overwriting the existing value

function scribble_glyph_x_offset_set(_font, _glyph_range, _value, _relative = false)
{
    return __scribble_glyph_set(_font, _glyph_range, SCRIBBLE_GLYPH.X_OFFSET, _value, _relative);
}