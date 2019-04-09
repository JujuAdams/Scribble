/// Destroys a Scribble data structure and frees up the memory it was using
///
/// @param json

var _json = argument0;

if ( !is_real(_json) || !ds_exists(_json, ds_type_list) )
{
    show_debug_message("Scribble: Data structure \"" + string(_json) + "\" doesn't exist!\n ");
    exit;
}

ds_map_delete(global.__scribble_alive, _json[| __SCRIBBLE.GLOBAL_INDEX ]);

var _vbuff_list = _json[| __SCRIBBLE.VERTEX_BUFFER_LIST ];
var _count = ds_list_size(_vbuff_list);
for(var _i = 0; _i < _count; _i++)
{
    var _vbuff_data = _vbuff_list[| _i ];
    var _vbuff = _vbuff_data[| __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER ];
    vertex_delete_buffer(_vbuff);
}

ds_list_destroy(_json);