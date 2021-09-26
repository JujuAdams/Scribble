enum __SCRIBBLE_PARSER_GLYPH
{
    X,                  // 0
    Y,                  // 1
    ORD,                // 2  Can be negative, see below
    FONT_DATA,          // 3
    GLYPH_DATA,         // 4
    EVENTS,             // 5
    WIDTH,              // 6
    SEPARATION,         // 7
    HEIGHT,             // 8
    ASSET_INDEX,        // 9  This gets used for sprite index, surface index, and halign mode
    IMAGE_INDEX,        //10
    IMAGE_SPEED,        //11
    STATE_COLOUR,       //12
    STATE_EFFECT_FLAGS, //13
    STATE_SCALE,        //14
    STATE_SLANT,        //15
    CHARACTER_INDEX,    //16
    FONT_SCALE_DIST,    //17
    __SIZE,             //18
}

enum __SCRIBBLE_PARSER_WORD
{
    GLYPH_START, //0
    GLYPH_END,   //1
    WIDTH,       //2
    HEIGHT,      //3
    X,           //4
    Y,           //5
    __SIZE,      //6
}

enum __SCRIBBLE_PARSER_LINE
{
    X,          //0
    Y,          //1
    WORD_START, //2
    WORD_END,   //3
    WIDTH,      //4
    HEIGHT,     //5
    HALIGN,     //6
    X_RIGHT,    //7
    __SIZE,     //8
}

//These can be used for ORD
#macro  __SCRIBBLE_PARSER_SPRITE   -1
#macro  __SCRIBBLE_PARSER_SURFACE  -2
#macro  __SCRIBBLE_PARSER_HALIGN   -3
#macro  __SCRIBBLE_PARSER_EVENT    -4



//In-line macros!
#macro __SCRIBBLE_PARSER_WRITE_GLYPH_STATE  _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X                 ] = _glyph_x_in_word;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y                 ] = 0;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_COLOUR      ] = _state_final_colour;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_EFFECT_FLAGS] = _state_effect_flags;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_SCALE       ] = _state_scale;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_SLANT       ] = _state_slant;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_SCALE_DIST   ] = _font_scale_dist;


#macro __SCRIBBLE_PARSER_WRITE_HALIGN  _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD            ] = __SCRIBBLE_PARSER_HALIGN;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA      ] = undefined;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA     ] = undefined;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS         ] = undefined;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH          ] = 0;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT         ] = 0;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION     ] = 0;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX    ] = _state_halign;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX    ] = undefined;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED    ] = undefined;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX] = _character_index;\n
                                       __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;\n
                                       ++_glyph_count;


#macro __SCRIBBLE_PARSER_WRITE_EVENT  _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD            ] = __SCRIBBLE_PARSER_EVENT;\n
                                      _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA      ] = undefined;\n
                                      _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA     ] = undefined;\n
                                      _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS         ] = undefined;\n
                                      _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH          ] = 0;\n
                                      _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT         ] = 0;\n
                                      _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION     ] = 0;\n
                                      _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX    ] = new __scribble_class_event(_tag_command_name, _tag_parameters);\n
                                      _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX    ] = undefined;\n
                                      _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED    ] = undefined;\n
                                      _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX] = _character_index;\n
                                      __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;\n
                                      ++_glyph_count;


#macro __SCRIBBLE_PARSER_WRITE_NEWLINE  _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD            ] = 0x0D;\n //ASCII line break (dec = 13)
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA      ] = undefined;\n
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA     ] = undefined;\n
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS         ] = undefined;\n
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH          ] = 0;\n
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT         ] = _state_scale*_font_line_height;\n
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION     ] = 0;\n
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX    ] = undefined;\n
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX    ] = undefined;\n
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED    ] = undefined;\n
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX] = _character_index;\n
                                        __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;\n
                                        ++_glyph_count;


#macro __SCRIBBLE_PARSER_SET_FONT   var _font_data         = __scribble_get_font_data(_font_name);\n
                                    var _font_glyphs_map   = _font_data.glyphs_map;\n
                                    var _font_glyphs_array = _font_data.glyphs_array;\n
                                    var _font_glyphs_min   = _font_data.glyph_min;\n
                                    var _font_glyphs_max   = _font_data.glyph_max;\n
                                    var _font_msdf_range   = _font_data.msdf_range;\n
                                    var _font_scale_dist   = _font_data.scale_dist;\n
                                    var _space_glyph_data = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];\n
                                    if (_space_glyph_data == undefined)\n
                                    {\n
                                        __scribble_error("The space character is missing from font definition for \"", _font_name, "\"");\n
                                        return false;\n
                                    }\n
                                    var _font_line_height = _space_glyph_data[SCRIBBLE_GLYPH.HEIGHT];\n
                                    var _font_space_width = _space_glyph_data[SCRIBBLE_GLYPH.WIDTH ];

#macro __SCRIBBLE_PARSER_ADD_WORD  _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.GLYPH_START] = _word_glyph_start;\n
                                   _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.GLYPH_END  ] = _word_glyph_end;\n
                                   _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.WIDTH      ] = _word_width;\n
                                   _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.HEIGHT     ] = ds_grid_get_max(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT);\n
                                   _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.X          ] = _word_x;\n
                                   _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.Y          ] = 0;\n
                                   _word_count++;

#macro __SCRIBBLE_PARSER_ADD_LINE  _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.X         ] = 0;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.Y         ] = 0;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_START] = _line_word_start;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_END  ] = _line_word_end;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WIDTH     ] = _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.X] + _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.WIDTH];\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HEIGHT    ] = clamp(ds_grid_get_max(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.HEIGHT, _line_word_end, __SCRIBBLE_PARSER_WORD.HEIGHT), _line_height_min, _line_height_max);\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HALIGN    ] = _state_halign;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.X_RIGHT   ] = 0;\n
                                   _line_count++;

#macro __SCRIBBLE_PARSER_READ_GLYPH_DATA   var _glyph_x            = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X                 ];\n
                                           var _glyph_y            = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.Y                 ];\n
                                           var _glyph_colour       = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_COLOUR      ];\n
                                           var _glyph_effect_flags = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_EFFECT_FLAGS];\n
                                           var _glyph_scale        = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_SCALE       ];\n
                                           var _glyph_slant        = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_SLANT       ];\n
                                           var _glyph_char_index   = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX   ];

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
                                          if (_quad_cx < _bezier_prev_cx)\n //If we've snapped back to the LHS then reset our Bezier curve 
                                          {\n //TODO - Do this better to respect R2L text. Maybe use a line number check?
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

