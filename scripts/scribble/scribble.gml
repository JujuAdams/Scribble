/// Returns a Scribble text element corresponding to the input string
/// If a text element with the same input string has been cached, this function will return the cached text element
/// 
/// @param string   The string to parse and, eventually, draw

function scribble(_string)
{
    static _ecache_dict = __scribble_get_cache_state().__ecache_dict;
    
    var _key = string(_string) + ":default";
    var _weak = _ecache_dict[$ _key];
    if ((_weak == undefined) || !weak_ref_alive(_weak) || _weak.ref.__flushed)
    {
        return new __scribble_class_element(string(_string), ":default");
    }
    else
    {
        return _weak.ref;
    }
}