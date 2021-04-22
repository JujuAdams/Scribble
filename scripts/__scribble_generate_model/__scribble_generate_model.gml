/// @param element

enum __SCRIBBLE_PARSER_GLYPH
{
    CHAR, //TODO - Debug: Remove
    ORD,
    FONT_DATA,
    GLYPH_DATA,
    WIDTH,
    SEPARATION,
    HEIGHT,
    X,
    Y,
    TEXTURE,
    UVS,
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

#macro __SCRIBBLE_PARSER_ADD_LINE  _line_word_end  = _word_count - 1;\n
                                   _line_glyph_end = _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.GLYPH_END];\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.GLYPH_START] = _line_glyph_start;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.GLYPH_END  ] = _line_glyph_end;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_START ] = _line_word_start;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_END   ] = _line_word_end;\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WIDTH      ] = _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.X] + _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.WIDTH];\n
                                   _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HALIGN     ] = fa_left;\n
                                   _line_count++;



function __scribble_generate_model(_element)
{
    var _model_max_width  = _element.wrap_max_width;
    var _model_max_height = _element.wrap_max_height;
    
    if (_model_max_width  < 0) _model_max_width  = infinity;
    if (_model_max_height < 0) _model_max_height = infinity;
    
    
    
    
    #region Collect starting font data
    
    var _def_font = _element.starting_font;
    if (_def_font == undefined) __scribble_error("The default font has not been set\nCheck that you've added fonts to Scribble (scribble_font_add() / scribble_font_add_from_sprite() etc.)");
    
    var _font_name = _def_font;
    __SCRIBBLE_PARSER_SET_FONT;
    
    #endregion
    
    
    
    var _element_text        = _element.text;
    var _element_text_length = string_length(_element_text);
    
    var _string_buffer = global.__scribble_buffer;
    var _glyph_grid    = global.__scribble_glyph_grid;
    var _word_grid     = global.__scribble_word_grid;
    var _line_grid     = global.__scribble_line_grid;
    
    buffer_seek(_string_buffer, buffer_seek_start, 0);
    buffer_write(_string_buffer, buffer_string, _element_text);
    buffer_write(_string_buffer, buffer_u32, 0x0); //Add some extra null characters to avoid errors where we're reading outside the buffer
    buffer_write(_string_buffer, buffer_u32, 0x0); //Add some extra null characters to avoid errors where we're reading outside the buffer
    buffer_seek(_string_buffer, buffer_seek_start, 0);
    
    //Resize grids if we have to
    if (ds_grid_width(_glyph_grid) < _element_text_length) ds_grid_resize(_glyph_grid, _element_text_length+1, __SCRIBBLE_PARSER_GLYPH.__SIZE);
    if (ds_grid_width(_word_grid ) < _element_text_length) ds_grid_resize(_word_grid,  _element_text_length+1, __SCRIBBLE_PARSER_GLYPH.__SIZE);
    
    
    
    var _glyph_count     = 0;
    var _glyph_ord       = 0x0;
    var _glyph_x_in_word = 0;
    
    var _in_tag    = false;
    var _tag_start = undefined;
    
    repeat(string_byte_length(_element_text))
    {
        _glyph_ord = __scribble_buffer_read_unicode(_string_buffer);
        
        if (_in_tag)
        {
            if (_glyph_ord == SCRIBBLE_COMMAND_TAG_CLOSE)
            {
                _in_tag = false;
            }
            else
            {
                //Do nothing!
            }
        }
        else
        {
            if (_glyph_ord == SCRIBBLE_COMMAND_TAG_OPEN)
            {
                _in_tag    = true;
                _tag_start = buffer_tell(_string_buffer);
            }
            else if ((_glyph_ord == 10) //If we've hit a newline (\n)
                 || (SCRIBBLE_HASH_NEWLINE && (_glyph_ord == 35)) //If we've hit a hash, and hash newlines are on
                 || ((_glyph_ord == 13) && (buffer_peek(_string_buffer, buffer_tell(_string_buffer), buffer_u8) != 10))) //If this is a line feed but not followed by a newline... this fixes goofy Windows Notepad isses
            {
                //TODO - Newline
                _glyph_x_in_word = 0;
            }
            else if (_glyph_ord == 32) //TODO - Non-breaking spaces
            {
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHAR      ] = " "; //TODO - Debug: Remove
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 32;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA ] = _font_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA] = _space_glyph_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = _font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X         ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y         ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.TEXTURE   ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.UVS       ] = undefined;
                
                _glyph_x_in_word = 0;
                ++_glyph_count;
            }
            else if (_glyph_ord < 32)
            {
                continue;
            }
            else
            {
                //TODO - Ligature transform here
                
                if (_font_glyphs_array == undefined)
                {
                    var _glyph_data = _font_glyphs_map[? _glyph_ord];
                    if (_glyph_data == undefined) _glyph_data = _font_glyphs_map[? ord(SCRIBBLE_MISSING_CHARACTER)];
                }
                else
                {
                    if ((_glyph_ord < _font_glyphs_min) || (_glyph_ord > _font_glyphs_max))
                    {
                        _glyph_ord = ord(SCRIBBLE_MISSING_CHARACTER);
                        if ((_glyph_ord < _font_glyphs_min) || (_glyph_ord > _font_glyphs_max))
                        {
                            var _glyph_data = undefined;
                        }
                        else
                        {
                            var _glyph_data = _font_glyphs_array[_glyph_ord - _font_glyphs_min];
                        }
                    }
                    else
                    {
                        var _glyph_data = _font_glyphs_array[_glyph_ord - _font_glyphs_min];
                    }
                }
                
                if (_glyph_data == undefined)
                {
                    __scribble_trace("Couldn't find glyph data for character code " + string(_glyph_ord) + " (" + chr(_glyph_ord) + ") in font \"" + string(_font_name) + "\"");
                }
                else
                {
                    var _glyph_separation = _glyph_data[SCRIBBLE_GLYPH.SEPARATION];
                    
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHAR      ] = chr(_glyph_ord); //TODO - Debug, remove
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = _glyph_ord;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA ] = _font_data;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA] = _glyph_data;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = _glyph_data[SCRIBBLE_GLYPH.WIDTH];
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = _glyph_separation;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X         ] = _glyph_x_in_word;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y         ] = 0;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.TEXTURE   ] = _glyph_data[SCRIBBLE_GLYPH.TEXTURE];
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.UVS       ] = undefined;
                    
                    _glyph_x_in_word += _glyph_separation;
                    ++_glyph_count;
                }
            }
        }
    }
    
    //Create a spoof space character so we correctly handle the last character in the string
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 32;
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = 0;
    
    
    
    var _line_count       = 0;
    var _line_glyph_start = 0;
    var _line_glyph_end   = 0;
    var _line_word_start  = 0;
    var _line_word_end    = 0;
    var _line_height      = 0;
    
    var _word_count       = 0;
    var _word_glyph_start = 0;
    var _word_glyph_end   = 0;
    var _word_width       = 0;
    
    var _word_x      = 0;
    var _word_y      = 0;
    var _space_width = 0;
    
    var _i = 0;
    repeat(_glyph_count + 1) //Ensure we fully handle the last word
    {
        //TODO - Figure out where spaces during the basic parsing step
        var _glyph_ord = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ORD];
        
        if (_glyph_ord == 32)
        {
            _word_glyph_end = _i - 1;
            _space_width = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.WIDTH];
             
            if (_word_glyph_end >= _word_glyph_start)
            {
                var _last_glyph_width = _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.WIDTH];
                
                //Word width is equal to the width of the last glyph plus its x-coordinate in the word
                _word_width = _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X] + _last_glyph_width;
                
                //Steal the empty space for the last glyph and add it onto the space
                _space_width += _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.SEPARATION] - _last_glyph_width;
            }
            else
            {
                //Empty word (usually two spaces together)
                _word_glyph_start = _i + 1;
                _word_x += _space_width;
                ++_i;
                continue;
            }
            
            if (_word_width > _model_max_width)
            {
                //_word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.GLYPH_START] = _word_glyph_start;
                //_word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.GLYPH_END  ] = _word_glyph_end;
                //_word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.WIDTH      ] = _word_width;
                //_word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.X          ] = _word_x;
                //_word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.Y          ] = _word_y;
                //_word_count++;
                
                //_line_word_end  = _word_count - 1;
                //_line_glyph_end = _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.GLYPH_END];
                //_line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.GLYPH_START] = _line_glyph_start;
                //_line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.GLYPH_END  ] = _line_glyph_end;
                //_line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_START ] = _line_word_start;
                //_line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_END   ] = _line_word_end;
                //_line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WIDTH      ] = _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.X] + _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.WIDTH];
                //_line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HALIGN     ] = fa_left;
                //_line_count++;
                
                _word_width = 0;
                var _last_glyph_empty_space = 0;
                
                var _j = _word_glyph_start;
                repeat(1 + _word_glyph_end - _word_glyph_start)
                {
                    var _glyph_width = _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.WIDTH];
                    if (_word_x + _word_width + _last_glyph_empty_space + _glyph_width > _model_max_width)
                    {
                        _word_glyph_end = _j - 1;
                        
                        __SCRIBBLE_PARSER_ADD_WORD;
                        
                        _word_glyph_start = _j;
                        
                        _line_height = ds_grid_get_max(_glyph_grid, _line_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _line_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT);
                        
                        __SCRIBBLE_PARSER_ADD_LINE;
                        
                        _line_glyph_start = _word_glyph_start;
                        _line_word_start  = _word_count;
                        
                        _word_x  = 0;
                        _word_y += _line_height;
                        _word_width = 0;
                    }
                    else
                    {
                        _word_width += _last_glyph_empty_space + _glyph_width;
                    }
                    
                    _last_glyph_empty_space = _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.SEPARATION] - _glyph_width;
                    
                    ++_j;
                }
                
                _word_glyph_end = _i - 1;
                __SCRIBBLE_PARSER_ADD_WORD;
                
                _word_glyph_start = _i + 1;
                _word_x += _space_width;
            }
            else
            {
                if (_word_x + _word_width > _model_max_width)
                {
                    _line_height = ds_grid_get_max(_glyph_grid, _line_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _line_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT);
                    
                    __SCRIBBLE_PARSER_ADD_LINE;
                    
                    _line_glyph_start = _word_glyph_start;
                    _line_word_start  = _word_count;
                    
                    _word_x  = 0;
                    _word_y += _line_height;
                }
                
                __SCRIBBLE_PARSER_ADD_WORD;
                
                _word_glyph_start = _i + 1;
                _word_x += _space_width + _word_width;
            }
        }
        
        ++_i;
    }
    
    __SCRIBBLE_PARSER_ADD_LINE;
    
    
    
    //TODO - Handle pages
    
    
    
    width  = ds_grid_get_max(_line_grid, 0, __SCRIBBLE_PARSER_LINE.WIDTH, _line_count - 1, __SCRIBBLE_PARSER_LINE.WIDTH);
    height = ds_grid_get_max(_glyph_grid, _line_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _line_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT) + _word_y;
    
    
    
    //Handle alignment for each line and position words
    var _i = 0;
    repeat(_line_count)
    {
        var _line_halign = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.HALIGN];
        if (_line_halign != fa_left)
        {
            var _line_word_start = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_START];
            var _line_word_end   = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_END  ];
            var _line_width      = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WIDTH     ];
            
            if ((_line_halign == fa_center) || (_line_halign == fa_right))
            {
                var _empty_space = _model_max_width - _line_width;
                var _xoffset = 0;
                
                switch(_line_halign)
                {
                    case fa_center: _xoffset = _empty_space div 2; break;
                    case fa_right:  _xoffset = _empty_space;       break;
                }
                
                ds_grid_add_region(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.X, _line_word_end, __SCRIBBLE_PARSER_WORD.X, _xoffset);
            }
        }
        
        ++_i;
    }
    
    
    
    //Transfer word positions to glyphs
    var _i = 0;
    repeat(_word_count)
    {
        var _word_x           = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.X          ];
        var _word_y           = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.Y          ];
        var _word_glyph_start = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.GLYPH_START];
        var _word_glyph_end   = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.GLYPH_END  ];
        
        ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X, _word_x);
        ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.Y, _word_y);
        
        ++_i;
    }
    
    
    
    //Transfer glyphs to vertex buffers
    var _glyph_effect_flags = 0;
    var _last_glyph_texture = undefined;
    var _page_data          = __new_page();
    var _write_scale        = 1.0;
    var _glyph_sprite_data  = 0;
    var _vbuff              = undefined;
    
    var _i = 0;
    repeat(_glyph_count)
    {
        var _glyph_texture = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.TEXTURE];
        
        //Skip anything that doesn't have a texture (whitespace)
        if (_glyph_texture == undefined)
        {
            ++_i;
            continue;
        }
        
        var _glyph_x     = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X         ];
        var _glyph_y     = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.Y         ];
        var _glyph_data  = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA];
        var _glyph_uvs   = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.UVS       ];
        var _glyph_width = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.WIDTH     ];
        
        if (_glyph_uvs == undefined)
        {
            var _quad_u0 = _glyph_data[SCRIBBLE_GLYPH.U0];
            var _quad_v0 = _glyph_data[SCRIBBLE_GLYPH.V0];
            var _quad_u1 = _glyph_data[SCRIBBLE_GLYPH.U1];
            var _quad_v1 = _glyph_data[SCRIBBLE_GLYPH.V1];
        }
        else
        {
            var _quad_u0 = _glyph_uvs[0];
            var _quad_v0 = _glyph_uvs[1];
            var _quad_u1 = _glyph_uvs[2];
            var _quad_v1 = _glyph_uvs[3];
        }
        
        //Swap texture and buffer if needed
        if (_glyph_texture != _last_glyph_texture)
        {
            _last_glyph_texture = _glyph_texture;
            _vbuff = _page_data.__get_vertex_buffer(_glyph_texture, _font_data, true);
        }
                
        //Add glyph to buffer
        var _quad_l = _glyph_data[SCRIBBLE_GLYPH.X_OFFSET] + _glyph_x;
        var _quad_t = _glyph_data[SCRIBBLE_GLYPH.Y_OFFSET] + _glyph_y;
        var _quad_r = _glyph_width + _quad_l;
        var _quad_b = _glyph_data[SCRIBBLE_GLYPH.HEIGHT] + _quad_t;
                        
        var _quad_cx = 0.5*(_quad_l + _quad_r);
        var _quad_cy = 0.5*(_quad_t + _quad_b);
                        
        var _slant_offset = 0;
                
        var _delta_l  = _quad_cx - _quad_l;
        var _delta_t  = _quad_cy - _quad_t;
        var _delta_r  = _quad_cx - _quad_r;
        var _delta_b  = _quad_cy - _quad_b;
        var _delta_ls = _delta_l - _slant_offset;
        var _delta_rs = _delta_r - _slant_offset;
                        
        var _packed_indexes = _i*__SCRIBBLE_MAX_LINES + 1;
        var _colour = $FFFFFFFF;
        
        vertex_position_3d(_vbuff, _quad_l + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_ls, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);
        vertex_position_3d(_vbuff, _quad_r,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_r,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);
        vertex_position_3d(_vbuff, _quad_l,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_l,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);
        vertex_position_3d(_vbuff, _quad_r,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_r,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);
        vertex_position_3d(_vbuff, _quad_l + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_ls, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);
        vertex_position_3d(_vbuff, _quad_r + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_rs, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);
        
        ++_i;
    }
    
    __finalize_vertex_buffers();
    
    return true;
}

