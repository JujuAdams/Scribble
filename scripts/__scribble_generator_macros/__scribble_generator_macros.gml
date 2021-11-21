enum __SCRIBBLE_PARSER_GLYPH
{
    X,                  // 0
    Y,                  // 1
    ORD,                // 2  Can be negative, see below
    WIDTH,              // 3  These three parameters must be contiguous
    HEIGHT,             // 4  These three parameters must be contiguous
    SEPARATION,         // 5  These three parameters must be contiguous
    ANIMATION_INDEX,    // 6
    FONT_DATA,          // 7
    GLYPH_DATA,         // 8
    BIDI,               // 9
    ASSET_INDEX,        //10  This gets used for sprite index, surface index, and halign mode
    IMAGE_INDEX,        //11
    IMAGE_SPEED,        //12
    STATE_COLOUR,       //13
    STATE_EFFECT_FLAGS, //14
    STATE_SCALE,        //15
    STATE_SLANT,        //16
    FONT_SCALE_DIST,    //17
    __SIZE,             //18
}

//These can be used for ORD
#macro  __SCRIBBLE_GLYPH_SPRITE      -1
#macro  __SCRIBBLE_GLYPH_SURFACE     -2
#macro  __SCRIBBLE_CONTROL_HALIGN    -3
#macro  __SCRIBBLE_CONTROL_EVENT     -4
#macro  __SCRIBBLE_CONTROL_PAGEBREAK -5

enum __SCRIBBLE_PARSER_CONTROL
{
    TYPE,     //0
    DATA,     //1
    POSITION, //2
    PAGE,     //3
    __SIZE,   //4
}

enum __SCRIBBLE_PARSER_WORD
{
    GLYPH_START, //0
    GLYPH_END,   //1
    WIDTH,       //2
    HEIGHT,      //3
    BIDI_RAW,    //4
    BIDI,        //5
    __SIZE,      //6
}

enum __SCRIBBLE_PARSER_STRETCH
{
    WORD_START, //0
    WORD_END,   //1
    BIDI,       //2
    __SIZE,
}

enum __SCRIBBLE_PARSER_LINE
{
    Y,           //0
    WORD_START,  //1
    WORD_END,    //2
    WIDTH,       //3
    HEIGHT,      //4
    HALIGN,      //5
    CONTROL_END, //6
    __SIZE,      //7
}



//In-line macros!          
#macro __SCRIBBLE_PARSER_POP_COLOUR  ds_grid_set_region(_glyph_grid, _state_colour_start_glyph, __SCRIBBLE_PARSER_GLYPH.STATE_COLOUR, _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.STATE_COLOUR, _state_final_colour);\
                                     _state_colour_start_glyph = _glyph_count-1;
                                    
#macro __SCRIBBLE_PARSER_POP_EFFECT_FLAGS  ds_grid_set_region(_glyph_grid, _state_effects_start_glyph, __SCRIBBLE_PARSER_GLYPH.STATE_EFFECT_FLAGS, _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.STATE_EFFECT_FLAGS, _state_effect_flags);\
                                           _state_effects_start_glyph = _glyph_count-1;
                                    
#macro __SCRIBBLE_PARSER_POP_SCALE  ds_grid_multiply_region(_glyph_grid, _state_scale_start_glyph, __SCRIBBLE_PARSER_GLYPH.WIDTH, _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.SEPARATION, _state_scale);\
                                    ds_grid_set_region(_glyph_grid, _state_scale_start_glyph, __SCRIBBLE_PARSER_GLYPH.STATE_SCALE, _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.STATE_SCALE, _state_scale);\
                                    _state_scale_start_glyph = _glyph_count-1;
                                    
#macro __SCRIBBLE_PARSER_POP_SLANT  ds_grid_set_region(_glyph_grid, _state_slant_start_glyph, __SCRIBBLE_PARSER_GLYPH.STATE_SLANT, _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.STATE_SLANT, _state_slant);\
                                    _state_slant_start_glyph = _glyph_count-1;

#macro __SCRIBBLE_PARSER_WRITE_HALIGN  _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.TYPE    ] = __SCRIBBLE_CONTROL_HALIGN;\
                                       _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.DATA    ] = _state_halign;\
                                       _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.POSITION] = _glyph_count;\
                                       _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.PAGE    ] = _control_page;\
                                       ++_control_count;


#macro __SCRIBBLE_PARSER_WRITE_EVENT  _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.TYPE    ] = __SCRIBBLE_CONTROL_EVENT;\
                                      _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.DATA    ] = new __scribble_class_event(_tag_command_name, _tag_parameters);\
                                      _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.POSITION] = _glyph_count;\
                                      _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.PAGE    ] = _control_page;\
                                      ++_control_count;


#macro __SCRIBBLE_PARSER_WRITE_PAGEBREAK  _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.TYPE    ] = __SCRIBBLE_CONTROL_PAGEBREAK;\
                                          _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.DATA    ] = undefined;\
                                          _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.POSITION] = _glyph_count;\
                                          _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.PAGE    ] = _control_page;\
                                          ++_control_count;\
                                          ++_control_page;


