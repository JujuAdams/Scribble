/// @param element

global.__scribble_generator_state = {};

function __scribble_generate_model(_element)
{
    with(global.__scribble_generator_state)
    {
        element          = _element;
        glyph_count      = 0;
        control_count    = 0;
        word_count       = 0;
        line_count       = 0;
        line_height_min  = 0;
        line_height_max  = 0;
        model_max_width  = 0;
        model_max_height = 0;
        
        bezier_lengths_array = undefined;
    };
    
    var _string_buffer = global.__scribble_buffer;
    var _glyph_grid    = global.__scribble_glyph_grid;
    var _word_grid     = global.__scribble_word_grid;
    var _control_grid  = global.__scribble_control_grid; //This grid is cleared at the bottom of __scribble_generate_model()
    
    __scribble_generator_model_limits_and_bezier_curves()
    __scribble_generator_line_heights();
    __scribble_generator_parser();
    __scribble_generator_build_words();
    //Unpack generator state
    var _word_count = global.__scribble_generator_state.word_count;
    
    __scribble_generator_build_pages();
    
    
    
    #region Move glyphs relative to where their parent word is located
    
    var _i = 0;
    repeat(_word_count)
    {
        var _word_glyph_start = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.GLYPH_START];
        var _word_glyph_end   = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.GLYPH_END  ];
        
        if (_word_glyph_end - _word_glyph_start >= 0)
        {
            ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X, _word_grid[# _i, __SCRIBBLE_PARSER_WORD.X]);
            
            //x-axis is easy, the difficult bit is the y-axis
            //Basically, we want the glyph's top y-coordinate = word.y + (word.height - glyph.height)/2
            //Doing this in bulk using grid functions requires us to do this in four steps:
            //  1) glyph.y  = glyph.height
            //  2) glyph.y -= word.height + 2*word.y
            //  3) glyph.y *= -0.5
            //We have to do some funny stuff with the signs because it's not possible to subtract a region, only to add a region
            //Fortunately we can reverse some signs and get away with it!
            
            //FIXME - This is broken in runtime 23.1.1.385 (2021-09-26)
            //ds_grid_set_grid_region(_glyph_grid, _glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y);
            
            //FIXME - Workaround for the above. This is slower than using the ds_grid functions
            var _j = _word_glyph_start;
            repeat(1 + _word_glyph_end - _word_glyph_start)
            {
                _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.Y] = _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.HEIGHT];
                ++_j;
            }
            
            ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.Y, -_word_grid[# _i, __SCRIBBLE_PARSER_WORD.HEIGHT] - 2*_word_grid[# _i, __SCRIBBLE_PARSER_WORD.Y]);
            ds_grid_multiply_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.Y, -0.5);
        }
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Write glyphs to page vertex buffers
    
    if (is_array(global.__scribble_generator_state.bezier_lengths_array))
    {
        //Prep for Bezier curve shenanigans if necessary
        var _bezier_do              = true;
        var _bezier_lengths         = global.__scribble_generator_state.bezier_lengths_array;
        var _bezier_search_index    = 0;
        var _bezier_search_d0       = 0;
        var _bezier_search_d1       = _bezier_lengths[1];
        var _bezier_prev_cx         = 0;
        var _bezier_param_increment = 1 / (SCRIBBLE_BEZIER_ACCURACY-1);
    }
    else
    {
        _bezier_do = false;
    }
    
    var _control_index = 0;
    //We store the next control position as there are typically many more glyphs than controls
    //This ends up being quite a lot faster than continually reading from the grid
    var _next_control_pos = _control_grid[# 0, __SCRIBBLE_PARSER_CONTROL.POSITION];
    
    var _p = 0;
    repeat(pages)
    {
        var _page_data          = pages_array[_p];
        var _page_events_dict   = _page_data.__events;
        var _vbuff              = undefined;
        var _last_glyph_texture = undefined;
        var _glyph_sprite_data  = 0;
        var _character_index    = 0;
        
        buffer_seek(_string_buffer, buffer_seek_start, 0);
        
        var _i = _page_data.__glyph_start;
        repeat(1 + _page_data.__glyph_end - _page_data.__glyph_start)
        {
            __SCRIBBLE_READ_CONTROL_EVENTS;
            
            var _glyph_ord = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ORD];
            if (_glyph_ord == __SCRIBBLE_GLYPH_SPRITE)
            {
                #region Write sprite
                
                __SCRIBBLE_PARSER_READ_GLYPH_DATA;
                
                buffer_write(_string_buffer, buffer_u8, 0x1A); //Unicode/ASCII "substitute character"
                _character_index++;
                
                var _write_scale = _glyph_scale;
                                        
                var _sprite_index = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX];
                var _image_index  = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX];
                var _image_speed  = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED];
                var _glyph_width  = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.WIDTH      ]; //Already multiplied by the glyph scale
                var _glyph_height = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.HEIGHT     ]; //Already multiplied by the glyph scale
                
                if (SCRIBBLE_ADD_SPRITE_ORIGINS)
                {
                    _glyph_x += (_glyph_width  div 2) - _glyph_scale*sprite_get_xoffset(_sprite_index);
                    _glyph_y += (_glyph_height div 2) - _glyph_scale*sprite_get_yoffset(_sprite_index);
                }
                
                var _sprite_number = sprite_get_number(_sprite_index);
                if (_sprite_number >= 64)
                {
                    __scribble_trace("In-line sprites cannot have more than 64 frames (", sprite_get_name(_sprite_index), ")");
                    _sprite_number = 64;
                }
                
                if (_image_speed >= 4)
                {
                    __scribble_trace("Image speed cannot be more than 4.0 (" + string(_image_speed) + ")");
                    _image_speed = 4;
                }
                
                if (_image_speed < 0)
                {
                    __scribble_trace("Image speed cannot be less than 0.0 (" + string(_image_speed) + ")");
                    _image_speed = 0;
                }
                
                var _glyph_sprite_data = 4096*floor(1024*_image_speed) + 64*_sprite_number + _image_index;
                var _j = _image_index;
                repeat((_image_speed > 0)? _sprite_number : 1) //Only draw one image if we have an image speed of 0 since we're not animating
                {
                    var _glyph_texture = sprite_get_texture(_sprite_index, _j);
                    
                    var _uvs = sprite_get_uvs(_sprite_index, _j);
                    var _quad_u0 = _uvs[0];
                    var _quad_v0 = _uvs[1];
                    var _quad_u1 = _uvs[2];
                    var _quad_v1 = _uvs[3];
                    
                    var _quad_l = _glyph_x + _uvs[4]*_glyph_scale;
                    var _quad_t = _glyph_y + _uvs[5]*_glyph_scale;
                    var _quad_r = _quad_l  + _uvs[6]*_glyph_width;
                    var _quad_b = _quad_t  + _uvs[7]*_glyph_height;
                    
                    __SCRIBBLE_PARSER_WRITE_GLYPH;
                    
                    ++_j;
                    ++_glyph_sprite_data;
                }
                
                _glyph_sprite_data = 0; //Reset this because every other tyoe of glyph doesn't use this
                
                #endregion
            }
            else if (_glyph_ord == __SCRIBBLE_GLYPH_SURFACE)
            {
                #region Write surface
                
                __SCRIBBLE_PARSER_READ_GLYPH_DATA;
                
                buffer_write(_string_buffer, buffer_u8, 0x1A); //Unicode/ASCII "substitute character"
                _character_index++;
                
                var _write_scale = _glyph_scale;
                                       
                var _surface      = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX];
                var _glyph_width  = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.WIDTH      ]; //Already multiplied by the glyph scale
                var _glyph_height = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.HEIGHT     ]; //Already multiplied by the glyph scale
                
                var _glyph_texture = surface_get_texture(_surface);
                
                var _quad_u0 = 0;
                var _quad_v0 = 0;
                var _quad_u1 = 1;
                var _quad_v1 = 1;
                
                var _quad_l = _glyph_x;
                var _quad_t = _glyph_y;
                var _quad_r = _quad_l + _glyph_width;
                var _quad_b = _quad_t + _glyph_height;
                
                __SCRIBBLE_PARSER_WRITE_GLYPH;
                
                #endregion
            }
            else
            {
                __scribble_buffer_write_unicode(_string_buffer, _glyph_ord);
                _character_index++;
                
                if (_glyph_ord > 32)
                {
                    #region Write non-whitespace glyph
                    
                    __SCRIBBLE_PARSER_READ_GLYPH_DATA;
                    
                    
                    var _write_scale = _glyph_scale*_glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.FONT_SCALE_DIST]; //TODO - Optimise this
                    
                    var _glyph_data = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA];
                    var _glyph_texture = _glyph_data[SCRIBBLE_GLYPH.TEXTURE];
                    var _quad_u0 = _glyph_data[SCRIBBLE_GLYPH.U0];
                    var _quad_v0 = _glyph_data[SCRIBBLE_GLYPH.V0];
                    var _quad_u1 = _glyph_data[SCRIBBLE_GLYPH.U1];
                    var _quad_v1 = _glyph_data[SCRIBBLE_GLYPH.V1];
                    
                    //Add glyph to buffer
                    var _quad_l = _glyph_data[SCRIBBLE_GLYPH.X_OFFSET]*_glyph_scale + _glyph_x;
                    var _quad_t = _glyph_data[SCRIBBLE_GLYPH.Y_OFFSET]*_glyph_scale + _glyph_y;
                    var _quad_r = _glyph_data[SCRIBBLE_GLYPH.WIDTH   ]*_glyph_scale + _quad_l;
                    var _quad_b = _glyph_data[SCRIBBLE_GLYPH.HEIGHT  ]*_glyph_scale + _quad_t;
                    
                    __SCRIBBLE_PARSER_WRITE_GLYPH;
                    
                    #endregion
                }
            }
            
            ++_i;
        }
        
        __SCRIBBLE_READ_CONTROL_EVENTS;
        
        //Write a null terminator to finish off the string
        buffer_write(_string_buffer, buffer_u8, 0);
        buffer_seek(_string_buffer, buffer_seek_start, 0);
        _page_data.__text = buffer_read(_string_buffer, buffer_string);
        
        characters += _page_data.__character_count;
        
        ++_p;
    }
    
    #endregion
    
    
    
    //Ensure we've ended the vertex buffers we created
    __finalize_vertex_buffers(_element.freeze);
    
    
    
    //Wipe the control grid so we don't accidentally hold references to event structs
    ds_grid_clear(global.__scribble_control_grid, 0);
    
    
    
    return true;
}

