// Feather disable all

/// @param value

function __ScribbletError()
{
    var _string = "Scribblet " + string(__SCRIBBLET_VERSION) + ": ";
    
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[0]);
        ++_i;
    }
    
    SCRIBBLET_SHOW_ERROR(_string, true);
}