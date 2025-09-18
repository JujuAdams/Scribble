// Feather disable all

function __ScribbleTrace()
{
    var _string = "ScribbleDX: ";
    
    var _i = 0
    repeat(argument_count)
    {
        if (is_numeric(argument[_i]) && (argument[_i] != floor(argument[_i])))
        {
            _string += string_format(argument[_i], 0, 4);
        }
        else
        {
            _string += string(argument[_i]);
        }
        
        ++_i;
    }
    
    show_debug_message(_string);
}