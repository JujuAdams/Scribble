function __scribble_class_page() constructor
{
    __text = "";
    __glyph_grid = undefined;
    
    __created_time = current_time;
    __frozen = undefined;
    
    __character_count = 0;
    
    __glyph_start = undefined;
    __glyph_end   = undefined;
    __glyph_count = 0;
    
    __line_start = undefined;
    __line_end   = undefined;
    __line_count = 0;
    
    __width  = 0;
    __height = 0;
    __min_x  = 0;
    __min_y  = 0;
    __max_x  = 0;
    __max_y  = 0;
    
    __vertex_buffer_array = [];
    if (!__SCRIBBLE_ON_WEB) __texture_to_vertex_buffer_dict = {}; //FIXME - Workaround for pointers not being stringified properly on HTML5
    
    __events = {};
    __region_array = [];
    
    static __submit = function(_msdf_feather_thickness, _double_draw)
    {
        if (SCRIBBLE_INCREMENTAL_FREEZE && !__frozen && (current_time - __created_time > __SCRIBBLE_EXPECTED_FRAME_TIME)) __freeze();
        
        var _shader = undefined;
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            var _data = __vertex_buffer_array[_i];
            var _bilinear = _data[__SCRIBBLE_VERTEX_BUFFER.__BILINEAR];
            
            if (_data[__SCRIBBLE_VERTEX_BUFFER.__SHADER] != _shader)
            {
                _shader = _data[__SCRIBBLE_VERTEX_BUFFER.__SHADER];
                shader_set(_shader);
            }
            
            if (_bilinear != undefined)
            {
                //Force texture filtering when using MSDF fonts
                var _old_tex_filter = gpu_get_tex_filter();
                gpu_set_tex_filter(_bilinear);
            }
            
            if (_shader == __shd_scribble_msdf)
            {
                //Set shader uniforms unique to the MSDF shader
                shader_set_uniform_f(global.__scribble_msdf_u_vTexel, _data[__SCRIBBLE_VERTEX_BUFFER.__TEXEL_WIDTH], _data[__SCRIBBLE_VERTEX_BUFFER.__TEXEL_HEIGHT]);
                shader_set_uniform_f(global.__scribble_msdf_u_fMSDFRange, _msdf_feather_thickness*_data[__SCRIBBLE_VERTEX_BUFFER.__MSDF_RANGE]);
                
                vertex_submit(_data[__SCRIBBLE_VERTEX_BUFFER.__VERTEX_BUFFER], pr_trianglelist, _data[__SCRIBBLE_VERTEX_BUFFER.__TEXTURE]);
                
                if (_double_draw)
                {
                    shader_set_uniform_f(global.__scribble_msdf_u_fSecondDraw, 1);
                    vertex_submit(_data[__SCRIBBLE_VERTEX_BUFFER.__VERTEX_BUFFER], pr_trianglelist, _data[__SCRIBBLE_VERTEX_BUFFER.__TEXTURE]);
                    shader_set_uniform_f(global.__scribble_msdf_u_fSecondDraw, 0);
                }
            }
            else
            {
                //Other shaders don't need extra work
                vertex_submit(_data[__SCRIBBLE_VERTEX_BUFFER.__VERTEX_BUFFER], pr_trianglelist, _data[__SCRIBBLE_VERTEX_BUFFER.__TEXTURE]);
            }
            
            if (_bilinear != undefined)
            {
                //Reset the texture filtering
                gpu_set_tex_filter(_old_tex_filter);
            }
            
            ++_i;
        }
        
        shader_reset();
    }
    
    static __freeze = function()
    {
        if (!__frozen)
        {
            if (SCRIBBLE_VERBOSE)
            {
                var _t = get_timer();
            }
            
            var _i = 0;
            repeat(array_length(__vertex_buffer_array))
            {
                vertex_freeze(__vertex_buffer_array[_i][__SCRIBBLE_VERTEX_BUFFER.__VERTEX_BUFFER]);
                ++_i;
            }
            
            __frozen = true;
            
            if (SCRIBBLE_VERBOSE)
            {
                __scribble_trace("Incrementally froze page vertex buffers, time taken = ", (get_timer() - _t)/1000);
            }
        }
    }
    
    static __get_glyph_data = function(_index)
    {
        if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("Cannot get glyph data, SCRIBBLE_ALLOW_GLYPH_DATA_GETTER = <false>\nPlease set SCRIBBLE_ALLOW_GLYPH_DATA_GETTER to <true> to get glyph data");
        
        if (_index < 1)
        {
            return {
                unicode: 0,
                left:    __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__LEFT],
                top:     __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__TOP ],
                right:   __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__LEFT],
                bottom:  __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__TOP ],
            };
        }
        else if (_index <= __glyph_count)
        {
            return {
                unicode: __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE],
                left:    __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__LEFT   ],
                top:     __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__TOP    ],
                right:   __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__RIGHT  ],
                bottom:  __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__BOTTOM ],
            };
        }
        else
        {
            _index = __glyph_count-1;
            return {
                unicode: 0,
                left:    __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__RIGHT ],
                top:     __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__BOTTOM],
                right:   __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__RIGHT ],
                bottom:  __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__BOTTOM],
            };
        }
    }
    
    static __get_vertex_buffer = function(_texture, _pxrange, _bilinear, _model_struct)
    {
        var _pointer_string = string(_texture);
        
        if (!__SCRIBBLE_ON_WEB)
        {
            var _data = __texture_to_vertex_buffer_dict[$ _pointer_string];
        }
        else //FIXME - Workaround for pointers not being stringified properly on HTML5
        {
            var _data = undefined;
            var _i = 0;
            repeat(array_length(__vertex_buffer_array))
            {
                var _vbuff_data = __vertex_buffer_array[_i];
                if (_vbuff_data[__SCRIBBLE_VERTEX_BUFFER.__TEXTURE] == _texture)
                {
                    _data = _vbuff_data;
                    break;
                }
                
                ++_i;
            }
        }
        
        if (_data == undefined)
        {
            if (_pxrange == undefined)
            {
                _model_struct.__uses_standard_font = true;
                var _shader = __shd_scribble;
            }
            else
            {
                _model_struct.__uses_msdf_font = true;
                var _shader = __shd_scribble_msdf;
            }
            
            var _vbuff = vertex_create_buffer(); //TODO - Can we preallocate this? i.e. copy "for text" system we had in the old version
            vertex_begin(_vbuff, global.__scribble_vertex_format);
            __scribble_gc_add_vbuff(self, _vbuff);
            
            var _data = array_create(__SCRIBBLE_VERTEX_BUFFER.__SIZE);
            _data[@ __SCRIBBLE_VERTEX_BUFFER.__VERTEX_BUFFER] = _vbuff;
            _data[@ __SCRIBBLE_VERTEX_BUFFER.__TEXTURE      ] = _texture;
            _data[@ __SCRIBBLE_VERTEX_BUFFER.__MSDF_RANGE   ] = _pxrange;
            _data[@ __SCRIBBLE_VERTEX_BUFFER.__TEXEL_WIDTH  ] = texture_get_texel_width(_texture);
            _data[@ __SCRIBBLE_VERTEX_BUFFER.__TEXEL_HEIGHT ] = texture_get_texel_height(_texture);
            _data[@ __SCRIBBLE_VERTEX_BUFFER.__SHADER       ] = _shader;
            _data[@ __SCRIBBLE_VERTEX_BUFFER.__BILINEAR     ] = _bilinear;
            
            __vertex_buffer_array[@ array_length(__vertex_buffer_array)] = _data;
            if (!__SCRIBBLE_ON_WEB) __texture_to_vertex_buffer_dict[$ _pointer_string] = _data;
            
            return _vbuff;
        }
        else
        {
            return _data[__SCRIBBLE_VERTEX_BUFFER.__VERTEX_BUFFER];
        }
    }
    
    static __finalize_vertex_buffers = function(_freeze)
    {
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            var _vbuff = __vertex_buffer_array[_i][__SCRIBBLE_VERTEX_BUFFER.__VERTEX_BUFFER];
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
            var _vbuff = __vertex_buffer_array[_i][__SCRIBBLE_VERTEX_BUFFER.__VERTEX_BUFFER];
            vertex_delete_buffer(_vbuff);
            __scribble_gc_remove_vbuff(_vbuff);
            
            ++_i;
        }
        
        __texture_to_vertex_buffer_dict = {};
        array_resize(__vertex_buffer_array, 0);
    }
}