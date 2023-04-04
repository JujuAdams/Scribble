/// @param colour

function __scribble_resolve_colour(_colour)
{
    static _colours_struct = __scribble_get_state().__custom_colour_struct;
    
    if (is_string(_colour))
    {
        _colour = _colours_struct[$ _colour];
        if (_colour == undefined)
        {
            __scribble_error("Colour name \"", _colour, "\" not recognised");
            exit;
        }
    }
    
    return _colour;
}