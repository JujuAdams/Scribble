function __scribble_class_vertex_buffer(_texture, _for_text) constructor
{
    texture      = _texture;
    texel_width  = texture_get_texel_width( texture);
    texel_height = texture_get_texel_height(texture);
    shader       = __shd_scribble;
    
    buffer = buffer_create(__SCRIBBLE_GLYPH_BYTE_SIZE*(_for_text? __SCRIBBLE_EXPECTED_GLYPHS : 1), buffer_grow, 1);
    
    line_start_array = [];
    
    vertex_buffer   = undefined;
    char_start_tell = 0;
    word_start_tell = 0;
    msdf_range      = undefined;
    
    static __clean_up = function(_destroy_buffer)
    {
        char_start_tell  = undefined;
        word_start_tell  = undefined;
        line_start_array = undefined;
        
        if (_destroy_buffer && (buffer != undefined))
        {
            buffer_delete(buffer);
            buffer = undefined;
        }
    }
    
    static __build_vertex_buffer = function(_freeze)
    {
        var _vertex_buffer = vertex_create_buffer_from_buffer_ext(buffer, global.__scribble_vertex_format, 0, buffer_tell(buffer) / __SCRIBBLE_VERTEX.__SIZE);
        if (_freeze) vertex_freeze(_vertex_buffer);
        vertex_buffer = _vertex_buffer;
        
        __scribble_gc_add_vbuff(self, _vertex_buffer);
    }
    
    static __flush = function()
    {
        __clean_up(true);
        
        if (vertex_buffer != undefined)
        {
            __scribble_gc_remove_vbuff(vertex_buffer);
            vertex_delete_buffer(vertex_buffer);
            vertex_buffer = undefined;
        }
    }
    
    static __submit = function()
    {
        vertex_submit(vertex_buffer, pr_trianglelist, texture);
    }
}