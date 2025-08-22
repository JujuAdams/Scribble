// Feather disable all

function __scribble_trace()
{
    var _string = "ScribbleDX: ";
    
    var _i = 0
    repeat(argument_count)
    {
        if (is_real(argument[_i]))
        {
            _string += string_format(argument[_i], 0, 4);
        }
        else
        {
            _string += string(argument[_i]);
        }
        
        ++_i;
    }
    
    show_debug_message(_string);
}

function __scribble_loud()
{
    var _string = "Scribble Deluxe:\n";
    
    var _i = 0
    repeat(argument_count)
    {
        if (is_real(argument[_i]))
        {
            _string += string_format(argument[_i], 0, 4);
        }
        else
        {
            _string += string(argument[_i]);
        }
        
        ++_i;
    }
    
    show_debug_message(_string);
    show_message(_string);
}

function __scribble_error()
{
    var _string = "";
    
    var _i = 0
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message("Scribble Deluxe " + SCRIBBLE_VERSION + ": " + string_replace_all(_string, "\n", "\n          "));
    show_error(" \nScribble Deluxe " + SCRIBBLE_VERSION + ":\n" + _string + "\n ", true);
}

function __scribble_get_font_data(_name)
{
    static _font_data_map = __scribble_system().__font_data_map;
    var _data = _font_data_map[? _name];
    if (_data == undefined)
    {
        var _string = "Font \"" + string(_name) + "\" not recognised";
        
        if (__scribble_system().__gmMightRemoveUnusedAssets)
        {
            _string += "\nThis may indicate that unused assets have been stripped from the project\nPlease untick \"Automatically remove unused assets when compiling\" in Game Options";
        }
        
        __scribble_error(_string);
    }
    
    return _data;
}

function __scribble_process_colour(_value)
{
    static _colors_struct = __scribble_config_colours();
    
    if (is_string(_value))
    {
        if (!variable_struct_exists(_colors_struct, _value))
        {
            __scribble_error("Colour \"", _value, "\" not recognised. Please add it to __scribble_config_colours()");
        }
        
        return (_colors_struct[$ _value] & 0xFFFFFF);
    }
    else
    {
        return _value;
    }
}

function __scribble_random()
{
    static _lcg = date_current_datetime()*100;
    _lcg = (48271*_lcg) mod 2147483647; //Lehmer
    return _lcg / 2147483648;
}

function __scribble_array_find_index(_array, _value)
{
    var _i = 0;
    repeat(array_length(_array))
    {
        if (_array[_i] == _value) return _i;
        ++_i;
    }
    
    return -1;
}
 
