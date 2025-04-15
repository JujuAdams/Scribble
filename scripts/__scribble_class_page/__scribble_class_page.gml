// Feather disable all
function __scribble_class_page() constructor
{
    static __scribble_state = __scribble_initialize().__state;
    static __gc_vbuff_refs  = __scribble_initialize().__cache_state.__gc_vbuff_refs;
    static __gc_vbuff_ids   = __scribble_initialize().__cache_state.__gc_vbuff_ids;
    static __gc_grid_refs   = __scribble_initialize().__cache_state.__gc_grid_refs;
    static __gc_grid_ids    = __scribble_initialize().__cache_state.__gc_grid_ids;
    
    __text = "";
    __glyph_grid = undefined;
    
    __created_frame = __scribble_state.__frames;
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
    
    __char_events  = {};
    __line_events  = {};
    __region_array = [];
    
    static __submit = function(_double_draw)
    {
        static _u_vTexel              = shader_get_uniform(__shd_scribble, "u_vTexel"             );
        static _u_fSDFRange           = shader_get_uniform(__shd_scribble, "u_fSDFRange"          );
        static _u_fSDFThicknessOffset = shader_get_uniform(__shd_scribble, "u_fSDFThicknessOffset");
        static _u_fSecondDraw         = shader_get_uniform(__shd_scribble, "u_fSecondDraw"        );
        static _u_fRenderType         = shader_get_uniform(__shd_scribble, "u_fRenderType"        );
        
        if (SCRIBBLE_INCREMENTAL_FREEZE && !__frozen && (__created_frame < __scribble_state.__frames)) __freeze();
        
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
                shader_set_uniform_f(_u_fSDFThicknessOffset, __scribble_state.__sdf_thickness_offset + (_material.__sdf_thickness_offset ?? 0));
                
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
    
    static __get_glyph_data = function(_index)
    {
        if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("Cannot get glyph data, SCRIBBLE_ALLOW_GLYPH_DATA_GETTER = <false>\nPlease set SCRIBBLE_ALLOW_GLYPH_DATA_GETTER to <true> to get glyph data");
        
        if (_index < 0)
        {
            return {
                unicode: 0,
                left:    __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__LEFT  ],
                top:     __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__TOP   ],
                right:   __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__LEFT  ],
                bottom:  __glyph_grid[# 0, __SCRIBBLE_GLYPH_LAYOUT.__BOTTOM],
            };
        }
        else
        {
            _index = min(_index, __glyph_count-1);
            
            return {
                unicode: __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE],
                left:    __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__LEFT   ],
                top:     __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__TOP    ],
                right:   __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__RIGHT  ],
                bottom:  __glyph_grid[# _index, __SCRIBBLE_GLYPH_LAYOUT.__BOTTOM ],
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
        
        //TODO - Move this to `__scribble_initialize()`
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
        
        if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Adding vertex buffer ", _vbuff, " to tracking");
        array_push(__gc_vbuff_refs, weak_ref_create(self));
        array_push(__gc_vbuff_ids, _vbuff);
        
        //TODO - Convert this data into just a material reference
        
        var _data = {
            __vertex_buffer: _vbuff,
            __material:      _material,
        };
        
        array_push(__vertex_buffer_array, _data);
        if (!__SCRIBBLE_ON_WEB) __texture_to_vertex_buffer_dict[$ _material.__key] = _data;
        
        return _vbuff;
    }
    
    static __ensure_glyph_grid = function()
    {
        if (__glyph_grid == undefined)
        {
            __glyph_grid = ds_grid_create(__glyph_count, __SCRIBBLE_GLYPH_LAYOUT.__SIZE);
            
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Adding glyph grid ", __glyph_grid, " to tracking");
            array_push(__gc_grid_refs, weak_ref_create(self));
            array_push(__gc_grid_ids, __glyph_grid);
        }
        
        return __glyph_grid;
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
        //Don't forget to update scribble_flush_everything() if you change anything here!
        
        var _i = 0;
        repeat(array_length(__vertex_buffer_array))
        {
            var _vbuff = __vertex_buffer_array[_i].__vertex_buffer;
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
        
        __texture_to_vertex_buffer_dict = {};
        array_resize(__vertex_buffer_array, 0);
        
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
