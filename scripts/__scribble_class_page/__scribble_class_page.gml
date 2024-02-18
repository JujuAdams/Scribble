#macro __SCRIBBLE_PAGE_VALIDATE_LINE_INDEX  if (_line_index < 0) __scribble_error("Line index ", _line_index, " doesn't exist. Minimum line index is 0");\
                                            var _line_count = array_length(__line_array);\
                                            if (_line_index >= _line_count) __scribble_error("Line index ", _line_index, " doesn't exist. Maximum line index is ", _line_count-1);

function __scribble_class_page() constructor
{
    static __scribble_state = __scribble_get_state();
    
    __text = "";
    
    __created_frame = __scribble_state.__frames;
    __frozen = undefined;
    
    __character_count = 0;
    
    __glyph_start = undefined;
    __glyph_end   = undefined;
    __glyph_count = 0;
    
    __line_start = undefined;
    __line_end   = undefined;
    __line_count = 0;
    
    __line_array = [];
    
    __width  = 0;
    __height = 0;
    __min_x  = 0;
    __min_y  = 0;
    __max_x  = 0;
    __max_y  = 0;
    
    __vertex_buffer_array = [];
    __material_alias_to_vertex_buffer_dict = {};
    
    static __submit = function(_double_draw, _scroll_top, _scroll_bottom)
    {
        if (_scroll_top >= __max_y) || (_scroll_bottom <= __min_y)
        {
            //Not visible
            return;
        }
        
        if (SCRIBBLE_INCREMENTAL_FREEZE && !__frozen && (__created_frame < __scribble_state.__frames)) __freeze();
        
        static _u_fPageYOffset = shader_get_uniform(__shd_scribble, "u_fPageYOffset");
        shader_set_uniform_f(_u_fPageYOffset, -_scroll_top);
        
        var _old_tex_filter = gpu_get_tex_filter();
        
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            __vertex_buffer_array[_i].__submit(_double_draw);
            ++_i;
        }
        
        gpu_set_tex_filter(_old_tex_filter);
    }
    
    static __freeze = function()
    {
        if (SCRIBBLE_VERBOSE) var _t = get_timer();
        
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            vertex_freeze(__vertex_buffer_array[_i].__vertex_buffer);
            ++_i;
        }
        
        __frozen = true;
            
        if (SCRIBBLE_VERBOSE) __scribble_trace("Incrementally froze page vertex buffers, time taken = ", (get_timer() - _t)/1000, "ms");
    }
    
    /// @param lineIndex
    static __get_line_y = function(_line_index)
    {
        __SCRIBBLE_PAGE_VALIDATE_LINE_INDEX
        return __line_array[_line_index].__model_y;
    }
    
    /// @param lineIndex
    static __get_line_height = function(_line_index)
    {
        __SCRIBBLE_PAGE_VALIDATE_LINE_INDEX
        return __line_array[_line_index].__height;
    }
    
    static __ensure_vertex_buffer = function(_material_alias)
    {
        var _data = __material_alias_to_vertex_buffer_dict[$ string(_material_alias)];
        if (_data == undefined)
        {
            var _data = new __scribble_class_vertex_buffer(_material_alias);
            array_push(__vertex_buffer_array, _data);
            __material_alias_to_vertex_buffer_dict[$ string(_material_alias)] = _data;
        }
        
        return _data.__vertex_buffer;
    }
    
    static __finalize_vertex_buffers = function(_freeze)
    {
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            var _vbuff = __vertex_buffer_array[_i].__vertex_buffer;
            vertex_end(_vbuff);
            if (_freeze) vertex_freeze(_vbuff);
            
            ++_i;
        }
        
        __frozen = _freeze;
    }
    
    static __flush = function()
    {
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            __vertex_buffer_array[_i].__flush();
            ++_i;
        }
        
        __material_alias_to_vertex_buffer_dict = {};
        array_resize(__vertex_buffer_array, 0);
    }
}