function __scribble_asset_is_krutidev(_asset, _asset_type)
{
    var _tags_array = asset_get_tags(_asset, _asset_type);
    var _i = 0;
    repeat(array_length(_tags_array))
    {
        var _tag = _tags_array[_i];
        if ((_tag == "scribble krutidev") || (_tag == "Scribble krutidev") || (_tag == "Scribble Krutidev")) return true;
        ++_i;
    }
    
    return false;
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

function __scribble_image_speed_get(_sprite)
{
    return (sprite_get_speed_type(_sprite) == spritespeed_framespergameframe)? sprite_get_speed(_sprite) : (sprite_get_speed(_sprite) / game_get_speed(gamespeed_fps));
}

function __scribble_matrix_inverse(_matrix)
{
    var _inv = array_create(16, undefined);

    _inv[@  0] =  _matrix[5]  * _matrix[10] * _matrix[15] - 
                  _matrix[5]  * _matrix[11] * _matrix[14] - 
                  _matrix[9]  * _matrix[6]  * _matrix[15] + 
                  _matrix[9]  * _matrix[7]  * _matrix[14] +
                  _matrix[13] * _matrix[6]  * _matrix[11] - 
                  _matrix[13] * _matrix[7]  * _matrix[10];
                
    _inv[@  4] = -_matrix[4]  * _matrix[10] * _matrix[15] + 
                  _matrix[4]  * _matrix[11] * _matrix[14] + 
                  _matrix[8]  * _matrix[6]  * _matrix[15] - 
                  _matrix[8]  * _matrix[7]  * _matrix[14] - 
                  _matrix[12] * _matrix[6]  * _matrix[11] + 
                  _matrix[12] * _matrix[7]  * _matrix[10];
                
    _inv[@  8] =  _matrix[4]  * _matrix[9] * _matrix[15] - 
                  _matrix[4]  * _matrix[11] * _matrix[13] - 
                  _matrix[8]  * _matrix[5] * _matrix[15] + 
                  _matrix[8]  * _matrix[7] * _matrix[13] + 
                  _matrix[12] * _matrix[5] * _matrix[11] - 
                  _matrix[12] * _matrix[7] * _matrix[9];
                
    _inv[@ 12] = -_matrix[4]  * _matrix[9] * _matrix[14] + 
                  _matrix[4]  * _matrix[10] * _matrix[13] +
                  _matrix[8]  * _matrix[5] * _matrix[14] - 
                  _matrix[8]  * _matrix[6] * _matrix[13] - 
                  _matrix[12] * _matrix[5] * _matrix[10] + 
                  _matrix[12] * _matrix[6] * _matrix[9];
                
    _inv[@  1] = -_matrix[1]  * _matrix[10] * _matrix[15] + 
                  _matrix[1]  * _matrix[11] * _matrix[14] + 
                  _matrix[9]  * _matrix[2] * _matrix[15] - 
                  _matrix[9]  * _matrix[3] * _matrix[14] - 
                  _matrix[13] * _matrix[2] * _matrix[11] + 
                  _matrix[13] * _matrix[3] * _matrix[10];
                
    _inv[@  5] =  _matrix[0]  * _matrix[10] * _matrix[15] - 
                  _matrix[0]  * _matrix[11] * _matrix[14] - 
                  _matrix[8]  * _matrix[2] * _matrix[15] + 
                  _matrix[8]  * _matrix[3] * _matrix[14] + 
                  _matrix[12] * _matrix[2] * _matrix[11] - 
                  _matrix[12] * _matrix[3] * _matrix[10];
                
    _inv[@  9] = -_matrix[0]  * _matrix[9] * _matrix[15] + 
                  _matrix[0]  * _matrix[11] * _matrix[13] + 
                  _matrix[8]  * _matrix[1] * _matrix[15] - 
                  _matrix[8]  * _matrix[3] * _matrix[13] - 
                  _matrix[12] * _matrix[1] * _matrix[11] + 
                  _matrix[12] * _matrix[3] * _matrix[9];
                
    _inv[@ 13] =  _matrix[0]  * _matrix[9] * _matrix[14] - 
                  _matrix[0]  * _matrix[10] * _matrix[13] - 
                  _matrix[8]  * _matrix[1] * _matrix[14] + 
                  _matrix[8]  * _matrix[2] * _matrix[13] + 
                  _matrix[12] * _matrix[1] * _matrix[10] - 
                  _matrix[12] * _matrix[2] * _matrix[9];
                
    _inv[@  2] =  _matrix[1]  * _matrix[6] * _matrix[15] - 
                  _matrix[1]  * _matrix[7] * _matrix[14] - 
                  _matrix[5]  * _matrix[2] * _matrix[15] + 
                  _matrix[5]  * _matrix[3] * _matrix[14] + 
                  _matrix[13] * _matrix[2] * _matrix[7] - 
                  _matrix[13] * _matrix[3] * _matrix[6];
                
    _inv[@  6] = -_matrix[0]  * _matrix[6] * _matrix[15] + 
                  _matrix[0]  * _matrix[7] * _matrix[14] + 
                  _matrix[4]  * _matrix[2] * _matrix[15] - 
                  _matrix[4]  * _matrix[3] * _matrix[14] - 
                  _matrix[12] * _matrix[2] * _matrix[7] + 
                  _matrix[12] * _matrix[3] * _matrix[6];
                
    _inv[@ 10] =  _matrix[0]  * _matrix[5] * _matrix[15] - 
                  _matrix[0]  * _matrix[7] * _matrix[13] - 
                  _matrix[4]  * _matrix[1] * _matrix[15] + 
                  _matrix[4]  * _matrix[3] * _matrix[13] + 
                  _matrix[12] * _matrix[1] * _matrix[7] - 
                  _matrix[12] * _matrix[3] * _matrix[5];
                
    _inv[@ 14] = -_matrix[0]  * _matrix[5] * _matrix[14] + 
                  _matrix[0]  * _matrix[6] * _matrix[13] + 
                  _matrix[4]  * _matrix[1] * _matrix[14] - 
                  _matrix[4]  * _matrix[2] * _matrix[13] - 
                  _matrix[12] * _matrix[1] * _matrix[6] + 
                  _matrix[12] * _matrix[2] * _matrix[5];
                
    _inv[@  3] = -_matrix[1] * _matrix[6] * _matrix[11] + 
                  _matrix[1] * _matrix[7] * _matrix[10] + 
                  _matrix[5] * _matrix[2] * _matrix[11] - 
                  _matrix[5] * _matrix[3] * _matrix[10] - 
                  _matrix[9] * _matrix[2] * _matrix[7] + 
                  _matrix[9] * _matrix[3] * _matrix[6];
                
    _inv[@  7] =  _matrix[0] * _matrix[6] * _matrix[11] - 
                  _matrix[0] * _matrix[7] * _matrix[10] - 
                  _matrix[4] * _matrix[2] * _matrix[11] + 
                  _matrix[4] * _matrix[3] * _matrix[10] + 
                  _matrix[8] * _matrix[2] * _matrix[7] - 
                  _matrix[8] * _matrix[3] * _matrix[6];
                
    _inv[@ 11] = -_matrix[0] * _matrix[5] * _matrix[11] + 
                  _matrix[0] * _matrix[7] * _matrix[9] + 
                  _matrix[4] * _matrix[1] * _matrix[11] - 
                  _matrix[4] * _matrix[3] * _matrix[9] - 
                  _matrix[8] * _matrix[1] * _matrix[7] + 
                  _matrix[8] * _matrix[3] * _matrix[5];
                
    _inv[@ 15] =  _matrix[0] * _matrix[5] * _matrix[10] - 
                  _matrix[0] * _matrix[6] * _matrix[9] - 
                  _matrix[4] * _matrix[1] * _matrix[10] + 
                  _matrix[4] * _matrix[2] * _matrix[9] + 
                  _matrix[8] * _matrix[1] * _matrix[6] - 
                  _matrix[8] * _matrix[2] * _matrix[5];

    var _det = _matrix[0]*_inv[0] + _matrix[1]*_inv[4] + _matrix[2]*_inv[8] + _matrix[3]*_inv[12];
    if (_det == 0)
    {
        __scribble_trace("Warning! Determinant of the matrix is zero");
        return _matrix;
    }

    _det = 1 / _det;
    
    _inv[@  0] *= _det;
    _inv[@  1] *= _det;
    _inv[@  2] *= _det;
    _inv[@  3] *= _det;
    _inv[@  4] *= _det;
    _inv[@  5] *= _det;
    _inv[@  6] *= _det;
    _inv[@  7] *= _det;
    _inv[@  8] *= _det;
    _inv[@  9] *= _det;
    _inv[@ 10] *= _det;
    _inv[@ 11] *= _det;
    _inv[@ 12] *= _det;
    _inv[@ 13] *= _det;
    _inv[@ 14] *= _det;
    _inv[@ 15] *= _det;

    return _inv;
}

#region Enums

#macro __SCRIBBLE_GLYPH_LAYOUT_UNICODE   0
#macro __SCRIBBLE_GLYPH_LAYOUT_LEFT      1
#macro __SCRIBBLE_GLYPH_LAYOUT_TOP       2
#macro __SCRIBBLE_GLYPH_LAYOUT_RIGHT     3
#macro __SCRIBBLE_GLYPH_LAYOUT_BOTTOM    4
#macro __SCRIBBLE_GLYPH_LAYOUT_Y_OFFSET  5
#macro __SCRIBBLE_GLYPH_LAYOUT_SIZE      6

#macro __SCRIBBLE_RENDER_RASTER               0
#macro __SCRIBBLE_RENDER_RASTER_WITH_EFFECTS  1
#macro __SCRIBBLE_RENDER_SDF                  2

#macro __SCRIBBLE_ANIM_WAVE_SIZE        0
#macro __SCRIBBLE_ANIM_WAVE_FREQ        1
#macro __SCRIBBLE_ANIM_WAVE_SPEED       2
#macro __SCRIBBLE_ANIM_SHAKE_SIZE       3
#macro __SCRIBBLE_ANIM_SHAKE_SPEED      4
#macro __SCRIBBLE_ANIM_WOBBLE_ANGLE     5
#macro __SCRIBBLE_ANIM_WOBBLE_FREQ      6
#macro __SCRIBBLE_ANIM_PULSE_SCALE      7
#macro __SCRIBBLE_ANIM_PULSE_SPEED      8
#macro __SCRIBBLE_ANIM_WHEEL_SIZE       9
#macro __SCRIBBLE_ANIM_WHEEL_FREQ      10
#macro __SCRIBBLE_ANIM_WHEEL_SPEED     11
#macro __SCRIBBLE_ANIM_JITTER_MINIMUM  12
#macro __SCRIBBLE_ANIM_JITTER_MAXIMUM  13
#macro __SCRIBBLE_ANIM_JITTER_SPEED    14
#macro __SCRIBBLE_ANIM_SLANT_GRADIENT  15
#macro __SCRIBBLE_ANIM_SIZE            16

#endregion



#region Generator Enums

#macro __SCRIBBLE_GEN_GLYPH_UNICODE           0 //  \  - Can be negative if a glyph is sprite/surface/texture
#macro __SCRIBBLE_GEN_GLYPH_BIDI              1 //   |
#macro __SCRIBBLE_GEN_GLYPH_X                 2 //   |
#macro __SCRIBBLE_GEN_GLYPH_Y                 3 //   |
#macro __SCRIBBLE_GEN_GLYPH_WIDTH             4 //   |
#macro __SCRIBBLE_GEN_GLYPH_HEIGHT            5 //   |
#macro __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT       6 //   |
#macro __SCRIBBLE_GEN_GLYPH_SEPARATION        7 //   |  This group of enum elements must not change order or be split
#macro __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET       8 //   |  Be careful of ordering!
#macro __SCRIBBLE_GEN_GLYPH_SCALE             9 //   |  scribble_font_bake_shader() relies on this
#macro __SCRIBBLE_GEN_GLYPH_MATERIAL         10 //   |
#macro __SCRIBBLE_GEN_GLYPH_QUAD_U0          11 //   |
#macro __SCRIBBLE_GEN_GLYPH_QUAD_U1          12 //   |
#macro __SCRIBBLE_GEN_GLYPH_QUAD_V0          13 //   |
#macro __SCRIBBLE_GEN_GLYPH_QUAD_V1          14 //  /
#macro __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT    15 //
#macro __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX  16 //
#macro __SCRIBBLE_GEN_GLYPH_SPRITE_INDEX     17 //  \
#macro __SCRIBBLE_GEN_GLYPH_IMAGE_INDEX      18 //   | Only used for sprites
#macro __SCRIBBLE_GEN_GLYPH_IMAGE_SPEED      19 //  /
#macro __SCRIBBLE_GEN_GLYPH_SIZE             20 //

#macro __SCRIBBLE_GEN_VBUFF_POS_QUAD_L  0
#macro __SCRIBBLE_GEN_VBUFF_POS_QUAD_T  1
#macro __SCRIBBLE_GEN_VBUFF_POS_QUAD_R  2
#macro __SCRIBBLE_GEN_VBUFF_POS_QUAD_B  3
#macro __SCRIBBLE_GEN_VBUFF_POS_SIZE    4

#macro __SCRIBBLE_GEN_CONTROL_TYPE_EVENT         0
#macro __SCRIBBLE_GEN_CONTROL_TYPE_HALIGN        1
#macro __SCRIBBLE_GEN_CONTROL_TYPE_COLOUR        2
#macro __SCRIBBLE_GEN_CONTROL_TYPE_EFFECT        3
#macro __SCRIBBLE_GEN_CONTROL_TYPE_CYCLE         4
#macro __SCRIBBLE_GEN_CONTROL_TYPE_REGION        5
#macro __SCRIBBLE_GEN_CONTROL_TYPE_FONT          6
#macro __SCRIBBLE_GEN_CONTROL_TYPE_INDENT_START  7
#macro __SCRIBBLE_GEN_CONTROL_TYPE_INDENT_STOP   8

//These can be used for ORD
#macro __SCRIBBLE_GLYPH_REPL_SPRITE   -1
#macro __SCRIBBLE_GLYPH_REPL_SURFACE  -2
#macro __SCRIBBLE_GLYPH_REPL_TEXTURE  -3

#macro __SCRIBBLE_GEN_CONTROL_TYPE  0
#macro __SCRIBBLE_GEN_CONTROL_DATA  1
#macro __SCRIBBLE_GEN_CONTROL_SIZE  2

#macro __SCRIBBLE_GEN_WORD_BIDI_RAW     0
#macro __SCRIBBLE_GEN_WORD_BIDI         1
#macro __SCRIBBLE_GEN_WORD_GLYPH_START  2
#macro __SCRIBBLE_GEN_WORD_GLYPH_END    3
#macro __SCRIBBLE_GEN_WORD_WIDTH        4
#macro __SCRIBBLE_GEN_WORD_HEIGHT       5
#macro __SCRIBBLE_GEN_WORD_SIZE         6

#macro __SCRIBBLE_GEN_STRETCH_WORD_START  0
#macro __SCRIBBLE_GEN_STRETCH_WORD_END    1
#macro __SCRIBBLE_GEN_STRETCH_BIDI        2
#macro __SCRIBBLE_GEN_STRETCH_SIZE        3

#macro __SCRIBBLE_GEN_LINE_X                   0
#macro __SCRIBBLE_GEN_LINE_Y                   1
#macro __SCRIBBLE_GEN_LINE_WORD_START          2
#macro __SCRIBBLE_GEN_LINE_WORD_END            3
#macro __SCRIBBLE_GEN_LINE_WIDTH               4
#macro __SCRIBBLE_GEN_LINE_HALIGN              5
#macro __SCRIBBLE_GEN_LINE_DISABLE_JUSTIFY     6
#macro __SCRIBBLE_GEN_LINE_STARTS_MANUAL_PAGE  7
#macro __SCRIBBLE_GEN_LINE_FORCED_BREAK        8
#macro __SCRIBBLE_GEN_LINE_SIZE                9

#endregion



#region Misc Macros

#macro __SCRIBBLE_ON_DIRECTX           ((os_type == os_windows) || (os_type == os_xboxone) || (os_type == os_xboxseriesxs) || (os_type == os_uwp) || (os_type == os_win8native) || (os_type == os_winphone) || (os_type == os_operagx))
#macro __SCRIBBLE_ON_MOBILE            ((os_type == os_ios) || (os_type == os_android) || (os_type == os_tvos))
#macro __SCRIBBLE_ON_WEB               (os_browser != browser_not_a_browser)
#macro __SCRIBBLE_ON_OPENGL            (!__SCRIBBLE_ON_DIRECTX || __SCRIBBLE_ON_WEB)
#macro __SCRIBBLE_FIX_ARGB             (__SCRIBBLE_ON_OPENGL && (os_type != os_switch))
#macro __SCRIBBLE_EXPECTED_FRAME_TIME  (0.95*game_get_speed(gamespeed_microseconds)/1000) //Uses to prevent the autotype from advancing if a draw call is made multiple times a frame to the same text element
#macro __SCRIBBLE_PIN_LEFT             3
#macro __SCRIBBLE_PIN_CENTRE           4
#macro __SCRIBBLE_PIN_RIGHT            5
#macro __SCRIBBLE_FA_JUSTIFY           6
#macro __SCRIBBLE_WINDOW_COUNT         3
#macro __SCRIBBLE_GC_STEP_SIZE         3
#macro __SCRIBBLE_CACHE_TIMEOUT        10 //How long to wait (in frames) before the text element cache automatically cleans up unused data

#macro __SCRIBBLE_AUDIO_COMMAND_TAG                    "__scribble_audio_playback__"
#macro __SCRIBBLE_TYPIST_SOUND_COMMAND_TAG             "__scribble_typist_sound__"
#macro __SCRIBBLE_TYPIST_SOUND_PER_CHAR_COMMAND_TAG    "__scribble_typist_sound_per_char__"

#macro __SCRIBBLE_DEVANAGARI_OFFSET  0xFFFF //This probably won't work for any other value

#macro __SCRIBBLE_MAX_LINES  1000  //Maximum number of lines in a textbox. This constant must match the corresponding values in __shd_scribble

#endregion