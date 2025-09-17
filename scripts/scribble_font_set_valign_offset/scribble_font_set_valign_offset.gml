/// Feather ignore all
/// 
/// @param font
/// @param vAlign
/// @param offset

function scribble_font_set_valign_offset(_font, _valign, _offset)
{
    if (_valign == "pin_top"   ) _valign = __SCRIBBLE_PIN_TOP;
    if (_valign == "pin_middle") _valign = __SCRIBBLE_PIN_MIDDLE;
    if (_valign == "pin_bottom") _valign = __SCRIBBLE_PIN_BOTTOM;
    
    __scribble_get_font_data(_font).__valignOffsetArray[_valign] = _offset;
}