/// @param scribbleArray   The Scribble data structure to be drawn

var _scribble_array = argument0;

if (!scribble_exists(_scribble_array))
{
    show_error("Scribble:\nScribble data structure \"" + string(_scribble_array) + "\" doesn't exist!\n ", false);
    exit;
}

var _vbuff_list = _scribble_array[__SCRIBBLE.VERTEX_BUFFER_LIST];
var _i = 0;
repeat(ds_list_size(_vbuff_list))
{
    var _vbuff_data = _vbuff_list[| _i];
    vertex_freeze(_vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER]);
    _i++;
}