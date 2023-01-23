/// Returns a Scribble text element corresponding to the concatenated stringified input values
/// If a text element with the same input string has been cached, this function will return the cached text element
/// 
/// @param value  The string to parse and, eventually, draw
/// @param ...

function scribble()
{
    if (argument_count == 1)
    {
        var _string = string(argument[0]);
    }
    else
    {
        var _string = "";
        var _i = 0;
        repeat(argument_count)
        {
            _string += string(argument[_i]);
            ++_i;
        }
    }
    
    static _ecache_dict = __scribble_get_cache_state().__ecache_dict;
    var _weak = _ecache_dict[$ _string];
    if ((_weak == undefined) || !weak_ref_alive(_weak) || _weak.ref.__flushed)
    {
        return new __scribble_class_element(_string);
    }
    else
    {
        return _weak.ref;
    }
}