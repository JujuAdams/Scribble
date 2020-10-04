function __scribble_class_vertex_buffer(_texture, _for_text) constructor
{
    texture      = _texture;
    texel_width  = texture_get_texel_width( texture);
    texel_height = texture_get_texel_height(texture);
    
    buffer = buffer_create(__SCRIBBLE_GLYPH_BYTE_SIZE*(_for_text? __SCRIBBLE_EXPECTED_GLYPHS : 1), buffer_grow, 1);
    line_start_list = ds_list_create();
    
    vertex_buffer   = undefined;
    char_start_tell = 0;
    word_start_tell = 0;
    word_x_offset   = 0;
    
    __clean_up = function(_destroy_buffer)
    {
        if (line_start_list != undefined) ds_list_destroy(line_start_list);
    	line_start_list = undefined;
        
    	char_start_tell = undefined;
    	word_start_tell = undefined;
    	word_x_offset   = undefined;
        
        if (_destroy_buffer && (buffer != undefined))
        {
	        buffer_delete(buffer);
	        buffer = undefined;
        }
    }
    
    __build_vertex_buffer = function(_freeze)
    {
	    var _vertex_buffer = vertex_create_buffer_from_buffer_ext(buffer, global.__scribble_vertex_format, 0, buffer_tell(buffer) / __SCRIBBLE_VERTEX.__SIZE);
	    if (_freeze) vertex_freeze(_vertex_buffer);
	    vertex_buffer = _vertex_buffer;
    }
    
    __flush = function()
    {
        if (vertex_buffer != undefined) vertex_delete_buffer(vertex_buffer);
        vertex_buffer = undefined;
    }
    
    __submit = function()
    {
	    vertex_submit(vertex_buffer, pr_trianglelist, texture);
    }
}