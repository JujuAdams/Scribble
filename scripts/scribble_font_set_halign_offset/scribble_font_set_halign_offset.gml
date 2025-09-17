/// Feather ignore all
/// 
/// @param font
/// @param hAlign
/// @param offset

function scribble_font_set_halign_offset(_font, _hAlign, _offset)
{
    if (_hAlign == "pin_left"  ) _hAlign = __SCRIBBLE_PIN_LEFT;
    if (_hAlign == "pin_centre") _hAlign = __SCRIBBLE_PIN_CENTRE;
    if (_hAlign == "pin_center") _hAlign = __SCRIBBLE_PIN_CENTRE;
    if (_hAlign == "pin_right" ) _hAlign = __SCRIBBLE_PIN_RIGHT;
    if (_hAlign == "fa_justify") _hAlign = __SCRIBBLE_FA_JUSTIFY;
    
    __ScribbleGetFontData(_font).__halignOffsetArray[_hAlign] = _offset;
}