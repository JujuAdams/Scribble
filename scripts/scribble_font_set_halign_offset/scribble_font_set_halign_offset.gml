/// Feather ignore all
/// 
/// @param font
/// @param hAlign
/// @param offset

function scribble_font_set_halign_offset(_font, _halign, _offset)
{
    if (SCRIBBLE_USE_FONT_ALIGNMENT_OFFSETS)
    {
        __scribble_error("Please set SCRIBBLE_USE_FONT_ALIGNMENT_OFFSETS to <true> to use this feature");
    }
    
    __scribble_get_font_data(_font).__halign_offset_array[_halign] = _offset;
}