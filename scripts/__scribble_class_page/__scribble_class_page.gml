// Feather disable all

/// @param model

function __scribble_class_page(_model) constructor
{
    static _system = __scribble_system();
    
    __model = _model;
    
    __text = "";
    __glyph_grid = undefined;
    
    __created_frame = _system.__frames;
    __frozen = undefined;
    
    __reveal_count = 0;
    
    __glyph_start = undefined;
    __glyph_end   = undefined;
    __glyph_count = 0;
    
    __line_start = undefined;
    __line_end   = undefined;
    __line_count = 0;
    
    __line_data_array = undefined; //Only set to an array if we're allowing the line data getter
    
    __width  = 0;
    __height = 0;
    __min_x  = 0;
    __min_y  = 0;
    __max_x  = 0;
    __max_y  = 0;
    
    __vertex_buffer_array = [];
    __texture_to_vertex_buffer_dict = {};
    
    __events_dict  = {};
    __region_array = [];
    
    static __Finalize = function(_page_end_line)
    {
        static _animation_randomize_array = [];
        static _generator_state = __scribble_system().__generator_state;
        
        with(_generator_state)
        {
            var _glyph_grid     = __glyph_grid;
            var _word_grid      = __word_grid;
            var _line_array     = __line_array;
            var _modelMaxHeight = __modelMaxHeight;
            var _line_height    = __line_height;
        }
        
        __line_end    = _page_end_line;
        __line_count  = 1 + __line_end - __line_start;
        __glyph_end   = _word_grid[# _line_array[__line_end].wordEnd, __SCRIBBLE_GEN_WORD_GLYPH_END];
        __glyph_count = 1 + __glyph_end - __glyph_start;
        
        var _pageWidth = 0;
        var _i = __line_start;
        repeat(__line_count)
        {
            _pageWidth = max(_pageWidth, _line_array[_i].width);
            ++_i;
        }
        
        __width = _pageWidth;
        
        var _line_max_y = _line_array[_page_end_line].y + _line_height;
        __height = _line_max_y;
            
        //Correct page position for vertical alignment
        var _valign = __model.__valign;
        if (_valign == fa_middle)
        {
            __min_y = -(_line_max_y div 2);
            __max_y =  (_line_max_y div 2);
        }
        else if (_valign == fa_bottom)
        {
            __min_y = -_line_max_y;
            __max_y = 0;
        }
        else if (_valign == __SCRIBBLE_PIN_MIDDLE)
        {
            if (SCRIBBLE_PIN_ALIGNMENT_USES_PAGE_SIZE || (_modelMaxHeight == infinity))
            {
                __min_y = -(_line_max_y div 2);
                __max_y =  (_line_max_y div 2);
            }
            else
            {
                var _delta = _modelMaxHeight - _line_max_y;
                __min_y = 0.5*_delta;
                __max_y = _modelMaxHeight - 0.5*_delta;
            }
        }
        else if (_valign == __SCRIBBLE_PIN_BOTTOM)
        {
            if (SCRIBBLE_PIN_ALIGNMENT_USES_PAGE_SIZE || (_modelMaxHeight == infinity))
            {
                __min_y = -_line_max_y;
                __max_y = 0;
            }
            else
            {
                __min_y = _modelMaxHeight - _line_max_y;
                __max_y = _modelMaxHeight;
            }
        }
        else //fa_top or pin_top
        {
            __min_y = 0;
            __max_y = _line_max_y;
        }
            
        //Correct line positions for vertical alignment
        if (__min_y != 0)
        {
            var _i = __line_start;
            repeat(__line_count)
            {
                _line_array[_i].y += __min_y;
                ++_i;
            }
        }
            
        // Set up the character indexes for the page, relative to the character index of the first glyph on the page
        var _page_reveal_start = _glyph_grid[# __glyph_start, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX];
        var _page_reveal_end   = _glyph_grid[# __glyph_end,   __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX];
        __reveal_count = 1 + _page_reveal_end - _page_reveal_start;
            
        //Set up reveal indexes relative to the page
        ds_grid_add_region(_glyph_grid, __glyph_start, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, __glyph_end, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX, -_page_reveal_start);
            
        __line_data_array = [];
        
        var _line = __line_start;
        repeat(__line_count)
        {
            var _lineStruct = _line_array[_line];
            
            var _glyph_start = _word_grid[# _lineStruct.wordStart, __SCRIBBLE_GEN_WORD_GLYPH_START] - __glyph_start;
            var _glyph_end   = _word_grid[# _lineStruct.wordEnd,   __SCRIBBLE_GEN_WORD_GLYPH_END  ] - __glyph_start;
            
            _lineStruct.glyphStart = _glyph_start;
            _lineStruct.glyphEnd   = _glyph_end;
            _lineStruct.glyphCount = 1 + _glyph_end - _glyph_start;
            
            array_push(__line_data_array, _lineStruct);
            
            ++_line;
        }
            
        if (__model.__randomize_animation)
        {
            array_resize(_animation_randomize_array, __reveal_count);
            
            var _line = 0;
            repeat(__reveal_count)
            {
                _animation_randomize_array[@ _line] = _line;
                ++_line;
            }
            
            array_sort(_animation_randomize_array, function() { return choose(-1, 1); }); //FIXME - Swap this out for a PRNG
            
            var _glyph_start = __glyph_start;
            var _line = 0;
            repeat(__reveal_count)
            {
                _glyph_grid[# _glyph_start + _line, __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX] = _animation_randomize_array[_line];
                ++_line;
            }
        }
    }
    
    static __submit = function(_double_draw)
    {
        static _u_vTexel              = shader_get_uniform(__shd_scribble, "u_vTexel"             );
        static _u_fSDFRange           = shader_get_uniform(__shd_scribble, "u_fSDFRange"          );
        static _u_fSDFThicknessOffset = shader_get_uniform(__shd_scribble, "u_fSDFThicknessOffset");
        static _u_fSecondDraw         = shader_get_uniform(__shd_scribble, "u_fSecondDraw"        );
        static _u_fRenderType         = shader_get_uniform(__shd_scribble, "u_fRenderType"        );
        
        if (SCRIBBLE_INCREMENTAL_FREEZE && (not __frozen) && (__created_frame < _system.__frames))
        {
            __Freeze();
        }
        
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            var _data = __vertex_buffer_array[_i];
            var _material = _data.__material;
            
            var _bilinear = _material.__bilinear;
            if (_bilinear != undefined)
            {
                var _old_tex_filter = gpu_get_tex_filter();
                gpu_set_tex_filter(_bilinear);
            }
            
            if (_material.__render_type == __SCRIBBLE_RENDER_RASTER)
            {
                shader_set_uniform_f(_u_fRenderType, __SCRIBBLE_RENDER_RASTER);
                vertex_submit(_data.__vertex_buffer, pr_trianglelist, _material.__texture);
            }
            else if (_material.__render_type == __SCRIBBLE_RENDER_SDF)
            {
                //Set shader uniforms unique to the SDF shader
                shader_set_uniform_f(_u_fRenderType, __SCRIBBLE_RENDER_SDF);
                shader_set_uniform_f(_u_vTexel, _material.__texel_width, _material.__texel_height);
                shader_set_uniform_f(_u_fSDFRange, (_material.__sdf_pxrange ?? 0));
                shader_set_uniform_f(_u_fSDFThicknessOffset, _system.__state.__sdf_thickness_offset + (_material.__sdf_thickness_offset ?? 0));
                
                vertex_submit(_data.__vertex_buffer, pr_trianglelist, _material.__texture);
                
                if (_double_draw)
                {
                    shader_set_uniform_f(_u_fSecondDraw, 1);
                    vertex_submit(_data.__vertex_buffer, pr_trianglelist, _material.__texture);
                    shader_set_uniform_f(_u_fSecondDraw, 0);
                }
            }
            else if (_material.__render_type == __SCRIBBLE_RENDER_RASTER_WITH_EFFECTS)
            {
                shader_set_uniform_f(_u_fRenderType, __SCRIBBLE_RENDER_RASTER_WITH_EFFECTS);
                vertex_submit(_data.__vertex_buffer, pr_trianglelist, _material.__texture);
                
                if (_double_draw)
                {
                    shader_set_uniform_f(_u_fSecondDraw, 1);
                    vertex_submit(_data.__vertex_buffer, pr_trianglelist, _material.__texture);
                    shader_set_uniform_f(_u_fSecondDraw, 0);
                }
            }
            
            if (_bilinear != undefined)
            {
                //Reset the texture filtering
                gpu_set_tex_filter(_old_tex_filter);
            }
            
            ++_i;
        }
    }
    
    static __Freeze = function()
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
                vertex_freeze(__vertex_buffer_array[_i].__vertex_buffer);
                ++_i;
            }
            
            __frozen = true;
            
            if (SCRIBBLE_VERBOSE)
            {
                __scribble_trace("Incrementally froze page vertex buffers, time taken = ", (get_timer() - _t)/1000, "ms");
            }
        }
    }
    
    static __get_line_data = function(_index)
    {
        return __line_data_array[clamp(_index, 0, __line_count-1)];
    }
    
    static __get_glyph_data = function(_index)
    {
        //TODO - Static struct return needed here?
        
        if (_index < 0)
        {
            return {
                unicode:  0,
                left:     __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT_LEFT    ],
                top:      __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT_TOP     ],
                right:    __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT_LEFT    ],
                bottom:   __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM  ],
                y_offset: __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT_Y_OFFSET],
            };
        }
        else if (_index >= __glyph_count-1)
        {
            _index = __glyph_count-2;
            
            return {
                unicode:  0,
                left:     __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT_RIGHT   ],
                top:      __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT_TOP     ],
                right:    __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT_RIGHT   ],
                bottom:   __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM  ],
                y_offset: __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT_Y_OFFSET],
            };
        }
        else
        {
            return {
                unicode:  __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT_UNICODE ],
                left:     __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT_LEFT    ],
                top:      __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT_TOP     ],
                right:    __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT_RIGHT   ],
                bottom:   __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM  ],
                y_offset: __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT_Y_OFFSET],
            };
        }
    }
    
    static __get_vertex_buffer = function(_material)
    {
        //TODO - Replace struct-based look-up with a ds_map
        var _data = __texture_to_vertex_buffer_dict[$ _material.__key];
        if (_data != undefined)
        {
            return _data.__vertex_buffer;
        }
        
        //TODO - Move this to `__scribble_system()`
        static _vertex_format = undefined;
        if (_vertex_format == undefined)
        {
            vertex_format_begin();
            vertex_format_add_position_3d();                                  //12 bytes
            vertex_format_add_normal();                                       //12 bytes
            vertex_format_add_colour();                                       // 4 bytes
            vertex_format_add_texcoord();                                     // 8 bytes
            vertex_format_add_custom(vertex_type_float2, vertex_usage_color); // 8 bytes
            _vertex_format = vertex_format_end();                             //44 bytes per vertex, 132 bytes per tri, 264 bytes per glyph
        }
        
        var _vbuff = vertex_create_buffer(); //TODO - Can we preallocate this? i.e. copy "for text" system we had in the old version
        vertex_begin(_vbuff, _vertex_format);
        
        //TODO - Convert this data into just a material reference
        
        var _data = {
            __vertex_buffer: _vbuff,
            __material:      _material,
        };
        
        array_push(__vertex_buffer_array, _data);
        __texture_to_vertex_buffer_dict[$ _material.__key] = _data;
        
        return _vbuff;
    }
    
    static __ensure_glyph_grid = function()
    {
        if (__glyph_grid == undefined)
        {
            __glyph_grid = ds_grid_create(__glyph_count, __SCRIBBLE_GLYPH_LAYOUT_SIZE);
        }
        
        return __glyph_grid;
    }
    
    static __finalize_vertex_buffers = function()
    {
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            var _vbuff = __vertex_buffer_array[_i].__vertex_buffer;
            vertex_end(_vbuff);
            ++_i;
        }
        
        __frozen = false;
    }
    
    static __Flush = function()
    {
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            vertex_delete_buffer(__vertex_buffer_array[_i].__vertex_buffer);
            ++_i;
        }
        
        array_resize(__vertex_buffer_array, 0);
        __texture_to_vertex_buffer_dict = {};
        
        if (__glyph_grid != undefined)
        {
            ds_grid_destroy(__glyph_grid);
            __glyph_grid = undefined;
        }
    }
}
