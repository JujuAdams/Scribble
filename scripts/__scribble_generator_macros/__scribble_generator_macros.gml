enum __SCRIBBLE_PARSER_GLYPH
{
    X,
    Y,
    ORD,
    FONT_DATA,
    GLYPH_DATA,
    EVENTS,
    WIDTH,
    SEPARATION,
    HEIGHT,
    ASSET_INDEX,
    IMAGE_INDEX,
    IMAGE_SPEED,
    STATE_COLOUR,
    STATE_EFFECT_FLAGS,
    STATE_SCALE,
    STATE_SLANT,
    __SIZE,
}

enum __SCRIBBLE_PARSER_WORD
{
    GLYPH_START,
    GLYPH_END,
    WIDTH,
    X,
    Y,
    __SIZE,
}

enum __SCRIBBLE_PARSER_LINE
{
    GLYPH_START,
    GLYPH_END,
    WORD_START,
    WORD_END,
    WIDTH,
    HALIGN,
    __SIZE,
}


#macro __SCRIBBLE_PARSER_SPRITE   -1
#macro __SCRIBBLE_PARSER_SURFACE  -2
#macro __SCRIBBLE_PARSER_HALIGN   -3


#macro __SCRIBBLE_PARSER_WRITE_GLYPH_STATE  _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_COLOUR      ] = _state_final_colour;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_EFFECT_FLAGS] = _state_effect_flags;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_SCALE       ] = _state_scale;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_SLANT       ] = _state_slant;

#macro __SCRIBBLE_PARSER_WRITE_HALIGN  _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X          ] = 0;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y          ] = 0;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD        ] = __SCRIBBLE_PARSER_HALIGN;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA  ] = undefined;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA ] = undefined;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS     ] = undefined;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH      ] = 0;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT     ] = 0;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION ] = 0;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX] = _state_halign;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX] = undefined;\n
                                       _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED] = undefined;\n
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
                                   _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.X          ] = _word_x;\n
                                   _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.Y          ] = _word_y;\n
                                   _word_count++;

#macro __SCRIBBLE_PARSER_ADD_LINE  _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.GLYPH_START] = _line_glyph_start;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.GLYPH_END  ] = _line_glyph_end;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_START ] = _line_word_start;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_END   ] = _line_word_end;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WIDTH      ] = _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.X] + _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.WIDTH];\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HALIGN     ] = _state_halign;\n
                                   _line_count++;

#macro __SCRIBBLE_PARSER_READ_GLYPH_DATA   var _glyph_x            = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X                 ];\n
                                           var _glyph_y            = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.Y                 ];\n
                                           var _glyph_colour       = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_COLOUR      ];\n
                                           var _glyph_effect_flags = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_EFFECT_FLAGS];\n
                                           var _glyph_scale        = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_SCALE       ];\n
                                           var _glyph_slant        = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_SLANT       ];

#macro __SCRIBBLE_PARSER_WRITE_GLYPH  var _quad_cx = 0.5*(_quad_l + _quad_r);\n
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
                                      vertex_position_3d(_vbuff, _quad_l + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_ls, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);\n
                                      vertex_position_3d(_vbuff, _quad_r,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_r,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);\n
                                      vertex_position_3d(_vbuff, _quad_l,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_l,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);\n
                                      vertex_position_3d(_vbuff, _quad_r,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_r,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);\n
                                      vertex_position_3d(_vbuff, _quad_l + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_ls, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);\n
                                      vertex_position_3d(_vbuff, _quad_r + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_rs, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _glyph_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);

