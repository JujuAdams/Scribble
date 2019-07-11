/// @param x
/// @param y
/// @param string

var _x      = argument0;
var _y      = argument1;
var _string = argument2;

var _max_time = get_timer() - game_get_speed(gamespeed_microseconds);

if ((global.__scribble_next_blend_instance == id) && (global.__scribble_next_blend_time > _max_time))
{
    var _colour = (global.__scribble_next_blend_colour == undefined)? draw_get_colour() : global.__scribble_next_blend_colour;
    var _alpha  = (global.__scribble_next_blend_alpha  == undefined)? draw_get_alpha()  : global.__scribble_next_blend_alpha;
    
    global.__scribble_next_blend_time = -9999999;
}
else
{
    var _colour = draw_get_colour();
    var _alpha  = draw_get_alpha();
}

if ((global.__scribble_next_trans_instance == id) && (global.__scribble_next_trans_time > _max_time))
{
    var _xscale = global.__scribble_next_trans_xscale;
    var _yscale = global.__scribble_next_trans_yscale;
    var _angle  = global.__scribble_next_trans_angle;
    
    global.__scribble_next_trans_time = -9999999;
}
else
{
    var _xscale = 1;
    var _yscale = 1;
    var _angle  = 0;
}

if ((global.__scribble_next_wrap_instance == id) && (global.__scribble_next_wrap_time > _max_time))
{
    var _width_limit     = global.__scribble_next_wrap_line_width;
    var _line_min_height = global.__scribble_next_wrap_line_height;
    
    global.__scribble_next_wrap_time = -9999999;
}
else
{
    var _width_limit     = -1;
    var _line_min_height = -1;
}

if ((global.__scribble_next_tw_instance == id) && (global.__scribble_next_tw_time > _max_time))
{
    var _tw_fade_out = global.__scribble_next_tw_fade_out;
    var _tw_position = global.__scribble_next_tw_position;
    var _tw_type     = global.__scribble_next_tw_type;
    var _tw_execute  = global.__scribble_next_tw_execute;
    
    global.__scribble_next_tw_time = -9999999;
}
else
{
    var _tw_fade_out = false;
    var _tw_position = 1.0;
    var _tw_type     = SCRIBBLE_TYPEWRITER_WHOLE;
    var _tw_execute  = false;
}



var _sha1 = sha1_string_utf8(_string) + ":" + string(_line_min_height) + ":" + string(_width_limit);

var _scribble = global.__scribble_cache_map[? _sha1];
if (_scribble != undefined)
{
    ds_priority_change_priority(global.__scribble_cache_priority_queue, _sha1, current_time + SCRIBBLE_CACHE_DECAY);
}
else
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Adding \"" + _sha1 + "\" to cache");
    _scribble = scribble_static_create(_string, _line_min_height, _width_limit);
    _scribble[| SCRIBBLE.STATIC] = false;
    
    global.__scribble_cache_map[? _sha1] = _scribble;
    ds_priority_add(global.__scribble_cache_priority_queue, _sha1, current_time + SCRIBBLE_CACHE_DECAY);
}

if (!global.__scribble_defeat_draw)
{
    scribble_set_box_alignment(_scribble, _scribble[| SCRIBBLE.STRING_HALIGN], _scribble[| SCRIBBLE.STRING_VALIGN]);
    scribble_static_draw(_scribble, _x, _y, _xscale, _yscale, _angle, _colour, _alpha);
}



do
{
    var _min_sha1 = ds_priority_find_min(global.__scribble_cache_priority_queue);
    var _min_time = ds_priority_find_priority(global.__scribble_cache_priority_queue, _min_sha1);
    if (current_time > _min_time)
    {
        if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Deleting \"" + _min_sha1 + "\" from cache");
        
        var _scribble = global.__scribble_cache_map[? _min_sha1];
        scribble_static_destroy(_scribble);
        
        ds_map_delete(global.__scribble_cache_map, _min_sha1);
        ds_priority_delete_min(global.__scribble_cache_priority_queue);
    }
}
until (ds_priority_empty(global.__scribble_cache_priority_queue) || (current_time <= _min_time));



global.__scribble_last_drawn = _scribble;

return _scribble;