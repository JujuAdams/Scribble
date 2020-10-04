enum __SCRIBBLE_PAGE
{
	LINES,                // 0
	START_CHAR,           // 1
	LAST_CHAR,            // 2
	LINES_ARRAY,          // 3
	VERTEX_BUFFERS_ARRAY, // 4
    START_EVENT,          // 5
    MAX_X,                // 6
    MIN_X,                // 7
    WIDTH,                // 8
    HEIGHT,               // 9
	__SIZE
}

function __scribble_class_page() constructor
{
    lines               = 0;
    start_char          = 0;
    last_char           = 0;
    lines_array         = [];
    vertex_buffer_array = [];
    start_event         = 0;
    max_x               = 0;
    min_x               = 0;
    width               = 0;
    height              = 0;
    
    texture_to_buffer_map = ds_map_create();
    
    __new_line = function()
    {
        var _line_data = new __scribble_class_line();
        
    	lines_array[@ lines] = _line_data;
    	lines++;
        
        return _line_data;
    }
    
    __new_vertex_buffer = function(_texture, _for_text)
    {
        var _vertex_buffer_data = new __scribble_class_vertex_buffer(_texture, _for_text)
        
        vertex_buffer_array[@ array_length(vertex_buffer_array)] = _vertex_buffer_data;
        
        return _vertex_buffer_data;
    }
    
    __find_vertex_buffer = function(_texture, _for_text)
    {
	    var _vbuff_data = texture_to_buffer_map[? _texture];
	    if (_vbuff_data == undefined)
	    {
            var _vbuff_data = __new_vertex_buffer(_texture, _for_text);
	        texture_to_buffer_map[? _texture] = _vbuff_data;
	    }
        
        return _vbuff_data;
    }
    
    __reset_word_start = function()
    {
	    var _v = 0;
	    repeat(array_length(vertex_buffer_array))
	    {
	        var vbuff_data = vertex_buffer_array[_v];
	        vbuff_data.word_start_tell = buffer_tell(vbuff_data.buffer);
	        vbuff_data.word_x_offset   = undefined;
	        ++_v;
	    }
    }
    
    __clean_up = function(_destroy_buffer)
    {
        if (texture_to_buffer_map != undefined) ds_map_destroy(texture_to_buffer_map);
    	texture_to_buffer_map = undefined;
        
        var _i = 0;
        repeat(array_length(vertex_buffer_array))
        {
            vertex_buffer_array[_i].__clean_up(_destroy_buffer);
            ++_i;
        }
    }
    
    __flush = function()
    {
	    var _i = 0;
	    repeat(array_length(vertex_buffer_array))
	    {
	        vertex_buffer_array[_i].__flush();
	        ++_i;
	    }
    }
    
    __submit = function()
    {
	    var _i = 0;
	    repeat(array_length(vertex_buffer_array))
	    {
	        vertex_buffer_array[_i].__submit();
	        ++_i;
	    }
    }
}