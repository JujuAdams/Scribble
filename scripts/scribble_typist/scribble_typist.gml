/// @param string   The string to parse and, eventually, draw

function __scribble_typist(_location)
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
            var _element = new __scribble_class_element(string(_string), _scribble_state.__unique_location);
            _element.__typist = new __scribble_class_typist(false);
            return _element;
        }
        else
        {
            return _weak.ref;
        }
    }
}

#macro scribble_typist  __scribble_typist(_GMFILE_ + _GMFUNCTION_ + string(_GMLINE_))