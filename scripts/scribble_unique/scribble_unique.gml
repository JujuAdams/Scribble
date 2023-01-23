/// Returns a Scribble text element corresponding to the concatenated stringified input values
/// If a text element with the same input string has been cached, this function will return the cached text element
/// 
/// @param [uniqueID]   A unique identifier that can be used to distinguish this occurrence of the input string from other occurrences. Only necessary when you might be drawing the same string at the same time with different animation states
/// @param value        The string to parse and, eventually, draw
/// @param ...

function scribble_unique()
{
    var _unique_id = argument[0];
    if (_unique_id == undefined) _unique_id = irandom(0x7FFFFFFFFFFFFFFF);
    _unique_id = "::" + string(_unique_id);
    
    if (argument_count == 2)
    {
        var _string = string(argument[1]);
    }
    else
    {
        var _string = "";
        var _i = 1;
        repeat(argument_count-1)
        {
            _string += string(argument[_i]);
            ++_i;
        }
    }
    
    static _ecache_dict = __scribble_get_cache_state().__ecache_dict;
    var _weak = _ecache_dict[$ _string + _unique_id];
    if ((_weak == undefined) || !weak_ref_alive(_weak))
    {
        return new __scribble_class_element(_string, _unique_id);
    }
    else
    {
        return _weak.ref;
    }
}