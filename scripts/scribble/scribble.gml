/// Returns a Scribble text element corresponding to the input string
/// If a text element with the same input string (and unique ID) has been cached, this function will return the cached text element
/// 
/// @param [string]     The string to parse and, eventually, draw
/// @param [uniqueID]   A unique identifier that can be used to distinguish this occurrence of the input string from other occurrences. Only necessary when you might be drawing the same string at the same time with different animation states
/// 
/// For further information, please read the Reference note

function scribble()
{
    var _string    = (argument_count > 0)? string(argument[0]) : undefined;
    var _unique_id = (argument_count > 1)? string(argument[1]) : SCRIBBLE_DEFAULT_UNIQUE_ID;
    
    var _element = SCRIBBLE_NULL_ELEMENT;
    if (_string == undefined)
    {
        do
        {
            var _element_cache_name = "anonymous " + string(floor(999999*__scribble_random()));
        }
        until !ds_map_exists(global.__scribble_ecache_dict, _element_cache_name);
        
        _element = new __scribble_class_element("", _element_cache_name);
    }
    else
    {
        var _element_cache_name = _string + ":" + _unique_id;
        var _weak = global.__scribble_ecache_dict[? _element_cache_name];
        if ((_weak == undefined) || !weak_ref_alive(_weak) || _weak.ref.flushed)
        {
            _element = new __scribble_class_element(_string, _element_cache_name);
        }
        else
        {
            _element = _weak.ref;
        }
    }
    
    return _element;
}