function __scribble_buffer_read_unicode(_buffer)
{
    var _value = buffer_read(_buffer, buffer_u8); //Assume 0xxxxxxx
    
    if ((_value & $E0) == $C0) //110xxxxx 10xxxxxx
    {
        _value  = (                         _value & $1F) <<  6;
        _value += (buffer_read(_buffer, buffer_u8) & $3F);
    }
    else if ((_value & $F0) == $E0) //1110xxxx 10xxxxxx 10xxxxxx
    {
        _value  = (                         _value & $0F) << 12;
        _value += (buffer_read(_buffer, buffer_u8) & $3F) <<  6;
        _value +=  buffer_read(_buffer, buffer_u8) & $3F;
    }
    else if ((_value & $F8) == $F0) //11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
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
    var _value = buffer_peek(_buffer, _offset, buffer_u8); //Assume 0xxxxxxx
    
    if ((_value & $E0) == $C0) //110xxxxx 10xxxxxx
    {
        _value  = (                                    _value & $1F) <<  6;
        _value += (buffer_peek(_buffer, _offset+1, buffer_u8) & $3F);
    }
    else if ((_value & $F0) == $E0) //1110xxxx 10xxxxxx 10xxxxxx
    {
        _value  = (                                    _value & $0F) << 12;
        _value += (buffer_peek(_buffer, _offset+1, buffer_u8) & $3F) <<  6;
        _value +=  buffer_peek(_buffer, _offset+2, buffer_u8) & $3F;
    }
    else if ((_value & $F8) == $F0) //11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
    {
        _value  = (                                     _value & $07) << 18;
        _value += (buffer_peek(_buffer, _offset+1,  buffer_u8) & $3F) << 12;
        _value += (buffer_peek(_buffer, _offset+2,  buffer_u8) & $3F) <<  6;
        _value +=  buffer_peek(_buffer, _offset+3,  buffer_u8) & $3F;
    }
    
    return _value;
}

