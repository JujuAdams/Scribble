// Feather disable all

/// @param value

function Concat()
{
    var _string = "";
    
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    return _string;
}