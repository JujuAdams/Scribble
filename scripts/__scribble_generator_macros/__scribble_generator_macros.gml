enum __SCRIBBLE_PARSER_GLYPH
{
    X,                  // 0
    Y,                  // 1
    WIDTH,              // 2
    HEIGHT,             // 3
    ORD,                // 4  Can be negative, see below
    ANIMATION_INDEX,    // 5
    FONT_DATA,          // 6
    GLYPH_DATA,         // 7
    SEPARATION,         // 8
    ASSET_INDEX,        // 9  This gets used for sprite index, surface index, and halign mode
    IMAGE_INDEX,        //10
    IMAGE_SPEED,        //11
    STATE_COLOUR,       //12
    STATE_EFFECT_FLAGS, //13
    STATE_SCALE,        //14
    STATE_SLANT,        //15
    FONT_SCALE_DIST,    //16
    BIDI,               //17
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
#macro __SCRIBBLE_PARSER_WRITE_GLYPH_STATE  _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_COLOUR      ] = _state_final_colour;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_EFFECT_FLAGS] = _state_effect_flags;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_SCALE       ] = _state_scale;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_SLANT       ] = _state_slant;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_SCALE_DIST   ] = _font_scale_dist;


#macro __SCRIBBLE_PARSER_WRITE_HALIGN  _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.TYPE    ] = __SCRIBBLE_CONTROL_HALIGN;\n
                                       _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.DATA    ] = _state_halign;\n
                                       _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.POSITION] = _glyph_count;\n
                                       _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.PAGE    ] = _control_page;\n
                                       ++_control_count;


#macro __SCRIBBLE_PARSER_WRITE_EVENT  _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.TYPE    ] = __SCRIBBLE_CONTROL_EVENT;\n
                                      _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.DATA    ] = new __scribble_class_event(_tag_command_name, _tag_parameters);\n
                                      _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.POSITION] = _glyph_count;\n
                                      _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.PAGE    ] = _control_page;\n
                                      ++_control_count;


#macro __SCRIBBLE_PARSER_WRITE_PAGEBREAK  _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.TYPE    ] = __SCRIBBLE_CONTROL_PAGEBREAK;\n
                                          _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.DATA    ] = undefined;\n
                                          _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.POSITION] = _glyph_count;\n
                                          _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.PAGE    ] = _control_page;\n
                                          ++_control_count;\n
                                          ++_control_page;


#macro __SCRIBBLE_PARSER_WRITE_FULL_GLYPH  ;\//Pull info out of the font's data structures
                                           var _glyph_data = _font_glyphs_map[? _glyph_write];\
                                           ;\
                                           ;\//If our glyph is missing, choose the missing character glyph instead!
                                           if (_glyph_data == undefined) _glyph_data = _font_glyphs_map[? ord(SCRIBBLE_MISSING_CHARACTER)];\
                                           ;\
                                           if (_glyph_data == undefined)\
                                           {\
                                               ;\//This should only happen if SCRIBBLE_MISSING_CHARACTER is missing for a font
                                               __scribble_trace("Couldn't find glyph data for character code " + string(_glyph_write) + " (" + chr(_glyph_write) + ") in font \"" + string(_font_name) + "\"");\
                                           }\
                                           else\
                                           {\
                                               ;\//Add this glyph to our grid
                                               _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = _glyph_write;\
                                               _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA ] = _font_data;\
                                               _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA] = _glyph_data;\
                                               _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = _state_scale*_glyph_data[SCRIBBLE_GLYPH.WIDTH];\
                                               _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _state_scale*_font_line_height;\
                                               _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = _state_scale*_glyph_data[SCRIBBLE_GLYPH.SEPARATION];\
                                               _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI      ] = _glyph_data[SCRIBBLE_GLYPH.BIDI];\
                                               __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;\
                                               ++_glyph_count;\
                                               ;\
                                               ;\//We don't set _glyph_prev_arabic_join_next here, we do it further up
                                               _glyph_prev = _glyph_write;\
                                               _glyph_prev_prev = _glyph_prev;\
                                           }


#macro __SCRIBBLE_PARSER_SET_FONT   var _font_data         = __scribble_get_font_data(_font_name);\n
                                    var _font_glyphs_map   = _font_data.glyphs_map;\n
                                    var _font_msdf_pxrange = _font_data.msdf_pxrange;\n
                                    var _font_scale_dist   = _font_data.scale_dist;\n
                                    var _space_glyph_data  = _font_glyphs_map[? 32];\n
                                    if (_space_glyph_data == undefined)\n
                                    {\n
                                        __scribble_error("The space character is missing from font definition for \"", _font_name, "\"");\n
                                        return false;\n
                                    }\n
                                    var _font_line_height = _space_glyph_data[SCRIBBLE_GLYPH.HEIGHT];\n
                                    var _font_space_width = _space_glyph_data[SCRIBBLE_GLYPH.WIDTH ];

