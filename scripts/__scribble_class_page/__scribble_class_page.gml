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
    
    texture_to_buffer_dict = {};
    
    static __new_line = function()
    {
        var _line_data = new __scribble_class_line();
        
        lines_array[@ lines] = _line_data;
        lines++;
        
        return _line_data;
    }
    
    static __new_vertex_buffer = function(_texture, _for_text)
    {
        var _vertex_buffer_data = new __scribble_class_vertex_buffer(_texture, _for_text)
        
        vertex_buffer_array[@ array_length(vertex_buffer_array)] = _vertex_buffer_data;
        
        return _vertex_buffer_data;
    }
    
    static __find_vertex_buffer = function(_texture, _for_text)
    {
        var _pointer_string = string(_texture);
        
        var _vbuff_data = texture_to_buffer_dict[$ _pointer_string];
        if (_vbuff_data == undefined)
        {
            var _vbuff_data = __new_vertex_buffer(_texture, _for_text);
            texture_to_buffer_dict[$ _pointer_string] = _vbuff_data;
        }
        
        return _vbuff_data;
    }
    
    static __reset_word_start = function()
    {
        var _v = 0;
        repeat(array_length(vertex_buffer_array))
        {
            var vbuff_data = vertex_buffer_array[_v];
            vbuff_data.word_start_tell = buffer_tell(vbuff_data.buffer);
            ++_v;
        }
    }
    
    static __clean_up = function(_destroy_buffer)
    {
        texture_to_buffer_dict = undefined;
        
        var _i = 0;
        repeat(array_length(vertex_buffer_array))
        {
            vertex_buffer_array[_i].__clean_up(_destroy_buffer);
            ++_i;
        }
    }
    
    static __flush = function()
    {
        __clean_up(true);
        
        var _i = 0;
        repeat(array_length(vertex_buffer_array))
        {
            vertex_buffer_array[_i].__flush();
            ++_i;
        }
    }
    
    static __submit = function(_element)
    {
        var _shader = undefined;
        var _i = 0;
        repeat(array_length(vertex_buffer_array))
        {
            var _vertex_buffer = vertex_buffer_array[_i];
            
            if (_vertex_buffer.shader != _shader)
            {
                _shader = _vertex_buffer.shader;
                shader_set(_shader);
            }
            
            if (_shader == __shd_scribble_msdf)
            {
                //Force texture filtering when using MSDF fonts
                var _old_tex_filter = gpu_get_tex_filter();
                gpu_set_tex_filter(true);
                
                //Set shader uniforms unique to the MSDF shader
                shader_set_uniform_f(global.__scribble_msdf_u_vTexel, _vertex_buffer.texel_width, _vertex_buffer.texel_height);
                shader_set_uniform_f(global.__scribble_msdf_u_fMSDFRange, _element.msdf_feather_thickness*_vertex_buffer.msdf_range);
                
                _vertex_buffer.__submit();
                
                //Reset the texture filtering
                gpu_set_tex_filter(_old_tex_filter);
            }
            else
            {
                //Other shaders don't need extra work
                _vertex_buffer.__submit();
            }
            
            ++_i;
        }
        
        shader_reset();
    }
}