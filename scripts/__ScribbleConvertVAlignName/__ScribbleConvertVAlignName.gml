// Feather disable all

/// @param string

function __ScribbleConvertVAlignName(_string)
{
    static _dict = {
        pin_top:    __SCRIBBLE_PIN_TOP,
        pin_middle: __SCRIBBLE_PIN_MIDDLE,
        pin_bottom: __SCRIBBLE_PIN_BOTTOM,
    };
    
    return is_string(_string)? (_dict[$ _string] ?? fa_top) : _string;
}