// Feather disable all

/// @param value

function __ScribbletError()
{
    var _string = "Scribblet " + string(__SCRIBBLET_VERSION) + ":\n";
    
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    SCRIBBLET_SHOW_ERROR(_string + "\n ", true);
}