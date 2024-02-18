// @jujuadams
#macro __SCRIBBLE_VERSION           "9.0.0 Alpha"
#macro __SCRIBBLE_DATE              "2023-03-25"
#macro __SCRIBBLE_DEBUG             false
#macro __SCRIBBLE_VERBOSE_GC        false
#macro SCRIBBLE_LOAD_FONTS_ON_BOOT  true



__scribble_initialize();
if (SCRIBBLE_LOAD_FONTS_ON_BOOT) __scribble_font_add_all_from_project();



function __scribble_initialize()
{
    static _initialized = false;
    if (_initialized) return;
    _initialized = true;
    
    __scribble_trace("Welcome to Scribble by @jujuadams! This is version " + __SCRIBBLE_VERSION + ", " + __SCRIBBLE_DATE);
    
    if (SCRIBBLE_VERBOSE)
    {
        __scribble_trace("Verbose mode is on");
    }
    else
    {
        __scribble_trace("Verbose mode is off, set SCRIBBLE_VERBOSE to <true> to see more information");
    }
    
    try
    {
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            __scribble_tick();
        }, [], -1));
    }
    catch(_error)
    {
        __scribble_trace(_error);
        __scribble_error("Versions earlier than GameMaker 2022 LTS are not supported");
    }
    
    //Initialize statics on boot before they need to be used
    var _state = __scribble_get_state();
    
    //Initialize cycle open array
    var _open_array = _state.__cycle_open_array;
    var _i = 1;
    repeat(SCRIBBLE_CYCLE_COUNT)
    {
        _open_array[@ _i+1] = _i;
        ++_i;
    }
    
    __scribble_get_generator_state();
    __scribble_glyph_data_initialize();
    
    #region Initialize effects and typewriter events
    
    var _effects_dict       = _state.__effects_dict;
    var _effects_slash_dict = _state.__effects_slash_dict;
    
    //Add bindings for default effect names
    //Effect index 0 is reversed for sprites
    _effects_dict[$       "wave"    ] = 1;
    _effects_dict[$       "shake"   ] = 2;
    _effects_dict[$       "rainbow" ] = 3;
    _effects_dict[$       "wobble"  ] = 4;
    _effects_dict[$       "pulse"   ] = 5;
    _effects_dict[$       "wheel"   ] = 6;
    _effects_dict[$       "jitter"  ] = 7;
    _effects_dict[$       "blink"   ] = 8;
    _effects_dict[$       "slant"   ] = 9;
    _effects_slash_dict[$ "/wave"   ] = 1;
    _effects_slash_dict[$ "/shake"  ] = 2;
    _effects_slash_dict[$ "/rainbow"] = 3;
    _effects_slash_dict[$ "/wobble" ] = 4;
    _effects_slash_dict[$ "/pulse"  ] = 5;
    _effects_slash_dict[$ "/wheel"  ] = 6;
    _effects_slash_dict[$ "/jitter" ] = 7;
    _effects_slash_dict[$ "/blink"  ] = 8;
    _effects_slash_dict[$ "/slant"  ] = 9;
    
    _effects_dict[$       "WAVE"    ] = 1;
    _effects_dict[$       "SHAKE"   ] = 2;
    _effects_dict[$       "RAINBOW" ] = 3;
    _effects_dict[$       "WOBBLE"  ] = 4;
    _effects_dict[$       "PULSE"   ] = 5;
    _effects_dict[$       "WHEEL"   ] = 6;
    _effects_dict[$       "JITTER"  ] = 7;
    _effects_dict[$       "BLINK"   ] = 8;
    _effects_dict[$       "SLANT"   ] = 9;
    _effects_slash_dict[$ "/WAVE"   ] = 1;
    _effects_slash_dict[$ "/SHAKE"  ] = 2;
    _effects_slash_dict[$ "/RAINBOW"] = 3;
    _effects_slash_dict[$ "/WOBBLE" ] = 4;
    _effects_slash_dict[$ "/PULSE"  ] = 5;
    _effects_slash_dict[$ "/WHEEL"  ] = 6;
    _effects_slash_dict[$ "/JITTER" ] = 7;
    _effects_slash_dict[$ "/BLINK"  ] = 8;
    _effects_slash_dict[$ "/SLANT"  ] = 9;
    
    var _typewriter_event_dict = __scribble_get_state().__typewriter_events_dict;
    _typewriter_event_dict[$ "pause" ] = undefined;
    _typewriter_event_dict[$ "delay" ] = undefined;
    _typewriter_event_dict[$ "sync"  ] = undefined;
    _typewriter_event_dict[$ "speed" ] = undefined;
    _typewriter_event_dict[$ "/speed"] = undefined;
    
    #endregion
    
    __scribble_krutidev_lookup_map_initialize();
    __scribble_krutidev_matra_lookup_map_initialize();
    
    scribble_anim_reset();
}



