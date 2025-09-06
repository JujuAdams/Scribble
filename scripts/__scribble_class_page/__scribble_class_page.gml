// Feather disable all

function __scribble_class_page() constructor
{
    static __system            = __scribble_system();
    static __glyphVertexFormat = __system.__glyphVertexFormat;
    static __scribble_state    = __system.__state;
    static __gc_vbuff_refs     = __system.__cache_state.__gc_vbuff_refs;
    static __gc_vbuff_ids      = __system.__cache_state.__gc_vbuff_ids;
    static __gc_grid_refs      = __system.__cache_state.__gc_grid_refs;
    static __gc_grid_ids       = __system.__cache_state.__gc_grid_ids;
    
    __text = "";
    __glyph_grid = undefined;
    
    __created_frame = __scribble_state.__frames;
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
    
    __vertexBufferArray = [];
    __textureToVertexBufferDict = {};
    
    __events_dict  = {};
    __region_array = [];
    
    static __submit = function(_double_draw)
    {
        static _u_vTexel              = shader_get_uniform(__shd_scribble, "u_vTexel"             );
        static _u_fSDFRange           = shader_get_uniform(__shd_scribble, "u_fSDFRange"          );
        static _u_fSDFThicknessOffset = shader_get_uniform(__shd_scribble, "u_fSDFThicknessOffset");
        static _u_fSecondDraw         = shader_get_uniform(__shd_scribble, "u_fSecondDraw"        );
        static _u_fRenderType         = shader_get_uniform(__shd_scribble, "u_fRenderType"        );
        
        if (SCRIBBLE_INCREMENTAL_FREEZE && !__frozen && (__created_frame < __scribble_state.__frames)) __Freeze();
        
        var _i = 0;
        repeat(array_length(__vertexBufferArray))
        {
            var _data = __vertexBufferArray[_i];
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
                vertex_submit(_data.__vertexBuffer, pr_trianglelist, _material.__texture);
            }
            else if (_material.__render_type == __SCRIBBLE_RENDER_SDF)
            {
                //Set shader uniforms unique to the SDF shader
                shader_set_uniform_f(_u_fRenderType, __SCRIBBLE_RENDER_SDF);
                shader_set_uniform_f(_u_vTexel, _material.__texel_width, _material.__texel_height);
                shader_set_uniform_f(_u_fSDFRange, (_material.__sdf_pxrange ?? 0));
                shader_set_uniform_f(_u_fSDFThicknessOffset, __scribble_state.__sdf_thickness_offset + (_material.__sdf_thickness_offset ?? 0));
                
                vertex_submit(_data.__vertexBuffer, pr_trianglelist, _material.__texture);
                
                if (_double_draw)
                {
                    shader_set_uniform_f(_u_fSecondDraw, 1);
                    vertex_submit(_data.__vertexBuffer, pr_trianglelist, _material.__texture);
                    shader_set_uniform_f(_u_fSecondDraw, 0);
                }
            }
            else if (_material.__render_type == __SCRIBBLE_RENDER_RASTER_WITH_EFFECTS)
            {
                shader_set_uniform_f(_u_fRenderType, __SCRIBBLE_RENDER_RASTER_WITH_EFFECTS);
                vertex_submit(_data.__vertexBuffer, pr_trianglelist, _material.__texture);
                
                if (_double_draw)
                {
                    shader_set_uniform_f(_u_fSecondDraw, 1);
                    vertex_submit(_data.__vertexBuffer, pr_trianglelist, _material.__texture);
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
            repeat(array_length(__vertexBufferArray))
            {
                vertex_freeze(__vertexBufferArray[_i].__vertexBuffer);
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
    
    static __GetVertexBufferStruct = function(_material)
    {
        //TODO - Replace struct-based look-up with a ds_map
        var _data = __textureToVertexBufferDict[$ _material.__key];
        if (_data != undefined)
        {
            return _data.__buildBuffer;
        }
        
        //FIXME - Reuse this buffer instead of creating and destroying
        var _buffer = buffer_create(1000*6*__SCRIBBLE_STRIDE_BUILD, buffer_grow, 1);
        
        var _data = {
            __vertexBuffer:      undefined,
            __buildBuffer:       _buffer,
            __buildBufferOffset: 0,
            __material:          _material,
        };
        
        array_push(__vertexBufferArray, _data);
        __textureToVertexBufferDict[$ _material.__key] = _data;
        
        return _data;
    }
    
    static __EnsureGlyphGrid = function()
    {
        if (__glyph_grid == undefined)
        {
            __glyph_grid = ds_grid_create(__glyph_count, __SCRIBBLE_GLYPH_LAYOUT_SIZE);
            
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Adding glyph grid ", __glyph_grid, " to tracking");
            array_push(__gc_grid_refs, weak_ref_create(self));
            array_push(__gc_grid_ids, __glyph_grid);
        }
        
        return __glyph_grid;
    }
    
    static __FinalizeVertexBuffers = function()
    {
        var _glyphVertexFormat = __glyphVertexFormat;
        var _gc_vbuff_refs     = __gc_vbuff_refs;
        var _gc_vbuff_ids      = __gc_vbuff_ids;
        
        var _i = 0;
        repeat(array_length(__vertexBufferArray))
        {
            with(__vertexBufferArray[_i])
            {
                __vertexBuffer = vertex_create_buffer_from_buffer_ext(__buildBuffer, _glyphVertexFormat, 0, __buildBufferOffset / __SCRIBBLE_STRIDE_BUILD);
                
                if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Adding vertex buffer ", __vertexBuffer, " to tracking");
                array_push(_gc_vbuff_refs, weak_ref_create(self));
                array_push(_gc_vbuff_ids, __vertexBuffer);
                
                buffer_delete(__buildBuffer);
                __buildBuffer = undefined;
            }
            
            ++_i;
        }
        
        __frozen = false;
    }
    
    static __flush = function()
    {
        //Don't forget to update scribble_flush_everything() if you change anything here!
        
        var _i = 0;
        repeat(array_length(__vertexBufferArray))
        {
            var _vbuff = __vertexBufferArray[_i].__vertexBuffer;
            vertex_delete_buffer(_vbuff);
            
            var _index = __scribble_array_find_index(__gc_vbuff_ids, _vbuff);
            if (_index >= 0)
            {
                if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Manually removing vertex buffer ", _vbuff, " from tracking");
                array_delete(__gc_vbuff_refs, _index, 1);
                array_delete(__gc_vbuff_ids,  _index, 1);
            }
            
            ++_i;
        }
        
        __textureToVertexBufferDict = {};
        array_resize(__vertexBufferArray, 0);
        
        if (__glyph_grid != undefined)
        {
            var _index = __scribble_array_find_index(__gc_grid_ids, __glyph_grid);
            if (_index >= 0)
            {
                if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Manually removing glyph grid ", __glyph_grid, " from tracking");
                array_delete(__gc_grid_refs, _index, 1);
                array_delete(__gc_grid_ids,  _index, 1);
            }
            
            ds_grid_destroy(__glyph_grid);
            __glyph_grid = undefined;
        }
    }
}
