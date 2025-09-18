// Feather disable all

/// @param string

function __ScribbleConvertHAlignName(_string)
{
    static _dict = {
        pin_left:   __SCRIBBLE_PIN_LEFT,
        pin_centre: __SCRIBBLE_PIN_CENTRE,
        pin_center: __SCRIBBLE_PIN_CENTRE,
        pin_right:  __SCRIBBLE_PIN_RIGHT,
        fa_justify: __SCRIBBLE_FA_JUSTIFY,
    };
    
    return is_string(_string)? (_dict[$ _string] ?? fa_left) : _string;
}