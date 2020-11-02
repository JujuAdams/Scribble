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
        var _vbuff_data = texture_to_buffer_map[? _texture];
        if (_vbuff_data == undefined)
        {
            var _vbuff_data = __new_vertex_buffer(_texture, _for_text);
            texture_to_buffer_map[? _texture] = _vbuff_data;
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
            vbuff_data.word_x_offset   = undefined;
            ++_v;
        }
    }
    
    static __clean_up = function(_destroy_buffer)
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
    
    static __flush = function()
    {
        var _i = 0;
        repeat(array_length(vertex_buffer_array))
        {
            vertex_buffer_array[_i].__flush();
            ++_i;
        }
    }
    
    static __submit = function(_element)
    {
        var _tw_method = 0;
        if (_element.tw_do) _tw_method = _element.tw_in? 1 : -1;
        
        var _shader = undefined;
        
        var _i = 0;
        repeat(array_length(vertex_buffer_array))
        {
            var _vertex_buffer = vertex_buffer_array[_i];
            
            if (_vertex_buffer.shader != _shader)
            {
                _shader = _vertex_buffer.shader;
                
                if (_shader == __shd_scribble)
                {
                    shader_set(__shd_scribble);
                    shader_set_uniform_f(global.__scribble_uniform_time, _element.animation_time);
                    
                    shader_set_uniform_f(global.__scribble_uniform_tw_method, _tw_method);
                    shader_set_uniform_f(global.__scribble_uniform_tw_smoothness, _element.tw_smoothness);
                    shader_set_uniform_f_array(global.__scribble_uniform_tw_window_array, _element.tw_do? _element.tw_window_array : global.__scribble_window_array_null);
                    
                    shader_set_uniform_f(global.__scribble_uniform_colour_blend, colour_get_red(  _element.blend_colour)/255,
                                                                                 colour_get_green(_element.blend_colour)/255,
                                                                                 colour_get_blue( _element.blend_colour)/255,
                                                                                 _element.blend_alpha);
                    
                    shader_set_uniform_f(global.__scribble_uniform_fog, colour_get_red(  _element.fog_colour)/255,
                                                                        colour_get_green(_element.fog_colour)/255,
                                                                        colour_get_blue( _element.fog_colour)/255,
                                                                        _element.fog_alpha);
                    
                    shader_set_uniform_f_array(global.__scribble_uniform_data_fields,  _element.animation_array);
                    shader_set_uniform_f_array(global.__scribble_uniform_bezier_array, _element.bezier_array);
                    
                    shader_set_uniform_f(global.__scribble_u_vTypewriterStartPos,      0, 0);
                    shader_set_uniform_f(global.__scribble_u_vTypewriterStartScale,    1.5, 1.5);
                    shader_set_uniform_f(global.__scribble_u_fTypewriterStartRotation, -50);
                    shader_set_uniform_f(global.__scribble_u_fTypewriterAlphaDuration, 0.2);
                }
                else if (_shader == __shd_scribble_msdf)
                {
                    shader_set(__shd_scribble_msdf);
                    shader_set_uniform_f(global.__scribble_msdf_uniform_time, _element.animation_time);
                    
                    shader_set_uniform_f(global.__scribble_msdf_uniform_tw_method, _tw_method);
                    shader_set_uniform_f(global.__scribble_msdf_uniform_tw_smoothness, _element.tw_smoothness);
                    shader_set_uniform_f_array(global.__scribble_msdf_uniform_tw_window_array, _element.tw_do? _element.tw_window_array : global.__scribble_window_array_null);
                    
                    shader_set_uniform_f(global.__scribble_msdf_uniform_colour_blend, colour_get_red(  _element.blend_colour)/255,
                                                                                      colour_get_green(_element.blend_colour)/255,
                                                                                      colour_get_blue( _element.blend_colour)/255,
                                                                                      _element.blend_alpha);
                    
                    shader_set_uniform_f(global.__scribble_msdf_uniform_fog, colour_get_red(  _element.fog_colour)/255,
                                                                             colour_get_green(_element.fog_colour)/255,
                                                                             colour_get_blue( _element.fog_colour)/255,
                                                                             _element.fog_alpha);
                    
                    shader_set_uniform_f_array(global.__scribble_msdf_uniform_data_fields,  _element.animation_array);
                    shader_set_uniform_f_array(global.__scribble_msdf_uniform_bezier_array, _element.bezier_array);
                    
                    shader_set_uniform_f(global.__scribble_msdf_u_vTypewriterStartPos,      0, 0);
                    shader_set_uniform_f(global.__scribble_msdf_u_vTypewriterStartScale,    1, 1);
                    shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterStartRotation, 0);
                    shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterAlphaDuration, 0);
                }
            }
            
            if (_shader == __shd_scribble_msdf)
            {
                shader_set_uniform_f(global.__scribble_msdf_uniform_texel, _vertex_buffer.texel_width, _vertex_buffer.texel_height);
                shader_set_uniform_f(global.__scribble_msdf_uniform_range, _vertex_buffer.msdf_range);
            }
            
            _vertex_buffer.__submit();
            ++_i;
        }
        
        shader_reset();
    }
}