// Feather disable all
#macro __SCRIBBLE_VBUFF_READ_GLYPH  var _quad_l = _vbuff_pos_grid[# _i, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_L];\
                                    var _quad_t = _vbuff_pos_grid[# _i, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_T];\
                                    var _quad_r = _vbuff_pos_grid[# _i, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_R];\
                                    var _quad_b = _vbuff_pos_grid[# _i, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_B];\
                                    ;\
                                    var _glyph_texture = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__TEXTURE];\
                                    var _quad_u0       = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__QUAD_U0];\
                                    var _quad_v0       = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__QUAD_V0];\
                                    var _quad_u1       = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__QUAD_U1];\
                                    var _quad_v1       = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__QUAD_V1];\
                                    ;\
                                    var _half_w = 0.5*_glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__WIDTH ];\
                                    var _half_h = 0.5*_glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__HEIGHT];



#macro __SCRIBBLE_VBUFF_WRITE_GLYPH  if (_glyph_texture != _last_glyph_texture)\
                                     {\
                                         _last_glyph_texture = _glyph_texture;\
                                         _vbuff = _page_data.__get_vertex_buffer(_glyph_texture, _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__FONT_NAME]);\
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
                                     vertex_position_3d(_vbuff, _quad_l, _quad_t, _packed_indexes); vertex_normal(_vbuff, 0, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff,  _half_w,  _half_h);\
                                     vertex_position_3d(_vbuff, _quad_r, _quad_b, _packed_indexes); vertex_normal(_vbuff, 0, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, -_half_w, -_half_h);\
                                     vertex_position_3d(_vbuff, _quad_l, _quad_b, _packed_indexes); vertex_normal(_vbuff, 0, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v1); vertex_float2(_vbuff,  _half_w, -_half_h);\
                                     vertex_position_3d(_vbuff, _quad_r, _quad_b, _packed_indexes); vertex_normal(_vbuff, 0, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, -_half_w, -_half_h);\
                                     vertex_position_3d(_vbuff, _quad_l, _quad_t, _packed_indexes); vertex_normal(_vbuff, 0, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff,  _half_w,  _half_h);\
                                     vertex_position_3d(_vbuff, _quad_r, _quad_t, _packed_indexes); vertex_normal(_vbuff, 0, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v0); vertex_float2(_vbuff, -_half_w,  _half_h);



