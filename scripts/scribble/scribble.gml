/// Returns a Scribble text element corresponding to the input string
/// If a text element with the same input string (and unique ID) has been cached, this function will return the cached text element
/// 
/// @param string       The string to parse and, eventually, draw
/// @param [uniqueID]   A unique identifier that can be used to distinguish this occurrence of the input string from other occurrences. Only necessary when you might be drawing the same string at the same time with different animation states

function scribble(_string, _unique_id = undefined)
{
    static _ecache_dict = __scribble_get_cache_state().__ecache_dict;
    
    _unique_id = (_unique_id == undefined)? ":default" : (":" + string(_unique_id));
    var _weak = _ecache_dict[$ string(_string) + _unique_id];
    
    if ((_weak == undefined) || !weak_ref_alive(_weak) || _weak.ref.__flushed)
    {
        return new __scribble_class_element(string(_string), _unique_id);
    }
    else
    {
        return _weak.ref;
    }
}