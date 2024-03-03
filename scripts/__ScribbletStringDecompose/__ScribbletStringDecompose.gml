// Feather disable all

/// @param string
/// @param [characterCount]

function __ScribbletStringDecompose(_string, _characterCount = string_length(_string))
{
    var _array = array_create(_characterCount);
    
    //GameMaker needs a function to decompose a string into glyphs
    string_foreach(_string, method({
        __array: _array,
    }, function(_character, _position)
    {
        __array[_position-1] = _character;
    }));
    
    return _array;
}