function __scribble_gen_9_write_vbuffs()
{
    static _string_buffer   = __scribble_initialize().__buffer_a;
    static _effects_map     = __scribble_initialize().__effects_map;
    static _generator_state = __scribble_initialize().__generator_state;
    
    with(_generator_state)
    {
        var _glyph_grid     = __glyph_grid;
        var _control_grid   = __control_grid;
        var _vbuff_pos_grid = __vbuff_pos_grid;
        var _element        = __element;
        var _glyph_count    = __glyph_count;
    }
    
    
    
    //Copy the x/y offset into the quad LTRB
    ds_grid_set_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH.__X, _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__Y, 0, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_L);
    ds_grid_set_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH.__X, _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__Y, 0, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_R);
    
    //Then add the deltas to give us the final quad LTRB positions
    //Note that the delta are already scaled via font scale / scaling tags etc
    ds_grid_add_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH.__WIDTH,   _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__WIDTH,   0, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_R);
    ds_grid_add_grid_region(_vbuff_pos_grid, _glyph_grid, 0, __SCRIBBLE_GEN_GLYPH.__HEIGHT,  _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__HEIGHT,  0, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_B);
    
    
    
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
    
    var _control_index     = 0;
    var _region_name       = undefined;
    var _region_start      = undefined;
    var _region_bbox_start = undefined;
    var _region_bbox_array = undefined;
    
    var _p = 0;
    repeat(__pages)
    {
        var _page_data             = __pages_array[_p];
        var _page_char_events_dict = _page_data.__char_events;
        var _page_line_events_dict = _page_data.__line_events;
        var _vbuff                 = undefined;
        var _last_glyph_texture    = undefined;
        var _packed_indexes        = 0;
        
        if (SCRIBBLE_ALLOW_TEXT_GETTER)
        {
            buffer_seek(_string_buffer, buffer_seek_start, 0);
        }
        
        if (SCRIBBLE_ALLOW_GLYPH_DATA_GETTER)
        {
            with(_page_data)
            {
                __glyph_grid = ds_grid_create(__glyph_count, __SCRIBBLE_GLYPH_LAYOUT.__SIZE);
                ds_grid_set_grid_region(__glyph_grid, _glyph_grid, __glyph_start, __SCRIBBLE_GEN_GLYPH.__UNICODE, __glyph_end, __SCRIBBLE_GEN_GLYPH.__UNICODE, 0, __SCRIBBLE_GLYPH_LAYOUT.__UNICODE);
                ds_grid_set_grid_region(__glyph_grid, _vbuff_pos_grid, __glyph_start, 0, __glyph_end, __SCRIBBLE_GEN_VBUFF_POS.__SIZE-1, 0, __SCRIBBLE_GLYPH_LAYOUT.__LEFT);
            }
        }
        
        var _i = _page_data.__glyph_start;
        repeat(_page_data.__glyph_count)
        {
            var _packed_indexes = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX];
            
            #region Read controls
            
            var _control_delta = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] - _control_index;
            repeat(_control_delta)
            {
                switch(_control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__TYPE])
                {
                    case __SCRIBBLE_GEN_CONTROL_TYPE.__COLOUR:
                        _glyph_colour = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__DATA];
                        var _write_colour = (__SCRIBBLE_FIX_ARGB? scribble_rgb_to_bgr(_glyph_colour) : _glyph_colour); //Fix for bug in vertex_argb() on OpenGL targets (2021-11-24  runtime 2.3.5.458)
                    break;
                    
                    case __SCRIBBLE_GEN_CONTROL_TYPE.__EFFECT:
                        _glyph_effect_flags = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__DATA];
                    break;
                    
                    case __SCRIBBLE_GEN_CONTROL_TYPE.__CYCLE:
                        _glyph_cycle = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__DATA];
                        
                        if (_glyph_cycle == undefined)
                        {
                            _write_colour = (__SCRIBBLE_FIX_ARGB? scribble_rgb_to_bgr(_glyph_colour) : _glyph_colour); //Fix for bug in vertex_argb() on OpenGL targets (2021-11-24  runtime 2.3.5.458)
                        }
                        else
                        {
                            _write_colour = (__SCRIBBLE_FIX_ARGB? scribble_rgb_to_bgr(_glyph_cycle) : _glyph_cycle); //Fix for bug in vertex_argb() on OpenGL targets (2021-11-24  runtime 2.3.5.458)
                        }
                    break;
                    
                    case __SCRIBBLE_GEN_CONTROL_TYPE.__EVENT:
                        var _character_index =  _packed_indexes div __SCRIBBLE_MAX_LINES;
                        var _line_index      = (_packed_indexes mod __SCRIBBLE_MAX_LINES) + ((_character_index > 0)? 1 : 0);
                        
                        var _event = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__DATA];
                        _event.position        = _character_index; //Legacy
                        _event.character_index = _character_index;
                        _event.line_index      = _line_index;
                        
                        
                        
                        var _event_array = _page_char_events_dict[$ _character_index]; //Find the correct event array in the dictionary, creating a new one if needed
                        
                        if (!is_array(_event_array))
                        {
                            var _event_array = [];
                            _page_char_events_dict[$ _character_index] = _event_array;
                        }
                        
                        array_push(_event_array, _event);
                        
                        
                        
                        var _event_array = _page_line_events_dict[$ _line_index]; //Find the correct event array in the dictionary, creating a new one if needed
                        if (!is_array(_event_array))
                        {
                            var _event_array = [];
                            _page_line_events_dict[$ _line_index] = _event_array;
                        }
                        
                        array_push(_event_array, _event);
                    break;
                    
                    case __SCRIBBLE_GEN_CONTROL_TYPE.__REGION:
                        if (_region_name != undefined)
                        {
                            var _region_end = _i - 1;
                            if (_region_start <= _region_end)
                            {
                                //Push a bounding box to the region
                                //N.B. This array is exposed to the end-user via .region_get_bboxes()
                                array_push(_region_bbox_array, {
                                    x1 : ds_grid_get_min(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_L, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_L),
                                    y1 : ds_grid_get_min(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_T, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_T),
                                    x2 : ds_grid_get_max(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_R, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_R),
                                    y2 : ds_grid_get_max(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_B, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_B),
                                });
                                
                                //Only store a region that actually covers a glyph
                                //N.B. This array is exposed to the end-user via .region_get_bboxes()
                                array_push(_page_data.__region_array, {
                                    name        : _region_name,
                                    bbox_array  : _region_bbox_array,
                                    start_glyph : _region_start - _page_data.__glyph_start,
                                    end_glyph   : _region_end - _page_data.__glyph_start,
                                });
                            }
                        }
                        
                        // [/region] just sets the .DATA field to undefined
                        _region_name       = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__DATA];
                        _region_start      = _i;
                        _region_bbox_start = _i;
                        _region_bbox_array = [];
                    break;
                    
                    case __SCRIBBLE_GEN_CONTROL_TYPE.__FONT:
                        //Do nothing
                    break;
                }
                
                _control_index++;
            }
            
            #endregion
            
            var _glyph_ord = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE];
            if (_glyph_ord == __SCRIBBLE_GLYPH_SPRITE)
            {
                #region Write sprite
                
                if (SCRIBBLE_ALLOW_TEXT_GETTER)
                {
                    buffer_write(_string_buffer, buffer_u8, 0x1A); //Unicode/ASCII "substitute character"
                }
                
                var _glyph_x        = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__X              ];
                var _glyph_y        = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__Y              ];
                var _glyph_width    = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__WIDTH          ];
                var _glyph_height   = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__HEIGHT         ];
                
                var _packed_indexes = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX];
                
                var _sprite_index   = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__SPRITE_INDEX   ];
                var _image_index    = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__IMAGE_INDEX    ];
                var _image_speed    = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__IMAGE_SPEED    ];
                
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
                
                var _j = _image_index;
                repeat((_image_speed > 0)? _sprite_number : 1) //Only draw one image if we have an image speed of 0 since we're not animating
                {
                    var _glyph_texture = sprite_get_texture(_sprite_index, _j);
                    
                    var _uvs = sprite_get_uvs(_sprite_index, _j);
                    var _quad_u0 = _uvs[0];
                    var _quad_v0 = _uvs[1];
                    var _quad_u1 = _uvs[2];
                    var _quad_v1 = _uvs[3];
                    
                    var _quad_l = floor(_glyph_x + _uvs[4]/_glyph_xscale);
                    var _quad_t = floor(_glyph_y + _uvs[5]/_glyph_yscale);
                    var _quad_r = _quad_l + _uvs[6]*_glyph_width;
                    
                    if (!__SCRIBBLE_ON_WEB)
                    {
                        var _quad_b = _quad_t + _uvs[7]*_glyph_height;
                    }
                    else
                    {
                        //FIXME - sprite_get_uvs() occasionally gives us nonsense for the 7-index result in runtime 2022.3.0.497
                        static _html5_sprite_height_workaround_dict = {};
                        
                        var _crop_height = _html5_sprite_height_workaround_dict[$ string(_sprite_index) + ":" + string(_j)];
                        if (_crop_height == undefined)
                        {
                            var _sprite_data = sprite_get_info(_sprite_index);
                            _crop_height = _sprite_data.frames[_j].crop_height;
                            
                            _html5_sprite_height_workaround_dict[$ string(_sprite_index) + ":" + string(_j)] = _crop_height;
                        }
                        
                        var _quad_b = _quad_t + _crop_height/_glyph_yscale;
                    }
                    
                    var _half_w = 0.5*(_quad_r - _quad_l);
                    var _half_h = 0.5*(_quad_b - _quad_t);
                    
                    __SCRIBBLE_VBUFF_WRITE_GLYPH;
                    
                    ++_j;
                    ++_glyph_sprite_data;
                }
                
                if (!SCRIBBLE_COLORIZE_SPRITES) _write_colour = _old_write_colour;
                _glyph_effect_flags = _old_glyph_effect_flags;
                _glyph_sprite_data = 0; //Reset this because every other type of glyph doesn't use this
                
                #endregion
            }
            else if (_glyph_ord == __SCRIBBLE_GLYPH_SURFACE)
            {
                if (SCRIBBLE_ALLOW_TEXT_GETTER)
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
                    _glyph_effect_flags |= (1 << _effects_map[? "rainbow"]);
                    _glyph_effect_flags |= (1 << _effects_map[? "cycle"  ]);
                    _glyph_effect_flags = ~_glyph_effect_flags;
                }
                
                __SCRIBBLE_VBUFF_WRITE_GLYPH;
                
                if (!SCRIBBLE_COLORIZE_SPRITES)
                {
                    _write_colour       = _old_write_colour;
                    _glyph_effect_flags = _old_glyph_effect_flags;
                }
            }
            else //Writing a standard glyph
            {
                if (SCRIBBLE_ALLOW_TEXT_GETTER)
                {
                    __scribble_buffer_write_unicode(_string_buffer, _glyph_ord);
                }
                
                if ((_glyph_ord == 0x00) || (_glyph_ord == 0x0A))
                {
                    if (_region_name != undefined)
                    {
                        var _region_end = (_glyph_ord == 0x00)? _i-1 : _i;
                        
                        if (_region_start <= _region_end)
                        {
                            //Push a bounding box to the region, if we have one
                            //N.B. This array is exposed to the end-user via .region_get_bboxes()
                            array_push(_region_bbox_array, {
                                x1 : ds_grid_get_min(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_L, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_L),
                                y1 : ds_grid_get_min(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_T, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_T),
                                x2 : ds_grid_get_max(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_R, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_R),
                                y2 : ds_grid_get_max(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_B, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_B),
                            });
                        }
                        
                        _region_bbox_start = _region_end + 1;
                    }
                }
                else if ((_glyph_ord > 0x20) && (_glyph_ord != 0xA0) && (_glyph_ord != 0x200B))
                {
                    __SCRIBBLE_VBUFF_READ_GLYPH;
                    __SCRIBBLE_VBUFF_WRITE_GLYPH;
                }
            }
            
            ++_i;
        }
        
        //If we have a hanging glyph then ensure we pop it onto the page we left
        if (_region_name != undefined)
        {
            var _region_end = _i - 1;
            if (_region_start <= _region_end)
            {
                //Push a bounding box to the region
                array_push(_region_bbox_array, {
                    x1 : ds_grid_get_min(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_L, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_L),
                    y1 : ds_grid_get_min(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_T, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_T),
                    x2 : ds_grid_get_max(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_R, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_R),
                    y2 : ds_grid_get_max(_vbuff_pos_grid, _region_bbox_start, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_B, _region_end, __SCRIBBLE_GEN_VBUFF_POS.__QUAD_B),
                });
                
                //Only store a region that actually covers a glyph
                array_push(_page_data.__region_array, {
                    name:        _region_name,
                    bbox_array:  _region_bbox_array,
                    start_glyph: _region_start - _page_data.__glyph_start,
                    end_glyph:   _region_end - _page_data.__glyph_start,
                });
            }
            
            //Set up so that we still have a region open on the next page
            _region_start      = _i;
            _region_bbox_start = _i;
            _region_bbox_array = [];
        }
        
        if (SCRIBBLE_ALLOW_TEXT_GETTER)
        {
            //Write a null terminator to finish off the string
            buffer_write(_string_buffer, buffer_u8, 0);
            buffer_seek(_string_buffer, buffer_seek_start, 0);
            _page_data.__text = buffer_read(_string_buffer, buffer_string);
        }
        
        ++_p;
    }
    
    //Sweep up any remaining controls
    var _control_delta = _glyph_grid[# _i-1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] - _control_index;
    repeat(_control_delta)
    {
        if (_control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__TYPE] == __SCRIBBLE_GEN_CONTROL_TYPE.__EVENT)
        {
            var _character_index =  _packed_indexes div __SCRIBBLE_MAX_LINES;
            var _line_index      = (_packed_indexes mod __SCRIBBLE_MAX_LINES) + ((_character_index > 0)? 1 : 0);
            
            var _event = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__DATA];
            _event.position        = _character_index; //Legacy
            _event.character_index = _character_index;
            _event.line_index      = _line_index;
            
            
            
            var _event_array = _page_char_events_dict[$ _character_index]; //Find the correct event array in the diciontary, creating a new one if needed
            
            if (!is_array(_event_array))
            {
                var _event_array = [];
                _page_char_events_dict[$ _character_index] = _event_array;
            }
            
            array_push(_event_array, _event);
            
            
            
            var _event_array = _page_line_events_dict[$ _line_index]; //Find the correct event array in the diciontary, creating a new one if needed
            
            if (!is_array(_event_array))
            {
                var _event_array = [];
                _page_line_events_dict[$ _line_index] = _event_array;
            }
            
            array_push(_event_array, _event);
        }
                
        _control_index++;
    }
    
    //Ensure we've ended the vertex buffers we created
    __finalize_vertex_buffers(_element.__freeze);
}