#macro __SCRIBBLE_PARSER_READ_GLYPH_DATA   var _glyph_x            = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X                 ];\n
                                           var _glyph_y            = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.Y                 ];\n
                                           var _glyph_colour       = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_COLOUR      ];\n
                                           var _glyph_effect_flags = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_EFFECT_FLAGS];\n
                                           var _glyph_scale        = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_SCALE       ];\n
                                           var _glyph_slant        = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_SLANT       ];\n
                                           var _glyph_char_index   = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX   ];\
                                           _glyph_colour = (__SCRIBBLE_ON_OPENGL? scribble_rgb_to_bgr(_glyph_colour) : _glyph_colour); //Fix for bug in vertex_argb() on OpenGL targets (2021-11-24  runtime 2.3.5.458)

#macro __SCRIBBLE_READ_CONTROL_EVENTS  while((_i == _next_control_pos) && (_p == _control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.PAGE]))\n //If this *global* glyph index is the same as our control position then scan for new controls to apply
                                       {\n
                                           if (_control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.TYPE] == __SCRIBBLE_CONTROL_EVENT)\n //If this control is an event, add that to the page's events dictionary
                                           {\n
                                                var _event_array = _page_events_dict[$ _animation_index];\n //Find the correct event array in the diciontary, creating a new one if needed
                                                if (!is_array(_event_array))\n
                                                {\n
                                                    var _event_array = [];\n
                                                    _page_events_dict[$ _animation_index] = _event_array;\n
                                                }\n
                                                var _event = _control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.DATA];\n
                                                _event.position = _animation_index;\n //Update the glyph index to the *local* glyph index for the page
                                                array_push(_event_array, _event);\n
                                           }\n
                                           ++_control_index;\n //Increment which control we're processing
                                           _next_control_pos = _control_grid[# _control_index, __SCRIBBLE_PARSER_CONTROL.POSITION];\n
                                       }


#macro __SCRIBBLE_PARSER_WRITE_GLYPH  var _packed_indexes = _glyph_char_index*__SCRIBBLE_MAX_LINES + 1;\n //TODO
                                      var _quad_cx = 0.5*(_quad_l + _quad_r);\n
                                      var _quad_cy = 0.5*(_quad_t + _quad_b);\n
                                      var _slant_offset = SCRIBBLE_SLANT_AMOUNT*_glyph_scale*_glyph_slant*(_quad_b - _quad_t);\n
                                      var _delta_l  = _quad_cx - _quad_l;\n
                                      var _delta_t  = _quad_cy - _quad_t;\n
                                      var _delta_r  = _quad_cx - _quad_r;\n
                                      var _delta_b  = _quad_cy - _quad_b;\n
                                      var _delta_ls = _delta_l - _slant_offset;\n
                                      var _delta_rs = _delta_r - _slant_offset;\n
                                      if (_glyph_texture != _last_glyph_texture)\n
                                      {\n
                                          _last_glyph_texture = _glyph_texture;\n
                                          _vbuff = _page_data.__get_vertex_buffer(_glyph_texture, _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.FONT_DATA], true, self);\n
                                      }\n
                                      if (_bezier_do)\n
                                      {\n
                                          if (_quad_cy > _bezier_prev_cy)\n //If we've snapped back to the LHS then reset our Bezier curve 
                                          {\n //TODO - Maybe use a line number check instead? This could get slow
                                              _bezier_search_index = 0;\n
                                              _bezier_search_d0 = 0;\n
                                              _bezier_search_d1 = _bezier_lengths[1];\n
                                          }\n
                                          _bezier_prev_cx = _quad_cx;\n
                                          while (true)\n //Iterate forwards until we find a Bezier segment we can fit into
                                          {\n
                                              if (_quad_cx <= _bezier_search_d1)\n //If this glyph is on this line segment...
                                              {\n
                                                  var _bezier_param = _bezier_param_increment*((_quad_cx - _bezier_search_d0)/ (_bezier_search_d1 - _bezier_search_d0) + _bezier_search_index);\n //...then parameterise this glyph
                                                  break;\n
                                              }\n
                                              _bezier_search_index++;\n
                                              if (_bezier_search_index >= SCRIBBLE_BEZIER_ACCURACY-1)\n
                                              {\n
                                                  var _bezier_param = 1.0;\n //We've hit the end of the Bezier curve, force all the remaining glyphs to stack up at the end of the line
                                                  break;\n
                                              }\n
                                              _bezier_search_d0 = _bezier_search_d1;\n //Advance to the next line segment
                                              _bezier_search_d1 = _bezier_lengths[_bezier_search_index+1];\n
                                          }\n
                                          _slant_offset = 0;\n
                                          _quad_l = _bezier_param;\n
                                          _quad_r = _bezier_param;\n
                                          _quad_t = _quad_cy;\n
                                          _quad_b = _quad_cy;\n
                                      }\n
                                      vertex_position_3d(_vbuff, _quad_l + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_ls, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);\n
                                      vertex_position_3d(_vbuff, _quad_r,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_r,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);\n
                                      vertex_position_3d(_vbuff, _quad_l,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_l,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);\n
                                      vertex_position_3d(_vbuff, _quad_r,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_r,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);\n
                                      vertex_position_3d(_vbuff, _quad_l + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_ls, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);\n
                                      vertex_position_3d(_vbuff, _quad_r + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_rs, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);

