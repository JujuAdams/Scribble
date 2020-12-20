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
            vbuff_data.word_x_offset   = undefined;
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
        var _tw_method = 0;
        if (_element.tw_do) _tw_method = _element.tw_in? 1 : -1;
        
        var _shader = undefined;
        
        //TODO - Calculate this somewhere else
        var _tw_method   = 0;
        var _tw_char_max = 0;
        if (_element.tw_do)
        {
            _tw_method = _element.tw_anim_ease_method;
            if (!_element.tw_in) _tw_method += SCRIBBLE_EASE.__SIZE;
            if (_element.tw_backwards) _tw_char_max = 1 + last_char - start_char;
        }
        
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
                    shader_set_uniform_f(global.__scribble_u_fTime, _element.animation_time);
                    
                    shader_set_uniform_f(global.__scribble_u_vColourBlend, colour_get_red(  _element.blend_colour)/255,
                                                                           colour_get_green(_element.blend_colour)/255,
                                                                           colour_get_blue( _element.blend_colour)/255,
                                                                           _element.blend_alpha);
                    
                    shader_set_uniform_f(global.__scribble_u_vFog, colour_get_red(  _element.fog_colour)/255,
                                                                   colour_get_green(_element.fog_colour)/255,
                                                                   colour_get_blue( _element.fog_colour)/255,
                                                                   _element.fog_alpha);
                    
                    shader_set_uniform_f_array(global.__scribble_u_aDataFields, _element.animation_array);
                    shader_set_uniform_f_array(global.__scribble_u_aBezier, _element.bezier_array);
                    shader_set_uniform_f(global.__scribble_u_fBlinkState, _element.animation_blink_state);
                    
                    shader_set_uniform_i(global.__scribble_u_iTypewriterMethod,        _tw_method);
                    shader_set_uniform_i(global.__scribble_u_iTypewriterCharMax,       _tw_char_max);
                    shader_set_uniform_f(global.__scribble_u_fTypewriterSmoothness,    _element.tw_anim_smoothness);
                    shader_set_uniform_f(global.__scribble_u_vTypewriterStartPos,      _element.tw_anim_dx, _element.tw_anim_dy);
                    shader_set_uniform_f(global.__scribble_u_vTypewriterStartScale,    _element.tw_anim_xscale, _element.tw_anim_yscale);
                    shader_set_uniform_f(global.__scribble_u_fTypewriterStartRotation, _element.tw_anim_rotation);
                    shader_set_uniform_f(global.__scribble_u_fTypewriterAlphaDuration, _element.tw_anim_alpha_duration);
                    shader_set_uniform_f_array(global.__scribble_u_fTypewriterWindowArray, _element.tw_do? _element.tw_window_array : global.__scribble_window_array_null);
                }
                else if (_shader == __shd_scribble_msdf)
                {
                    shader_set(__shd_scribble_msdf);
                    shader_set_uniform_f(global.__scribble_msdf_u_fTime, _element.animation_time);
                    
                    shader_set_uniform_f(global.__scribble_msdf_u_vColourBlend, colour_get_red(  _element.blend_colour)/255,
                                                                                colour_get_green(_element.blend_colour)/255,
                                                                                colour_get_blue( _element.blend_colour)/255,
                                                                                _element.blend_alpha);
                    
                    shader_set_uniform_f(global.__scribble_msdf_u_vFog, colour_get_red(  _element.fog_colour)/255,
                                                                        colour_get_green(_element.fog_colour)/255,
                                                                        colour_get_blue( _element.fog_colour)/255,
                                                                        _element.fog_alpha);
                    
                    shader_set_uniform_f_array(global.__scribble_msdf_u_aDataFields, _element.animation_array);
                    shader_set_uniform_f_array(global.__scribble_msdf_u_aBezier, _element.bezier_array);
                    shader_set_uniform_f(global.__scribble_msdf_u_fBlinkState, _element.animation_blink_state);
                    
                    shader_set_uniform_i(global.__scribble_msdf_u_iTypewriterMethod,        _tw_method);
                    shader_set_uniform_i(global.__scribble_msdf_u_iTypewriterCharMax,       _tw_char_max);
                    shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterSmoothness,    _element.tw_anim_smoothness);
                    shader_set_uniform_f(global.__scribble_msdf_u_vTypewriterStartPos,      _element.tw_anim_dx, _element.tw_anim_dy);
                    shader_set_uniform_f(global.__scribble_msdf_u_vTypewriterStartScale,    _element.tw_anim_xscale, _element.tw_anim_yscale);
                    shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterStartRotation, _element.tw_anim_rotation);
                    shader_set_uniform_f(global.__scribble_msdf_u_fTypewriterAlphaDuration, _element.tw_anim_alpha_duration);
                    shader_set_uniform_f_array(global.__scribble_msdf_u_fTypewriterWindowArray, _element.tw_do? _element.tw_window_array : global.__scribble_window_array_null);
                }
            }
            
            if (_shader == __shd_scribble_msdf)
            {
                shader_set_uniform_f(global.__scribble_msdf_u_vTexel, _vertex_buffer.texel_width, _vertex_buffer.texel_height);
                shader_set_uniform_f(global.__scribble_msdf_u_fMSDFRange, _element.msdf_feather_thickness*_vertex_buffer.msdf_range);
                
                shader_set_uniform_f(global.__scribble_msdf_u_vShadowOffset, _element.msdf_shadow_xoffset, _element.msdf_shadow_yoffset);
                
                shader_set_uniform_f(global.__scribble_msdf_u_vShadowColour, colour_get_red(  _element.msdf_shadow_colour)/255,
                                                                             colour_get_green(_element.msdf_shadow_colour)/255,
                                                                             colour_get_blue( _element.msdf_shadow_colour)/255,
                                                                             _element.msdf_shadow_alpha);
                                                                                
                shader_set_uniform_f(global.__scribble_msdf_u_vBorderColour, colour_get_red(  _element.msdf_border_colour)/255,
                                                                             colour_get_green(_element.msdf_border_colour)/255,
                                                                             colour_get_blue( _element.msdf_border_colour)/255);
                                                                             
                shader_set_uniform_f(global.__scribble_msdf_u_fBorderThickness, _element.msdf_border_thickness);
                
                //Force texture filtering when using MSDF fonts
                var _old_tex_filter = gpu_get_tex_filter();
                gpu_set_tex_filter(true);
            }
            
            _vertex_buffer.__submit();
            
            if (_shader == __shd_scribble_msdf)
            {
                gpu_set_tex_filter(_old_tex_filter);
            }
            
            ++_i;
        }
        
        shader_reset();
    }
}