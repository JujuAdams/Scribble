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

var _pages = _json[| __SCRIBBLE.PAGE_ARRAY ];
for(var _p = array_length_1d(_pages)-1; _p >= 0; _p--)
{
    var _page_array  = _pages[ _p ];
    var _vbuff_array = _page_array[ __SCRIBBLE_PAGE.VERTEX_BUFFER_ARRAY ];
    
    for(var _v = array_length_1d(_vbuff_array)-1; _v >= 0; _v--)
    {
        var _vbuff_data = _vbuff_array[ _v ];
        var _vbuff = _vbuff_data[ __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER ];
        vertex_delete_buffer(_vbuff);
    }
}

ds_list_destroy(_json);