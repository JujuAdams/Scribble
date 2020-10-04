/// Returns a Scribble text element corresponding to the input string
/// If a text element with the same input string (and unique ID) has been cached, this function will return the cached text element
/// You may want to execute the .reset() method on the text element to ensure its state is as you expect
/// 
/// N.B. Scribble text element have NO PUBLICLY ACCESSIBLE VARIABLES
///      Do not directly read or write variables, use the setter and getter functions provided instead
/// 
/// Scribble text elements have the following methods:
///     .reset()
///     .starting_format()
///     .align()
///     .blend()
///     .transform()
///     .origin()
///     .wrap()
///     .line_height()
///     .template()
///     .page()
///     .animation()
///     .fog()
///     .ignore_command_tags()
///     .bezier()
///     .typewriter_off()
///     .typewriter_in()
///     .typewriter_out()
///     .typewriter_sound()
///     .typewriter_sound_per_char()
///     .typewriter_function()
///     .typewriter_pause()
///     .typewriter_unpause()
///     .get_bbox()
///     .get_width()
///     .get_height()
///     .get_page()
///     .get_pages()
///     .get_typewriter_state()
///     .get_typewriter_paused()
///     .draw()
///     .flush_now()
///     .cache_now()
/// 
/// @param string       The string to parse and, eventually, draw
/// @param [uniqueID]   A unique identifier that can be used to distinguish this occurrence of the input string from other occurrences. Only necessary when you might be drawing the same string at the same time with different animation states

function scribble()
{
    var _string    = string(argument[0]);
    var _unique_id = (argument_count > 1)? string(argument[1]) : SCRIBBLE_DEFAULT_OCCURRENCE_NAME;
    
    var _element_cache_name = _string + ":" + _unique_id;
    var _element = global.__scribble_element_cache[? _element_cache_name];
    if (_element == undefined) _element = new __scribble_class_element(_string, _element_cache_name);
    
    return _element;
}