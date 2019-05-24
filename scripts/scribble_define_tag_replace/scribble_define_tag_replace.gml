/// @param oldTag   Command tag to replace, as a string
/// @param newTag   New command tag, as a string

var _old_tag = argument0;
var _new_tag = argument1;

if (!variable_global_exists("__scribble_global_count"))
{
    show_error("Scribble:\nscribble_add_asset() should be called after initialising Scribble.\n ", false);
    exit;
}

if (!is_string(_old_tag))
{
    show_error("Scribble:\nOld command tags should be strings.\n(Input to script was \"" + string(_old_tag) + "\")\n ", false);
    exit;
}

if (!is_string(_new_tag))
{
    show_error("Scribble:\nNew command tags should be strings.\n(Input to script was \"" + string(_new_tag) + "\")\n ", false);
    exit;
}

var _old_list = global.__scribble_tag_replace[? _old_tag];
if (is_real(_old_list) && ds_exists(_old_list, ds_type_list))
{
    var _string = "";
    var _size = ds_list_size(_old_list);
    for(var _i = 0; _i < _size; _i++)
    {
        _string += string(_old_list[| _i]);
        if (_i < _size-1) _string += chr(SCRIBBLE_COMMAND_TAG_ARGUMENT);
    }
    
    var _string = string(_old_list);
    show_debug_message("Scribble: WARNING! Overwriting tag replacement [" + _old_tag + "] --> [" + _string + "]");
    
    ds_list_destroy(_old_list);
}

var _list = ds_list_create();
var _work_string = _new_tag + chr(SCRIBBLE_COMMAND_TAG_ARGUMENT);
var _pos = string_pos(chr(SCRIBBLE_COMMAND_TAG_ARGUMENT), _work_string);
while(_pos > 0)
{
    ds_list_add(_list, string_copy(_work_string, 1, _pos-1));
    _work_string = string_delete(_work_string, 1, _pos);
    _pos = string_pos(chr(SCRIBBLE_COMMAND_TAG_ARGUMENT), _work_string);
}

ds_map_add_list(global.__scribble_tag_replace, _old_tag, _list);
if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Replacing [" + _old_tag + "] with [" + _new_tag + "]");