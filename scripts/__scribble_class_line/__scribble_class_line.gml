// Feather disable all

/// @param y
/// @param height
/// @param hAlign
/// @param forceBreak
/// @param glyphStart
/// @param glyphEnd

function __scribble_class_line(_y, _height, _hAlign, _forced_break, _glyph_start, _glyph_end) constructor
{
    y            = _y;
    height       = _height;
    halign       = _hAlign;
    forced_break = _forced_break;
    glyph_start  = _glyph_start;
    glyph_end    = _glyph_end;
    glyph_count  = 1 + _glyph_end - _glyph_start;
}