function __scribble_buffer_read_unicode(_buffer)
{
    var _value = buffer_read(_buffer, buffer_u8);
    
    if ((_value & $E0) == $C0) //two-byte
    {
        _value  = (                         _value & $1F) <<  6;
        _value += (buffer_read(_buffer, buffer_u8) & $3F);
    }
    else if ((_value & $F0) == $E0) //three-byte
    {
        _value  = (                         _value & $0F) << 12;
        _value += (buffer_read(_buffer, buffer_u8) & $3F) <<  6;
        _value +=  buffer_read(_buffer, buffer_u8) & $3F;
    }
    else if ((_value & $F8) == $F0) //four-byte
    {
        _value  = (                         _value & $07) << 18;
        _value += (buffer_read(_buffer, buffer_u8) & $3F) << 12;
        _value += (buffer_read(_buffer, buffer_u8) & $3F) <<  6;
        _value +=  buffer_read(_buffer, buffer_u8) & $3F;
    }
    
    return _value;
}

function __scribble_buffer_peek_unicode(_buffer, _offset)
{
    var _value = buffer_peek(_buffer, _offset, buffer_u8);
    
    if ((_value & $E0) == $C0) //two-byte
    {
        _value  = (                                    _value & $1F) <<  6;
        _value += (buffer_peek(_buffer, _offset+1, buffer_u8) & $3F);
    }
    else if ((_value & $F0) == $E0) //three-byte
    {
        _value  = (                                    _value & $0F) << 12;
        _value += (buffer_peek(_buffer, _offset+1, buffer_u8) & $3F) <<  6;
        _value +=  buffer_peek(_buffer, _offset+2, buffer_u8) & $3F;
    }
    else if ((_value & $F8) == $F0) //four-byte
    {
        _value  = (                                     _value & $07) << 18;
        _value += (buffer_peek(_buffer, _offset+1,  buffer_u8) & $3F) << 12;
        _value += (buffer_peek(_buffer, _offset+2,  buffer_u8) & $3F) <<  6;
        _value +=  buffer_peek(_buffer, _offset+3,  buffer_u8) & $3F;
    }
    
    return _value;
}