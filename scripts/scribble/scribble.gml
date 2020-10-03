/// Returns a Scribble text element corresponding to the input string
/// If a text element with the same input string (and unique ID) has been cached, this function will return the cached text element
/// You may want to execute the .reset() method on the text element to ensure its state is as you expect
/// 
/// @param string       The string to parse and, eventually, draw
/// @param [uniqueID]   A unique identifier that can be used to distinguish this occurrence of the input string from other occurrences. Only necessary when you might be drawing the same string at the same time with different animation states

function scribble()
{
    var _string    = string(argument[0]);
    var _unique_id = (argument_count > 1)? string(argument[1]) : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;
    
    var _element_cache_name = _string + ":" + _unique_id;
    var _element = global.__scribble_element_cache[? _element_cache_name];
    if (_element == undefined) _element = new __scribble_element(_string, _element_cache_name);
    
    return _element;
}