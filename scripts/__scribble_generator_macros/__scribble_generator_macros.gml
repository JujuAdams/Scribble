enum __SCRIBBLE_PARSER_GLYPH
{
    ORD,              // 0  \   Can be negative, see below
    BIDI,             // 1   |
                      //     |
    X,                // 2   |
    Y,                // 3   |
    WIDTH,            // 4   |
    HEIGHT,           // 5   |
    FONT_HEIGHT,      // 6   |
    SEPARATION,       // 7   | This group of enums must not change order or be split
    SCALE,            // 8   |
                      //     |
    TEXTURE,          // 9   |
    QUAD_U0,          //10   |
    QUAD_V0,          //11   |
    QUAD_U1,          //12   |
    QUAD_V1,          //13   |
                      //     |
    MSDF_PXRANGE,     //14  /
    
    CONTROL_COUNT,    //15
    ANIMATION_INDEX,  //16
                      
    SPRITE_INDEX,     //17  \
    IMAGE_INDEX,      //18   | Only used for sprites
    IMAGE_SPEED,      //19  /
                      
    __SIZE,           //20
}

enum __SCRIBBLE_VBUFF_POS
{
    QUAD_L, //0
    QUAD_T, //1
    QUAD_R, //2
    QUAD_B, //3
    __SIZE, //4
}

enum __SCRIBBLE_CONTROL_TYPE
{
    EVENT,
    HALIGN,
    COLOUR,
    EFFECT,
    CYCLE
}

//These can be used for ORD
#macro  __SCRIBBLE_GLYPH_SPRITE   -1
#macro  __SCRIBBLE_GLYPH_SURFACE  -2

enum __SCRIBBLE_PARSER_CONTROL
{
    TYPE,   //0
    DATA,   //1
    __SIZE, //2
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
    __SIZE,      //6
}


//In-line macros!
#macro __SCRIBBLE_PARSER_PUSH_SCALE  if (_state_scale != 1)\
                                     {\
                                            ds_grid_multiply_region(_glyph_grid, _state_scale_start_glyph, __SCRIBBLE_PARSER_GLYPH.X, _glyph_count, __SCRIBBLE_PARSER_GLYPH.SCALE, _state_scale);\ //Covers x, y, width, height, and separation
                                     }\
                                     _state_scale_start_glyph = _glyph_count;

                
#macro __SCRIBBLE_PARSER_WRITE_NEWLINE  _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD          ] = 0x0A;\ //ASCII line break (dec = 10)
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI         ] = __SCRIBBLE_BIDI.ISOLATED;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X            ] = 0;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y            ] = 0;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH        ] = 0;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT       ] = _font_line_height;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_HEIGHT  ] = _font_line_height;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION   ] = 0;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CONTROL_COUNT] = _control_count;\
                                        ;\
                                        ++_glyph_count;\
                                        _glyph_prev_arabic_join_next = false;\
                                        _glyph_prev = 0x0A;\
                                        _glyph_prev_prev = _glyph_prev;
                
#macro __SCRIBBLE_PARSER_WRITE_GLYPH  ;\//Pull info out of the font's data structures
                                      var _data_index = _font_glyphs_map[? _glyph_write];\
                                      ;\//If our glyph is missing, choose the missing character glyph instead!
                                      if (_data_index == undefined) _data_index = _font_glyphs_map[? ord(SCRIBBLE_MISSING_CHARACTER)];\
                                      if (_data_index == undefined)\
                                      {\
                                          ;\//This should only happen if SCRIBBLE_MISSING_CHARACTER is missing for a font
                                          __scribble_trace("Couldn't find glyph data for character code " + string(_glyph_write) + " (" + chr(_glyph_write) + ") in font \"" + string(_font_name) + "\"");\
                                      }\
                                      else\
                                      {\
                                          ;\//Add this glyph to our grid by copying from the font's own glyph data grid
                                          ds_grid_set_grid_region(_glyph_grid, _font_glyph_data_grid, _data_index, SCRIBBLE_GLYPH.ORD, _data_index, SCRIBBLE_GLYPH.MSDF_PXRANGE, _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD);\
                                          _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CONTROL_COUNT] = _control_count;\
                                          ;\
                                          ++_glyph_count;\
                                          ;\//We don't set _glyph_prev_arabic_join_next here, we do it further up
                                          _glyph_prev = _glyph_write;\
                                          _glyph_prev_prev = _glyph_prev;\
                                      }


