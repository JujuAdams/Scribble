/// Returns a Scribble text element corresponding to the input string
/// If a text element with the same input string (and unique ID) has been cached, this function will return the cached text element
/// 
/// @param [string]     The string to parse and, eventually, draw
/// @param [uniqueID]   A unique identifier that can be used to distinguish this occurrence of the input string from other occurrences. Only necessary when you might be drawing the same string at the same time with different animation states
/// 
/// For further information, please read the Quick_Reference note

function scribble()
{
    var _string    = (argument_count > 0)? string(argument[0]) : undefined;
    var _unique_id = (argument_count > 1)? string(argument[1]) : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;
    
    if (_string == undefined)
    {
        do
        {
            var _element_cache_name = "anonymous " + string(floor(999999*__scribble_random()));
        }
        until !ds_map_exists(global.__scribble_element_cache, _element_cache_name);
        
        _element = new __scribble_class_element("", _element_cache_name, false);
    }
    else
    {
        var _element_cache_name = _string + ":" + _unique_id;
        var _element = global.__scribble_element_cache[? _element_cache_name];
        if (!is_struct(_element) || _element.flushed) _element = new __scribble_class_element(_string, _element_cache_name, false);
        
        if (SCRIBBLE_AUTO_TYPEWRITER_RESET)
        {
            var _callstack = string(debug_get_callstack());
            var _old_cache_name = global.__scribble_callstack_cache[? _callstack];
            if (_old_cache_name != _element_cache_name)
            {
                if (_old_cache_name != undefined) _element.auto_refresh_typewriter = true;
                global.__scribble_callstack_cache[? _callstack] = _element_cache_name;
            }
        }
    }
    
    return _element;
}