/// Feather ignore all
/// 
/// @param font
/// @param hAlign
/// @param offset

function scribble_font_set_halign_offset(_font, _hAlign, _offset)
{
    _hAlign = __ScribbleConvertHAlignName(_hAlign);
    
    __ScribbleGetFontData(_font).__halignOffsetArray[_hAlign] = _offset;
}