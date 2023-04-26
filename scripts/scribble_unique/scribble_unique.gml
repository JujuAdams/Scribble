/// Returns a Scribble text element corresponding to the input string
/// 
/// @param string   The string to parse and, eventually, draw

function __scribble_unique(_location)
{
    static _scribble_state = __scribble_get_state();
    _scribble_state.__unique_location = ":" + _location;
    
    return function(_string)
    {
        static _scribble_state = __scribble_get_state();
        static _ecache_dict = __scribble_get_cache_state().__ecache_dict;
        
        var _key = string(_string) + _scribble_state.__unique_location;
        var _weak = _ecache_dict[$ _key];
        if ((_weak == undefined) || !weak_ref_alive(_weak) || _weak.ref.__flushed)
        {
            return new __scribble_class_element(string(_string), _scribble_state.__unique_location);
        }
        else
        {
            return _weak.ref;
        }
    }
}

#macro scribble_unique  __scribble_unique(_GMFILE_ + _GMFUNCTION_ + string(_GMLINE_))