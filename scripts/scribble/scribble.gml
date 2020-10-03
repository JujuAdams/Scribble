/// @param string
/// @param [uniqueID]

function scribble()
{
    var _string    = string(argument[0]);
    var _unique_id = (argument_count > 1)? string(argument[1]) : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;
    
    var _element_cache_name = _string + ":" + _unique_id;
    var _element = global.__scribble_element_cache[? _element_cache_name];
    if (_element == undefined) _element = new __scribble_element(_string, _element_cache_name);
    
    return _element;
}