/// @param x
/// @param y
/// @param string
/// @param [minLineHeight]
/// @param [maxLineWidth]
/// @param [xscale]         The horizontal scaling of the text. Defaults to the value set in __scribble_config()
/// @param [yscale]         The vertical scaling of the text. Defaults to the value set in __scribble_config()
/// @param [angle]          The rotation of the text. Defaults to the value set in __scribble_config()
/// @param [colour]         The blend colour for the text. Defaults to draw_get_colour()
/// @param [alpha]          The alpha blend for the text. Defaults to draw_get_alpha()

var _x               = argument[0];
var _y               = argument[1];
var _string          = argument[2];
var _line_min_height = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : -1;
var _width_limit     = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : -1;
var _xscale          = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 1;
var _yscale          = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : 1;
var _angle           = ((argument_count > 7) && (argument[7] != undefined))? argument[7] : 0;
var _colour          = ((argument_count > 8) && (argument[8] != undefined))? argument[8] : draw_get_colour();
var _alpha           = ((argument_count > 9) && (argument[9] != undefined))? argument[9] : draw_get_alpha();



var _sha1 = sha1_string_utf8(_string) + ":" + string(_line_min_height) + ":" + string(_width_limit);

var _scribble = global.__scribble_cache_map[? _sha1];
if (_scribble != undefined)
{
    ds_priority_change_priority(global.__scribble_cache_priority_queue, _sha1, current_time + SCRIBBLE_CACHE_DECAY);
}
else
{
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Adding \"" + _sha1 + "\" to cache");
    _scribble = scribble_create_static(_string);
    _scribble[| SCRIBBLE.STATIC] = false;
    
    global.__scribble_cache_map[? _sha1] = _scribble;
    ds_priority_add(global.__scribble_cache_priority_queue, _sha1, current_time + SCRIBBLE_CACHE_DECAY);
}

if (!global.__scribble_defeat_draw)
{
    scribble_set_box_alignment(_scribble, _scribble[| SCRIBBLE.STRING_HALIGN], _scribble[| SCRIBBLE.STRING_VALIGN]);
    scribble_draw_static(_scribble, _x, _y, _xscale, _yscale, _angle, _colour, _alpha);
}



do
{
    var _min_sha1 = ds_priority_find_min(global.__scribble_cache_priority_queue);
    var _min_time = ds_priority_find_priority(global.__scribble_cache_priority_queue, _min_sha1);
    if (current_time > _min_time)
    {
        if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Deleting \"" + _min_sha1 + "\" from cache");
        
        var _scribble = global.__scribble_cache_map[? _min_sha1];
        scribble_destroy_static(_scribble);
        
        ds_map_delete(global.__scribble_cache_map, _min_sha1);
        ds_priority_delete_min(global.__scribble_cache_priority_queue);
    }
}
until (ds_priority_empty(global.__scribble_cache_priority_queue) || (current_time <= _min_time));



return _scribble;