#macro __SCRIBBLE_PARSER_SET_FONT   var _font_data            = __scribble_get_font_data(_font_name);\
                                    var _font_glyph_data_grid = _font_data.glyph_data_grid;\
                                    var _font_glyphs_map      = _font_data.glyphs_map;\
                                    var _space_data_index     = _font_glyphs_map[? 32];\
                                    if (_space_data_index == undefined)\
                                    {\
                                        __scribble_error("The space character is missing from font definition for \"", _font_name, "\"");\
                                        return false;\
                                    }\
                                    var _font_space_width = _font_glyph_data_grid[# _space_data_index, SCRIBBLE_GLYPH.WIDTH ];\
                                    var _font_line_height = _font_glyph_data_grid[# _space_data_index, SCRIBBLE_GLYPH.HEIGHT];


#macro __SCRIBBLE_VBUFF_READ_GLYPH  var _quad_l = _vbuff_pos_grid[# _i, __SCRIBBLE_VBUFF_POS.QUAD_L];\
                                    var _quad_t = _vbuff_pos_grid[# _i, __SCRIBBLE_VBUFF_POS.QUAD_T];\
                                    var _quad_r = _vbuff_pos_grid[# _i, __SCRIBBLE_VBUFF_POS.QUAD_R];\
                                    var _quad_b = _vbuff_pos_grid[# _i, __SCRIBBLE_VBUFF_POS.QUAD_B];\
                                    ;\
                                    var _glyph_texture = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.TEXTURE];\
                                    var _quad_u0       = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.QUAD_U0];\
                                    var _quad_v0       = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.QUAD_V0];\
                                    var _quad_u1       = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.QUAD_U1];\
                                    var _quad_v1       = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.QUAD_V1];\
                                    ;\
                                    var _half_w = 0.5*_glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.WIDTH ];\
                                    var _half_h = 0.5*_glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.HEIGHT];\
                                    ;\
                                    var _packed_indexes = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX];\
                                    var _glyph_scale    = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.SCALE          ];


#macro __SCRIBBLE_VBUFF_WRITE_GLYPH  if (_glyph_texture != _last_glyph_texture)\
                                     {\
                                         _last_glyph_texture = _glyph_texture;\
                                         _vbuff = _page_data.__get_vertex_buffer(_last_glyph_texture, _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.MSDF_PXRANGE], true, self);\
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
                                     vertex_position_3d(_vbuff, _quad_l, _quad_t, _packed_indexes); vertex_normal(_vbuff,  _half_w, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _glyph_scale,  _half_h);\
                                     vertex_position_3d(_vbuff, _quad_r, _quad_b, _packed_indexes); vertex_normal(_vbuff, -_half_w, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _glyph_scale, -_half_h);\
                                     vertex_position_3d(_vbuff, _quad_l, _quad_b, _packed_indexes); vertex_normal(_vbuff,  _half_w, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v1); vertex_float2(_vbuff, _glyph_scale, -_half_h);\
                                     vertex_position_3d(_vbuff, _quad_r, _quad_b, _packed_indexes); vertex_normal(_vbuff, -_half_w, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _glyph_scale, -_half_h);\
                                     vertex_position_3d(_vbuff, _quad_l, _quad_t, _packed_indexes); vertex_normal(_vbuff,  _half_w, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _glyph_scale,  _half_h);\
                                     vertex_position_3d(_vbuff, _quad_r, _quad_t, _packed_indexes); vertex_normal(_vbuff, -_half_w, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _write_colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v0); vertex_float2(_vbuff, _glyph_scale,  _half_h);