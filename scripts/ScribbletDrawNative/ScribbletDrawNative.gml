// Feather disable all

/// Draws plain text without formatting or layout. This is a convenience function that wraps around
/// GameMaker's native text drawing. Nothing special!
/// 
/// N.B. This function should only be used for extremely fast changing text such as a stopwatch.
///      You should use Scribblet() instead if you plan for the drawn text to persist for
///      around a second or more.
/// 
/// @param x
/// @param y
/// @param string
/// @param [colour=white]
/// @param [alpha=1]
/// @param [hAlign=left]
/// @param [vAlign=top]
/// @param [font]
/// @param [fontScale=1]

function ScribbletNative(_x, _y, _string, _colour = c_white, _alpha = 1, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1)
{
    static _system = __ScribbletSystem();
    
    if (_font == undefined) _font = _system.__defaultFont;
    
    draw_set_font(_font);
    draw_set_colour(_colour);
    draw_set_alpha(_alpha);
    draw_set_halign(_hAlign);
    draw_set_valign(_vAlign);
    
    draw_text_transformed(_x, _y, _string, _fontScale, _fontScale, 0);
    
    if (SCRIBBLET_RESET_DRAW_STATE) ScribbletResetDrawState();
}