function __scribble_buffer_write_unicode(_buffer, _value)
{
    if (_value <= 0x7F) //0xxxxxxx
    {
        buffer_write(_buffer, buffer_u8, _value);
    }
    else if (_value <= 0x07FF) //110xxxxx 10xxxxxx
    {
        buffer_write(_buffer, buffer_u8, 0xC0 | ( _value       & 0x1F));
        buffer_write(_buffer, buffer_u8, 0x80 | ((_value >> 5) & 0x3F));
    }
    else if (_value <= 0xFFFF) //1110xxxx 10xxxxxx 10xxxxxx
    {
        buffer_write(_buffer, buffer_u8, 0xC0 | ( _value        & 0x0F));
        buffer_write(_buffer, buffer_u8, 0x80 | ((_value >>  4) & 0x3F));
        buffer_write(_buffer, buffer_u8, 0x80 | ((_value >> 10) & 0x3F));
    }
    else if (_value <= 0x10000) //11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
    {
        buffer_write(_buffer, buffer_u8, 0xC0 | ( _value        & 0x07));
        buffer_write(_buffer, buffer_u8, 0x80 | ((_value >>  3) & 0x3F));
        buffer_write(_buffer, buffer_u8, 0x80 | ((_value >>  9) & 0x3F));
        buffer_write(_buffer, buffer_u8, 0x80 | ((_value >> 15) & 0x3F));
    }
}