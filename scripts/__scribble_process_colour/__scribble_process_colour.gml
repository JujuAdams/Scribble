// Feather disable all

function __scribble_process_colour(_value)
{
    static _colors_struct = __scribble_config_colours();
    
    if (is_string(_value))
    {
        if (not variable_struct_exists(_colors_struct, _value))
        {
            __scribble_error("Colour \"", _value, "\" not recognised. Please add it to __scribble_config_colours()");
        }
        
        return (_colors_struct[$ _value] & 0xFFFFFF);
    }
    else
    {
        return _value;
    }
}