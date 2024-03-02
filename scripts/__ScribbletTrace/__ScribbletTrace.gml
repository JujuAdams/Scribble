// Feather disable all

/// @param value

function __ScribbletTrace()
{
    var _string = "Scribblet: ";
    
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    SCRIBBLET_SHOW_DEBUG_MESSAGE(_string);
}