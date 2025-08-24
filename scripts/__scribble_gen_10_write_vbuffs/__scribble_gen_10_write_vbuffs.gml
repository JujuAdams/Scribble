// Feather disable all
#macro __SCRIBBLE_VBUFF_READ_GLYPH  var _quad_l = _vbuff_pos_grid[# _glyphIndex, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L];\
                                    var _quad_t = _vbuff_pos_grid[# _glyphIndex, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T];\
                                    var _quad_r = _vbuff_pos_grid[# _glyphIndex, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R];\
                                    var _quad_b = _vbuff_pos_grid[# _glyphIndex, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B];\
                                    ;\
                                    var _material = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_MATERIAL];\
                                    var _quad_u0  = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_QUAD_U0];\
                                    var _quad_v0  = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_QUAD_V0];\
                                    var _quad_u1  = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_QUAD_U1];\
                                    var _quad_v1  = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_QUAD_V1];\
                                    ;\
                                    var _half_w = 0.5*_glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_WIDTH ];\
                                    var _half_h = 0.5*_glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_HEIGHT];



#macro __SCRIBBLE_VBUFF_WRITE_GLYPH  if (_material != _material_prev)\ //Swap vertex buffer if the material has changed
                                     {\
                                         _material_prev = _material;\
                                         _vbuff = _page_data.__get_vertex_buffer(_material);\
                                     }\
                                     if (_bezier_do)\
                                     {\
                                         var _quad_cx = _quad_l + _half_w;\
                                         var _quad_cy = _quad_t + _half_h;\
                                         if (_quad_cy > _bezier_prev_cy)\ //If we've snapped back to the LHS then reset our Bezier curve 
                                         {\ //TODO - Maybe use a line number check instead? This could get slow
                                             _bezier_search_index = 0;\
                                             _bezier_search_d0 = 0;\
                                             _bezier_search_d1 = _bezier_lengths[1];\
                                         }\
                                         _bezier_prev_cy = _quad_cy;\
                                         while (true)\ //Iterate forwards until we find a Bezier segment we can fit into
                                         {\
                                             if (_quad_cx <= _bezier_search_d1)\ //If this glyph is on this line segment...
                                             {\
                                                 var _bezier_param = _bezier_param_increment*((_quad_cx - _bezier_search_d0)/ (_bezier_search_d1 - _bezier_search_d0) + _bezier_search_index);\ //...then parameterise this glyph
                                                 break;\
                                             }\
                                             _bezier_search_index++;\
                                             if (_bezier_search_index >= SCRIBBLE_BEZIER_ACCURACY-1)\
                                             {\
                                                 var _bezier_param = 1.0;\ //We've hit the end of the Bezier curve, force all the remaining glyphs to stack up at the end of the line
                                                 break;\
                                             }\
                                             _bezier_search_d0 = _bezier_search_d1;\ //Advance to the next line segment
                                             _bezier_search_d1 = _bezier_lengths[_bezier_search_index+1];\
                                         }\
                                         _quad_l = _bezier_param;\
                                         _quad_r = _bezier_param;\
                                         _quad_t = _quad_cy;\
                                         _quad_b = _quad_cy;\
                                     }\
                                     ;\
                                     vertex_position_3d(_vbuff, _quad_l, _quad_t, _animation_index); vertex_normal(_vbuff, _reveal_index, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff,  _half_w,  _half_h);\
                                     vertex_position_3d(_vbuff, _quad_r, _quad_b, _animation_index); vertex_normal(_vbuff, _reveal_index, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, -_half_w, -_half_h);\
                                     vertex_position_3d(_vbuff, _quad_l, _quad_b, _animation_index); vertex_normal(_vbuff, _reveal_index, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v1); vertex_float2(_vbuff,  _half_w, -_half_h);\
                                     vertex_position_3d(_vbuff, _quad_r, _quad_b, _animation_index); vertex_normal(_vbuff, _reveal_index, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, -_half_w, -_half_h);\
                                     vertex_position_3d(_vbuff, _quad_l, _quad_t, _animation_index); vertex_normal(_vbuff, _reveal_index, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff,  _half_w,  _half_h);\
                                     vertex_position_3d(_vbuff, _quad_r, _quad_t, _animation_index); vertex_normal(_vbuff, _reveal_index, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v0); vertex_float2(_vbuff, -_half_w,  _half_h);



