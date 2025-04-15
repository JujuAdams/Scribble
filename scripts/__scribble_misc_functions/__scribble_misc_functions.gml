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
    static _font_data_map = __scribble_initialize().__font_data_map;
    var _data = _font_data_map[? _name];
    if (_data == undefined)
    {
        var _string = "Font \"" + string(_name) + "\" not recognised";
        
        if (__scribble_initialize().__gmMightRemoveUnusedAssets)
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

enum __SCRIBBLE_GLYPH_LAYOUT
{
    __UNICODE, // 0
    __LEFT,    // 1
    __TOP,     // 2
    __RIGHT,   // 3
    __BOTTOM,  // 4
    __SIZE,    // 5
}

#macro __SCRIBBLE_RENDER_RASTER               0
#macro __SCRIBBLE_RENDER_RASTER_WITH_EFFECTS  1
#macro __SCRIBBLE_RENDER_SDF                  2

enum __SCRIBBLE_ANIM
{
    __WAVE_SIZE,        // 0
    __WAVE_FREQ,        // 1
    __WAVE_SPEED,       // 2
    __SHAKE_SIZE,       // 3
    __SHAKE_SPEED,      // 4
    __RAINBOW_WEIGHT,   // 5
    __RAINBOW_SPEED,    // 6
    __WOBBLE_ANGLE,     // 7
    __WOBBLE_FREQ,      // 8
    __PULSE_SCALE,      // 9
    __PULSE_SPEED,      //10
    __WHEEL_SIZE,       //11
    __WHEEL_FREQ,       //12
    __WHEEL_SPEED,      //13
    __CYCLE_SPEED,      //14
    __CYCLE_SATURATION, //15
    __CYCLE_VALUE,      //16
    __JITTER_MINIMUM,   //17
    __JITTER_MAXIMUM,   //18
    __JITTER_SPEED,     //19
    __SLANT_GRADIENT,   //20
    __SIZE,             //21
}

#endregion



#region Generator Enums

enum __SCRIBBLE_GEN_GLYPH
{
    __UNICODE,               // 0  \  - Can be negative if a glyph is sprite/surface/texture
    __BIDI,                  // 1   |
                             //     |
    __X,                     // 2   |
    __Y,                     // 3   |
    __WIDTH,                 // 4   |
    __HEIGHT,                // 5   |
    __FONT_HEIGHT,           // 6   |
    __SEPARATION,            // 7   |  This group of enum elements must not change order or be split
    __LEFT_OFFSET,           // 8   |  Be careful of ordering!
    __SCALE,                 // 9   |  scribble_font_bake_shader() relies on this
                             //     |
    __MATERIAL,              //10   |
    __QUAD_U0,               //11   |
    __QUAD_U1,               //12   |
    __QUAD_V0,               //13   |
    __QUAD_V1,               //14  /
    
    __CONTROL_COUNT,         //15
    __ANIMATION_INDEX,       //16
                      
    __SPRITE_INDEX,          //17  \
    __IMAGE_INDEX,           //18   | Only used for sprites
    __IMAGE_SPEED,           //19  /
                      
    __SIZE,                  //20
}

enum __SCRIBBLE_GEN_VBUFF_POS
{
    __QUAD_L, //0
    __QUAD_T, //1
    __QUAD_R, //2
    __QUAD_B, //3
    __SIZE,   //4
}

enum __SCRIBBLE_GEN_CONTROL_TYPE
{
    __EVENT,        //0
    __HALIGN,       //1
    __COLOUR,       //2
    __EFFECT,       //3
    __CYCLE,        //4
    __REGION,       //5
    __FONT,         //6
    __INDENT_START, //7
    __INDENT_STOP,  //8
}

//These can be used for ORD
#macro  __SCRIBBLE_GLYPH_SPRITE   -1
#macro  __SCRIBBLE_GLYPH_SURFACE  -2
#macro  __SCRIBBLE_GLYPH_TEXTURE  -3

enum __SCRIBBLE_GEN_CONTROL
{
    __TYPE, //0
    __DATA, //1
    __SIZE, //2
}

enum __SCRIBBLE_GEN_WORD
{
    __BIDI_RAW,    //0
    __BIDI,        //1
    __GLYPH_START, //2
    __GLYPH_END,   //3
    __WIDTH,       //4
    __HEIGHT,      //5
    __SIZE,        //6
}

enum __SCRIBBLE_GEN_STRETCH
{
    __WORD_START, //0
    __WORD_END,   //1
    __BIDI,       //2
    __SIZE,
}

enum __SCRIBBLE_GEN_LINE
{
    __X,                  //0
    __Y,                  //1
    __WORD_START,         //2
    __WORD_END,           //3
    __WIDTH,              //4
    __HEIGHT,             //5
    __HALIGN,             //6
    __DISABLE_JUSTIFY,    //7
    __STARTS_MANUAL_PAGE, //8
    __SIZE,               //9
}

#endregion



#region Misc Macros

#macro __SCRIBBLE_ON_DIRECTX           ((os_type == os_windows) || (os_type == os_xboxone) || (os_type == os_xboxseriesxs) || (os_type == os_uwp) || (os_type == os_win8native) || (os_type == os_winphone) || (os_type == os_operagx))
#macro __SCRIBBLE_ON_MOBILE            ((os_type == os_ios) || (os_type == os_android) || (os_type == os_tvos))
#macro __SCRIBBLE_ON_WEB               (os_browser != browser_not_a_browser)
#macro __SCRIBBLE_ON_OPENGL            (!__SCRIBBLE_ON_DIRECTX || __SCRIBBLE_ON_WEB)
#macro __SCRIBBLE_FIX_ARGB             (__SCRIBBLE_ON_OPENGL)
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