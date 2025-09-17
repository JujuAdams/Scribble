/// Feather ignore all
/// 
/// @param font
/// @param vAlign
/// @param offset

function scribble_font_set_valign_offset(_font, _vAlign, _offset)
{
    if (_vAlign == "pin_top"   ) _vAlign = __SCRIBBLE_PIN_TOP;
    if (_vAlign == "pin_middle") _vAlign = __SCRIBBLE_PIN_MIDDLE;
    if (_vAlign == "pin_bottom") _vAlign = __SCRIBBLE_PIN_BOTTOM;
    
    __scribble_get_font_data(_font).__valignOffsetArray[_vAlign] = _offset;
}