function __scribble_gen_10_write_vbuffs()
{
    static _string_buffer   = __scribble_system().__buffer_a;
    static _effects_map     = __scribble_system().__effects_map;
    static _generator_state = __scribble_system().__generator_state;
    
    static _scribbleDotUVs = sprite_get_uvs(__scribble_dot, 0);
    static _scribbleDotMaterial = __scribble_sprite_get_material(__scribble_dot, 0);
    
    with(_generator_state)
    {
        var _vbuff_pos_grid    = __vbuff_pos_grid;
        var _control_grid      = __control_grid;
        var _glyph_grid        = __glyph_grid;
        var _word_grid         = __word_grid;
        var _line_grid         = __line_grid;
        var _element           = __element;
        var _glyph_count       = __glyph_count;
        var _text_getter       = __element.__allow_text_getter;
        var _glyph_data_getter = __element.__allow_glyph_data_getter;
    }
    
    
    
    //Copy the x/y offset into the quad LTRB
    ds_grid_set_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH_X, _glyph_count-1, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L);
    ds_grid_set_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH_X, _glyph_count-1, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
    
    //Then add the deltas to give us the final quad LTRB positions
    //Note that the delta are already scaled via font scale / scaling tags etc
    ds_grid_add_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH_WIDTH,   _glyph_count-1, __SCRIBBLE_GEN_GLYPH_WIDTH,   0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
    ds_grid_add_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH_HEIGHT,  _glyph_count-1, __SCRIBBLE_GEN_GLYPH_HEIGHT,  0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B);
    
    
    
    if (is_array(_generator_state.__bezier_lengths_array))
    {
        //Prep for Bezier curve shenanigans if necessary
        var _bezier_do              = true;
        var _bezier_lengths         = _generator_state.__bezier_lengths_array;
        var _bezier_search_index    = 0;
        var _bezier_search_d0       = 0;
        var _bezier_search_d1       = _bezier_lengths[1];
        var _bezier_prev_cy         = -infinity;
        var _bezier_param_increment = 1 / (SCRIBBLE_BEZIER_ACCURACY-1);
    }
    else
    {
        _bezier_do = false;
    }
    
    var _glyph_colour       = 0xFFFFFFFF;
    var _glyph_cycle        = 0x00000000;
    var _glyph_effect_flags = 0;
    var _glyph_sprite_data  = 0;
    var _write_colour       = 0xFFFFFFFF;
    
    var _control_index = 0;
    var _region_name   = undefined;
    var _region_start  = undefined;
    
    var _underline = 0;
    var _strike    = 0;
    
    var _fontUnderlineY = 0;
    var _fontStrikeY    = 0;
    
    var _func_region_pop = function(_page_data, _region_name, _region_start, _region_end)
    {
        static _generator_state = __scribble_system().__generator_state;
        
        if (_region_start > _region_end) return;
        
        var _region_bbox_array = [];
        
        var _vbuff_pos_grid = _generator_state.__vbuff_pos_grid;
        var _line_grid      = _generator_state.__line_grid;
        var _word_grid      = _generator_state.__word_grid;
        
        var _line = 0;
        var _region_bbox_start = _region_start;
        var _region_bbox_end   = _region_start-1;
        
        while(_region_end >= _region_bbox_start)
        {
            _region_bbox_end = min(_region_end, _word_grid[# _line_grid[# _line, __SCRIBBLE_GEN_LINE_WORD_END], __SCRIBBLE_GEN_WORD_GLYPH_END]);
            
            if (_region_bbox_start <= _region_bbox_end)
            {
                //Push a bounding box to the region
                //N.B. This array is exposed to the end-user via .region_get_bboxes()
                array_push(_region_bbox_array, {
                    x1 : ds_grid_get_min(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L, _region_bbox_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L),
                    y1 : ds_grid_get_min(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T, _region_bbox_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T),
                    x2 : ds_grid_get_max(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R, _region_bbox_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R),
                    y2 : ds_grid_get_max(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B, _region_bbox_end, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B),
                });
                
                _region_bbox_start = _region_bbox_end + 1;
            }
            
            ++_line;
        }
        
        //N.B. This array is exposed to the end-user via .region_get_bboxes()
        array_push(_page_data.__region_array, {
            name        : _region_name,
            bbox_array  : _region_bbox_array,
            start_glyph : _region_start - _page_data.__glyph_start,
            end_glyph   : _region_end - _page_data.__glyph_start,
        });
    }
    
    var _pageIndex = 0;
    repeat(__pages)
    {
        var _page_data        = __pages_array[_pageIndex];
        var _page_events_dict = _page_data.__events_dict;
        var _vbuff            = undefined;
        var _material_prev    = undefined;
        var _animation_index  = 0;
        var _reveal_index     = 0;
        
        if (_glyph_data_getter)
        {
            with(_page_data)
            {
                __ensure_glyph_grid();
                ds_grid_set_grid_region(__glyph_grid, _glyph_grid, __glyph_start, __SCRIBBLE_GEN_GLYPH_UNICODE, __glyph_end, __SCRIBBLE_GEN_GLYPH_UNICODE, 0, __SCRIBBLE_GLYPH_LAYOUT_UNICODE);
                ds_grid_set_grid_region(__glyph_grid, _glyph_grid, __glyph_start, __SCRIBBLE_GEN_GLYPH_Y, __glyph_end, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GLYPH_LAYOUT_Y_OFFSET);
                ds_grid_set_grid_region(__glyph_grid, _vbuff_pos_grid, __glyph_start, 0, __glyph_end, __SCRIBBLE_GEN_VBUFF_POS_SIZE-1, 0, __SCRIBBLE_GLYPH_LAYOUT_LEFT);
            }
        }
        
        if (_text_getter)
        {
            buffer_seek(_string_buffer, buffer_seek_start, 0);
        }
        
        var _lineIndex = _page_data.__line_start;
        repeat(_page_data.__line_count)
        {
            var _lineY = _line_grid[# _lineIndex, __SCRIBBLE_GEN_LINE_Y];
            
            var _glyphStart = _word_grid[# _line_grid[# _lineIndex, __SCRIBBLE_GEN_LINE_WORD_START], __SCRIBBLE_GEN_WORD_GLYPH_START];
            var _glyphEnd   = _word_grid[# _line_grid[# _lineIndex, __SCRIBBLE_GEN_LINE_WORD_END  ], __SCRIBBLE_GEN_WORD_GLYPH_END  ];
            
            var _glyphIndex = _glyphStart;
            repeat(1 + _glyphEnd - _glyphStart)
            {
                var _animation_index = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX];
                var _reveal_index    = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX   ];
                
                #region Read controls
                
                var _control_delta = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] - _control_index;
                repeat(_control_delta)
                {
                    switch(_control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL_TYPE])
                    {
                        case __SCRIBBLE_GEN_CONTROL_TYPE_COLOUR:
                            _glyph_colour = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL_DATA];
                            var _write_colour = (__SCRIBBLE_FIX_ARGB? __scribble_rgb_to_bgr(_glyph_colour) : _glyph_colour); //Fix for bug in vertex_argb() on OpenGL targets (2021-11-24  runtime 2.3.5.458)
                        break;
                        
                        case __SCRIBBLE_GEN_CONTROL_TYPE_EFFECT:
                            _glyph_effect_flags = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL_DATA];
                        break;
                        
                        case __SCRIBBLE_GEN_CONTROL_TYPE_CYCLE:
                            _glyph_cycle = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL_DATA];
                            
                            if (_glyph_cycle == -1)
                            {
                                _write_colour = (__SCRIBBLE_FIX_ARGB? __scribble_rgb_to_bgr(_glyph_colour) : _glyph_colour); //Fix for bug in vertex_argb() on OpenGL targets (2021-11-24  runtime 2.3.5.458)
                            }
                            else
                            {
                                _write_colour = (__SCRIBBLE_FIX_ARGB? __scribble_rgb_to_bgr(_glyph_cycle) : _glyph_cycle); //Fix for bug in vertex_argb() on OpenGL targets (2021-11-24  runtime 2.3.5.458)
                            }
                        break;
                        
                        case __SCRIBBLE_GEN_CONTROL_TYPE_EVENT:
                            //FIXME - Add character index (and line index if possible)
                            var _event = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL_DATA];
                            _event.reveal_index = _reveal_index;
                            
                            var _event_array = _page_events_dict[$ _reveal_index]; //Find the correct event array in the dictionary, creating a new one if needed
                            
                            if (!is_array(_event_array))
                            {
                                var _event_array = [];
                                _page_events_dict[$ _reveal_index] = _event_array;
                            }
                            
                            array_push(_event_array, _event);
                        break;
                        
                        case __SCRIBBLE_GEN_CONTROL_TYPE_REGION:
                            if (_region_name != undefined)
                            {
                                _func_region_pop(_page_data, _region_name, _region_start, _glyphIndex-1);
                            }
                            
                            // [/region] just sets the .DATA field to undefined
                            _region_name  = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL_DATA];
                            _region_start = _glyphIndex;
                        break;
                        
                        case __SCRIBBLE_GEN_CONTROL_TYPE_FONT:
                            var _fontData = __scribble_get_font_data(_control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL_DATA]);
                            var _fontUnderlineY = floor(_fontData.__underlineY);
                            var _fontStrikeY    = floor(_fontData.__strikeY);
                        break;
                        
                        case __SCRIBBLE_GEN_CONTROL_TYPE_UNDERLINE:
                            _underline = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL_DATA];
                        break;
                        
                        case __SCRIBBLE_GEN_CONTROL_TYPE_STRIKE:
                            _strike = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL_DATA];
                        break;
                    }
                    
                    _control_index++;
                }
                
                #endregion
                
                var _glyph_ord = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_UNICODE];
                if (_glyph_ord >= 0)
                {
                    if (_text_getter)
                    {
                        __scribble_buffer_write_unicode(_string_buffer, _glyph_ord);
                    }
                    
                    if ((_glyph_ord > 0x20) && (_glyph_ord != 0xA0) && (_glyph_ord != 0x200B))
                    {
                        __SCRIBBLE_VBUFF_READ_GLYPH;
                        __SCRIBBLE_VBUFF_WRITE_GLYPH;
                    }
                }
                else if (_glyph_ord == __SCRIBBLE_GLYPH_REPL_SPRITE)
                {
                    #region Write sprite
                    
                    if (_text_getter)
                    {
                        buffer_write(_string_buffer, buffer_u8, 0x1A); //Unicode/ASCII "substitute character"
                    }
                    
                    var _glyph_x         = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_X           ];
                    var _glyph_y         = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_Y           ];
                    var _glyph_width     = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_WIDTH       ];
                    var _glyph_height    = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_HEIGHT      ];
                    var _sprite_index    = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_SPRITE_INDEX];
                    var _image_index     = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_IMAGE_INDEX ];
                    var _image_speed     = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_IMAGE_SPEED ];
                    var _sprite_once     = _glyph_grid[# _glyphIndex, __SCRIBBLE_GEN_GLYPH_SPRITE_ONCE ];
                    
                    var _glyph_xscale = sprite_get_width( _sprite_index) / _glyph_width;
                    var _glyph_yscale = sprite_get_height(_sprite_index) / _glyph_height;
                    
                    var _old_glyph_effect_flags = _glyph_effect_flags;
                    
                    if (!SCRIBBLE_COLORIZE_SPRITES)
                    {
                        var _old_write_colour = _write_colour;
                        _write_colour = _glyph_colour | 0xFFFFFF; //Make sure we use the general glyph alpha
                        
                        _glyph_effect_flags = ~_glyph_effect_flags;
                        _glyph_effect_flags |= (1 << _effects_map[? "rainbow"]);
                        _glyph_effect_flags |= (1 << _effects_map[? "cycle"  ]);
                        _glyph_effect_flags = ~_glyph_effect_flags;
                    }
                    
                    if (_image_speed > 0) _glyph_effect_flags |= 0x01; //Set the sprite flag bit
                    
                    if (SCRIBBLE_ADD_SPRITE_ORIGINS)
                    {
                        _glyph_x += (_glyph_width  div 2) - _glyph_xscale*sprite_get_xoffset(_sprite_index);
                        _glyph_y += (_glyph_height div 2) - _glyph_yscale*sprite_get_yoffset(_sprite_index);
                    }
                    
                    var _sprite_number = sprite_get_number(_sprite_index);
                    if (_sprite_number > 127)
                    {
                        __scribble_trace("In-line sprites cannot have more than 127 frames (", sprite_get_name(_sprite_index), ")");
                        _sprite_number = 127;
                    }
                    
                    if (_image_speed >= 2)
                    {
                        __scribble_trace("Image speed cannot be more than 2.0 (" + string(_image_speed) + ")");
                        _image_speed = 2;
                    }
                    
                    if (_image_speed < 0)
                    {
                        __scribble_trace("Image speed cannot be less than 0.0 (" + string(_image_speed) + ")");
                        _image_speed = 0;
                    }
                    
                    var _glyph_sprite_data = 16384*floor(256*_image_speed) + 128*_sprite_number + _image_index;
                    
                    if (_sprite_once)
                    {
                        _glyph_sprite_data *= -1;
                        var _increment = -1;
                    }
                    else
                    {
                        var _increment = 1;
                    }
                    
                    var _j = _image_index;
                    repeat((_image_speed > 0)? _sprite_number : 1) //Only draw one image if we have an image speed of 0 since we're not animating
                    {
                        var _material = __scribble_sprite_get_material(_sprite_index, _j);
                        
                        var _uvs = sprite_get_uvs(_sprite_index, _j);
                        var _quad_u0 = _uvs[0];
                        var _quad_v0 = _uvs[1];
                        var _quad_u1 = _uvs[2];
                        var _quad_v1 = _uvs[3];
                        
                        var _quad_l = floor(_glyph_x + _uvs[4]/_glyph_xscale);
                        var _quad_t = floor(_glyph_y + _uvs[5]/_glyph_yscale);
                        var _quad_r = _quad_l + _uvs[6]*_glyph_width;
                        var _quad_b = _quad_t + _uvs[7]*_glyph_height;
                        
                        var _half_w = 0.5*(_quad_r - _quad_l);
                        var _half_h = 0.5*(_quad_b - _quad_t);
                        
                        __SCRIBBLE_VBUFF_WRITE_GLYPH;
                        
                        ++_j;
                        _glyph_sprite_data += _increment;
                    }
                    
                    if (!SCRIBBLE_COLORIZE_SPRITES) _write_colour = _old_write_colour;
                    _glyph_effect_flags = _old_glyph_effect_flags;
                    _glyph_sprite_data = 0; //Reset this because every other type of glyph doesn't use this
                    
                    #endregion
                }
                else if ((_glyph_ord == __SCRIBBLE_GLYPH_REPL_SURFACE) || (_glyph_ord == __SCRIBBLE_GLYPH_REPL_TEXTURE))
                {
                    #region Write surface or texture
                    
                    if (_text_getter)
                    {
                        buffer_write(_string_buffer, buffer_u8, 0x1A); //Unicode/ASCII "substitute character"
                    }
                    
                    __SCRIBBLE_VBUFF_READ_GLYPH;
                    
                    if (!SCRIBBLE_COLORIZE_SPRITES)
                    {
                        var _old_write_colour       = _write_colour;
                        var _old_glyph_effect_flags = _glyph_effect_flags;
                        
                        _write_colour = _write_colour | 0xFFFFFF;
                        
                        _glyph_effect_flags = ~_glyph_effect_flags;
                        _glyph_effect_flags |= (1 << _effects_map[? "cycle"]);
                        _glyph_effect_flags = ~_glyph_effect_flags;
                    }
                    
                    __SCRIBBLE_VBUFF_WRITE_GLYPH;
                    
                    if (!SCRIBBLE_COLORIZE_SPRITES)
                    {
                        _write_colour       = _old_write_colour;
                        _glyph_effect_flags = _old_glyph_effect_flags;
                    }
                    
                    #endregion
                }
                
                if (_glyphIndex < _glyphEnd)
                {
                    //TODO - Optimise
                    
                    if (_strike > 0)
                    {
                        var _quad_l = _vbuff_pos_grid[# _glyphIndex,   __SCRIBBLE_GEN_VBUFF_POS_QUAD_L];
                        var _quad_t = _lineY + _fontStrikeY - ceil(0.5*_strike);
                        var _quad_r = _vbuff_pos_grid[# _glyphIndex+1, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L];
                        var _quad_b = _quad_t + _strike;
                        
                        var _material = _scribbleDotMaterial;
                        var _quad_u0  = _scribbleDotUVs[0];
                        var _quad_v0  = _scribbleDotUVs[1];
                        var _quad_u1  = _scribbleDotUVs[2];
                        var _quad_v1  = _scribbleDotUVs[3];
                        
                        var _half_w = 0.5*(1 + _quad_r - _quad_l);
                        var _half_h = 0.5*_strike;
                        
                        __SCRIBBLE_VBUFF_WRITE_GLYPH
                    }
                    
                    if (_underline > 0)
                    {
                        var _quad_l = _vbuff_pos_grid[# _glyphIndex,   __SCRIBBLE_GEN_VBUFF_POS_QUAD_L];
                        var _quad_t = _lineY + _fontUnderlineY + 1;
                        var _quad_r = _vbuff_pos_grid[# _glyphIndex+1, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L];
                        var _quad_b = _quad_t + _underline;
                        
                        var _material = _scribbleDotMaterial;
                        var _quad_u0  = _scribbleDotUVs[0];
                        var _quad_v0  = _scribbleDotUVs[1];
                        var _quad_u1  = _scribbleDotUVs[2];
                        var _quad_v1  = _scribbleDotUVs[3];
                        
                        var _half_w = 0.5*(1 + _quad_r - _quad_l);
                        var _half_h = 0.5*_underline;
                        
                        __SCRIBBLE_VBUFF_WRITE_GLYPH
                    }
                }
                
                ++_glyphIndex;
            }
            
            ++_lineIndex;
        }
        
        //If we have a hanging glyph in an open region then ensure we pop it onto the page we're leaving
        if (_region_name != undefined)
        {
            _func_region_pop(_page_data, _region_name, _region_start, _glyphIndex-1);
            
            //Set up so that we still have a region open on the next page
            _region_start = _glyphIndex;
        }
        
        if (_text_getter)
        {
            //Write a null terminator to finish off the string
            buffer_write(_string_buffer, buffer_u8, 0);
            buffer_seek(_string_buffer, buffer_seek_start, 0);
            _page_data.__text = buffer_read(_string_buffer, buffer_string);
        }
        
        ++_pageIndex;
    }
    
    //Sweep up any remaining events
    var _control_delta = _glyph_grid[# _glyphIndex-1, __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT] - _control_index;
    repeat(_control_delta)
    {
        if (_control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL_TYPE] == __SCRIBBLE_GEN_CONTROL_TYPE_EVENT)
        {
            //FIXME - Add character index (and line index if possible)
            var _event = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL_DATA];
            _event.reveal_index = _reveal_index;
            
            
            
            var _event_array = _page_events_dict[$ _reveal_index]; //Find the correct event array in the diciontary, creating a new one if needed
            
            if (!is_array(_event_array))
            {
                var _event_array = [];
                _page_events_dict[$ _reveal_index] = _event_array;
            }
            
            array_push(_event_array, _event);
        }
                
        _control_index++;
    }
    
    //Ensure we've ended the vertex buffers we created
    __finalize_vertex_buffers(_element.__freeze);
}
