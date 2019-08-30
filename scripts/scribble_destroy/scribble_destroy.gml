/// Destroys a Scribble data structure and frees up the memory it was using
///
/// @param scribbleArray

var _scribble_array = argument0;

if (!scribble_exists(_scribble_array))
{
    show_debug_message("Scribble: WARNING! Data structure \"" + string(_scribble_array) + "\" doesn't exist!\n ");
    exit;
}

ds_map_delete(global.__scribble_alive, _scribble_array[__SCRIBBLE.GLOBAL_INDEX]);

var _vbuff_list = _scribble_array[__SCRIBBLE.VERTEX_BUFFER_LIST];
var _count = ds_list_size(_vbuff_list);
for(var _i = 0; _i < _count; _i++)
{
    var _vbuff_data = _vbuff_list[| _i];
    var _vbuff = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER];
    vertex_delete_buffer(_vbuff);
}

ds_list_destroy(_scribble_array[@ __SCRIBBLE.LINE_LIST         ]);
ds_list_destroy(_scribble_array[@ __SCRIBBLE.VERTEX_BUFFER_LIST]);