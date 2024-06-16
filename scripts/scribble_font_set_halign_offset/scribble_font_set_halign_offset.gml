/// Feather ignore all
/// 
/// @param font
/// @param hAlign
/// @param offset

function scribble_font_set_halign_offset(_font, _halign, _offset)
{
    if (_halign == "pin_left"  ) _halign = __SCRIBBLE_PIN_LEFT;
    if (_halign == "pin_centre") _halign = __SCRIBBLE_PIN_CENTRE;
    if (_halign == "pin_center") _halign = __SCRIBBLE_PIN_CENTRE;
    if (_halign == "pin_right" ) _halign = __SCRIBBLE_PIN_RIGHT;
    if (_halign == "fa_justify") _halign = __SCRIBBLE_FA_JUSTIFY;
    
    if (not SCRIBBLE_USE_FONT_ALIGNMENT_OFFSETS)
    {
        __scribble_error("Please set SCRIBBLE_USE_FONT_ALIGNMENT_OFFSETS to <true> to use this feature");
    }
    
    __scribble_get_font_data(_font).__halign_offset_array[_halign] = _offset;
}