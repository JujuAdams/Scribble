/// 
/// @param json         The Scribble data structure to target
/// @param speed        The speed of the fade effect

var _json  = argument0;
var _speed = argument1;

if (!is_real(_json) || !ds_exists(_json, ds_type_list))
{
    show_error("Scribble:\nScribble data structure \"" + string( _json ) + "\" doesn't exist!\n ", false);
    exit;
}

_json[| __SCRIBBLE.TW_SPEED] = _speed;