#region Functions

function __scribble_trace()
{
    var _string = "Scribble: ";
    
    var _i = 0
    repeat(argument_count)
    {
        var _value = argument[_i];
        
        if (is_numeric(_value) && (floor(_value) != _value))
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
    var _string = "Scribble:\n";
    
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
    
    show_debug_message("Scribble " + __SCRIBBLE_VERSION + ": " + string_replace_all(_string, "\n", "\n          "));
    show_error("Scribble:\n" + _string + "\n ", true);
}

function __scribble_get_font_data(_name)
{
    static _font_data_map = __scribble_get_state().__font_data_map;
    var _data = _font_data_map[? _name];
    if (_data == undefined) __scribble_error("Font \"", _name, "\" not recognised");
    return _data;
}

function __scribble_process_colour(_value)
{
    static _colours_struct = __scribble_get_state().__custom_colour_struct;
    
    if (is_string(_value))
    {
        if (!variable_struct_exists(_colours_struct, _value))
        {
            __scribble_error("Colour \"", _value, "\" not recognised");
        }
        
        return (_colours_struct[$ _value] & 0xFFFFFF);
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

#endregion



#region Generator Enums

enum __SCRIBBLE_GEN_GLYPH
{
    __UNICODE,              // 0  \   Can be negative, see below
    __BIDI,                 // 1   |
                            //     |
    __X,                    // 2   |
    __Y,                    // 3   |
    __WIDTH,                // 4   |
    __HEIGHT,               // 5   |
    __FONT_HEIGHT,          // 6   |
    __SEPARATION,           // 7   |
    __LEFT_OFFSET,          // 8   | This group of enums must not change order or be split
                            //     |
    __MATERIAL,             // 9   |
    __QUAD_U0,              //10   | Be careful of ordering!
    __QUAD_U1,              //11   | scribble_font_bake_effects() relies on this
    __QUAD_V0,              //12   |
    __QUAD_V1,              //13  /
    
    __CONTROL_COUNT,        //14
    __ANIMATION_INDEX,      //15
    __SPRITE_DATA,          //16     Only used for sprites and surfaces
                      
    __SIZE,                 //17
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
    __STARTS_MANUAL_PAGE, //7
    __SIZE,               //8
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
#macro __SCRIBBLE_DEFAULT_SDF_SPREAD   8

#macro __SCRIBBLE_AUDIO_COMMAND_TAG                    "__scribble_audio_playback__"
#macro __SCRIBBLE_TYPIST_SOUND_COMMAND_TAG             "__scribble_typist_sound__"
#macro __SCRIBBLE_TYPIST_SOUND_PER_CHAR_COMMAND_TAG    "__scribble_typist_sound_per_char__"

#macro SCRIBBLE_DEVANAGARI_OFFSET  0xFFFF //This probably won't work for any other value

#macro __SCRIBBLE_MAX_LINES  1000  //Maximum number of lines in a textbox. This constant must match the corresponding values in __shd_scribble

#endregion