#macro __SCRIBBLE_PARSER_SET_FONT   ds_grid_set_region(_glyph_grid, _font_scale_start_glyph, __SCRIBBLE_PARSER_GLYPH.FONT_SCALE_DIST, _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.FONT_SCALE_DIST, _font_scale_dist);\
                                    _font_scale_start_glyph = _glyph_count-1;\
                                    var _font_data         = __scribble_get_font_data(_font_name);\
                                    var _font_glyphs_map   = _font_data.glyphs_map;\
                                    var _font_msdf_pxrange = _font_data.msdf_pxrange;\
                                    var _font_scale_dist   = _font_data.scale_dist;\
                                    var _space_glyph_data  = _font_glyphs_map[? 32];\
                                    if (_space_glyph_data == undefined)\
                                    {\
                                        __scribble_error("The space character is missing from font definition for \"", _font_name, "\"");\
                                        return false;\
                                    }\
                                    var _font_line_height = _space_glyph_data[SCRIBBLE_GLYPH.HEIGHT];\
                                    var _font_space_width = _space_glyph_data[SCRIBBLE_GLYPH.WIDTH ];

#macro __SCRIBBLE_PARSER_READ_GLYPH_DATA   var _glyph_x            = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X                 ];\
                                           var _glyph_y            = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.Y                 ];\
                                           var _glyph_colour       = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_COLOUR      ];\
                                           var _glyph_effect_flags = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_EFFECT_FLAGS];\
                                           var _glyph_scale        = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_SCALE       ];\
                                           var _glyph_slant        = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_SLANT       ];\
                                           var _glyph_char_index   = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX   ];

#macro __SCRIBBLE_READ_CONTROL_EVENTS  while((_i == _next_control_pos) && (_p == _control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.PAGE]))\ //If this *global* glyph index is the same as our control position then scan for new controls to apply
                                       {\
                                           if (_control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.TYPE] == __SCRIBBLE_CONTROL_EVENT)\ //If this control is an event, add that to the page's events dictionary
                                           {\
                                                var _event_array = _page_events_dict[$ _animation_index];\ //Find the correct event array in the diciontary, creating a new one if needed
                                                if (!is_array(_event_array))\
                                                {\
                                                    var _event_array = [];\
                                                    _page_events_dict[$ _animation_index] = _event_array;\
                                                }\
                                                var _event = _control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.DATA];\
                                                _event.position = _animation_index;\ //Update the glyph index to the *local* glyph index for the page
                                                array_push(_event_array, _event);\
                                           }\
                                           ++_control_index;\ //Increment which control we're processing
                                           _next_control_pos = _control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.POSITION];\
                                       }


#macro __SCRIBBLE_PARSER_WRITE_GLYPH  var _packed_indexes = _glyph_char_index*__SCRIBBLE_MAX_LINES + 1;\ //TODO
                                      var _quad_cx = 0.5*(_quad_l + _quad_r);\
                                      var _quad_cy = 0.5*(_quad_t + _quad_b);\
                                      var _slant_offset = SCRIBBLE_SLANT_AMOUNT*_glyph_scale*_glyph_slant*(_quad_b - _quad_t);\
                                      var _delta_l  = _quad_cx - _quad_l;\
                                      var _delta_t  = _quad_cy - _quad_t;\
                                      var _delta_r  = _quad_cx - _quad_r;\
                                      var _delta_b  = _quad_cy - _quad_b;\
                                      var _delta_ls = _delta_l - _slant_offset;\
                                      var _delta_rs = _delta_r - _slant_offset;\
                                      if (_glyph_texture != _last_glyph_texture)\
                                      {\
                                          _last_glyph_texture = _glyph_texture;\
                                          _vbuff = _page_data.__get_vertex_buffer(_glyph_texture, _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.FONT_DATA], true, self);\
                                      }\
                                      if (_bezier_do)\
                                      {\
                                          if (_quad_cy > _bezier_prev_cy)\ //If we've snapped back to the LHS then reset our Bezier curve 
                                          {\ //TODO - Maybe use a line number check instead? This could get slow
                                              _bezier_search_index = 0;\
                                              _bezier_search_d0 = 0;\
                                              _bezier_search_d1 = _bezier_lengths[1];\
                                          }\
                                          _bezier_prev_cx = _quad_cx;\
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
                                          _slant_offset = 0;\
                                          _quad_l = _bezier_param;\
                                          _quad_r = _bezier_param;\
                                          _quad_t = _quad_cy;\
                                          _quad_b = _quad_cy;\
                                      }\
                                      vertex_position_3d(_vbuff, _quad_l + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_ls, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);\
                                      vertex_position_3d(_vbuff, _quad_r,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_r,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);\
                                      vertex_position_3d(_vbuff, _quad_l,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_l,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);\
                                      vertex_position_3d(_vbuff, _quad_r,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_r,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);\
                                      vertex_position_3d(_vbuff, _quad_l + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_ls, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);\
                                      vertex_position_3d(_vbuff, _quad_r + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_rs, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);

