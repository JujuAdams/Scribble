/// Draws a string
///
/// @param x                 The x position in the room to draw at
/// @param y                 The y position in the room to draw at
/// @param string            The string to be drawn. See scribble_create()
/// @param [minLineHeight]   The minimum line height for each line of text. Use a negative number to use the height of a space character of the default font (the default behaviour)
/// @param [maxLineWidth]    The maximum line width for each line of text. Use a negative number for no limit (the default behaviour)
/// @param [xscale]          The horizontal scaling of the text. Defaults to the value set in __scribble_config()
/// @param [yscale]          The vertical scaling of the text. Defaults to the value set in __scribble_config()
/// @param [angle]           The rotation of the text. Defaults to the value set in __scribble_config()
/// @param [colour]          The blend colour for the text. Defaults to draw_get_colour()
/// @param [alpha]           The alpha blend for the text. Defaults to draw_get_alpha()
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _x               = argument[0];
var _y               = argument[1];
var _string          = argument[2];
var _line_min_height = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : -1;
var _width_limit     = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : -1;
var _xscale          = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : SCRIBBLE_DEFAULT_XSCALE;
var _yscale          = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : SCRIBBLE_DEFAULT_YSCALE;
var _angle           = ((argument_count > 7) && (argument[7] != undefined))? argument[7] : SCRIBBLE_DEFAULT_ANGLE;
var _colour          = ((argument_count > 8) && (argument[8] != undefined))? argument[8] : draw_get_colour();
var _alpha           = ((argument_count > 9) && (argument[9] != undefined))? argument[9] : draw_get_alpha();

var _cache_string = string(_string) + ":" + string(_width_limit) + ":" + string(_line_min_height);
if (ds_map_exists(global.__scribble_cache_map, _cache_string))
{
    var _scribble_array = global.__scribble_cache_map[? _cache_string];
    _scribble_array[@ __SCRIBBLE.TIME] = current_time;
}
else
{
    var _scribble_array = scribble_create(_string, _line_min_height, _width_limit);
    global.__scribble_cache_map[? _cache_string] = _scribble_array;
    ds_list_add(global.__scribble_cache_list, _cache_string);
}

scribble_draw(_scribble_array, _x, _y, _xscale, _yscale, _angle, _colour, _alpha);

if (SCRIBBLE_CACHE_TIMEOUT > 0)
{
    //Scan through the cache to see if any scribble data structures have elapsed
    global.__scribble_cache_test_index = (global.__scribble_cache_test_index + 1) mod ds_list_size(global.__scribble_cache_list);
    var _string = global.__scribble_cache_list[| global.__scribble_cache_test_index];
    var _scribble_array = global.__scribble_cache_map[? _string];
    if (_scribble_array[__SCRIBBLE.TIME] + SCRIBBLE_CACHE_TIMEOUT < current_time)
    {
        if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: Removing \"" + _string + "\" from cache");
        scribble_destroy(_scribble_array);
        ds_map_delete(global.__scribble_cache_map, _string);
        ds_list_delete(global.__scribble_cache_list, global.__scribble_cache_test_index);
    }
}

return _scribble_array;