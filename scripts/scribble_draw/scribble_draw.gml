/// @param x
/// @param y
/// @param string
/// @param [minLineHeight]
/// @param [maxLineWidth]

var _x               = argument[0];
var _y               = argument[1];
var _string          = argument[2];
var _line_min_height = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : -1;
var _width_limit     = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : -1;



do
{
    var _min_sha1 = ds_priority_find_min(global.__scribble_cache_priority_queue);
    var _min_time = ds_priority_find_priority(global.__scribble_cache_priority_queue, _min_sha1);
    if (current_time > _min_time)
    {
        if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Deleting \"" + _min_sha1 + "\" from cache");
        
        var _scribble = global.__scribble_cache_map[? _min_sha1];
        scribble_destroy(_scribble);
        
        ds_map_delete(global.__scribble_cache_map, _min_sha1);
        ds_priority_delete_min(global.__scribble_cache_priority_queue);
    }
}
until (ds_priority_empty(global.__scribble_cache_priority_queue) || (current_time <= _min_time));



var _sha1 = sha1_string_utf8(_string) + ":" + string(_line_min_height) + ":" + string(_width_limit);

var _scribble = global.__scribble_cache_map[? _sha1];
if (_scribble != undefined)
{
    ds_priority_change_priority(global.__scribble_cache_priority_queue, _sha1, current_time + SCRIBBLE_CACHE_DECAY);
}
else
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Adding \"" + _sha1 + "\" to cache");
    _scribble = scribble_create(_string);
    
    global.__scribble_cache_map[? _sha1] = _scribble;
    ds_priority_add(global.__scribble_cache_priority_queue, _sha1, current_time + SCRIBBLE_CACHE_DECAY);
}

scribble_draw_from(_scribble, _x, _y);



return _scribble;