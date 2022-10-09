// @jujuadams
#macro __SCRIBBLE_VERSION           "8.0.9"
#macro __SCRIBBLE_DATE              "2022-10-09"
#macro __SCRIBBLE_DEBUG             false
#macro __SCRIBBLE_VERBOSE_GC        false
#macro SCRIBBLE_LOAD_FONTS_ON_BOOT  true



#region Pre-Initialization Checks

var _font_directory = SCRIBBLE_INCLUDED_FILES_SUBDIRECTORY;

//If we've already initialized, don't try to do it again
if (variable_global_exists("__scribble_lcg")) return undefined;

__scribble_trace("Welcome to Scribble by @jujuadams! This is version " + __SCRIBBLE_VERSION + ", " + __SCRIBBLE_DATE);

if (SCRIBBLE_VERBOSE)
{
    __scribble_trace("Verbose mode is on");
}
else
{
    __scribble_trace("Verbose mode is off, set SCRIBBLE_VERBOSE to <true> to see more information");
}

__scribble_system_glyph_data();

if (__SCRIBBLE_ON_MOBILE)
{
    if (_font_directory != "")
    {
        __scribble_error("GameMaker's Included Files work a bit strangely on iOS and Android.\nPlease use an empty string for the font directory and place fonts in the root of Included Files");
        exit;
    }
}
else if (__SCRIBBLE_ON_WEB)
{
    if (_font_directory != "")
    {
        __scribble_trace("Using folders inside Included Files might not work properly on HTML5. If you're having trouble, try using an empty string for the font directory and place fonts in the root of Included Files.");
    }
}
    
if (_font_directory != "")
{
    //Fix the font directory name if it's weird
    var _char = string_char_at(_font_directory, string_length(_font_directory));
    if (_char != "\\") && (_char != "/") _font_directory += "\\";
    
    __scribble_trace("Using font directory \"", _font_directory, "\"");
}
    
if (!__SCRIBBLE_ON_WEB)
{
    //Check if the directory exists
    if ((_font_directory != "") && !directory_exists(_font_directory))
    {
        __scribble_trace("Warning! Font directory \"" + string(_font_directory) + "\" could not be found in \"" + game_save_id + "\"!");
    }
}

#endregion



#region Initialization
    
//Declare global variables
global.__scribble_lcg                  = date_current_datetime()*100;
global.__scribble_font_directory       = _font_directory;
global.__scribble_font_data            = ds_map_create();  //Stores a data array for each font defined inside Scribble
global.__scribble_effects              = ds_map_create();  //Bidirectional lookup - stores name:index as well as index:name
global.__scribble_effects_slash        = ds_map_create();  //Bidirectional lookup - stores name:index as well as index:name
global.__scribble_external_sound_map   = ds_map_create();
global.__scribble_tex_index_lookup_map = ds_map_create();
global.__scribble_default_font         = "scribble_fallback_font";
global.__scribble_buffer               = buffer_create(1024, buffer_grow, 1);
global.__scribble_glyph_grid           = ds_grid_create(1000, __SCRIBBLE_GEN_GLYPH.__SIZE);
global.__scribble_control_grid         = ds_grid_create(1000, __SCRIBBLE_GEN_CONTROL.__SIZE);
global.__scribble_word_grid            = ds_grid_create(1000, __SCRIBBLE_GEN_WORD.__SIZE);
global.__scribble_line_grid            = ds_grid_create(__SCRIBBLE_MAX_LINES, __SCRIBBLE_GEN_LINE.__SIZE);
global.__scribble_stretch_grid         = ds_grid_create(1000, __SCRIBBLE_GEN_STRETCH.__SIZE);
global.__scribble_temp_grid            = ds_grid_create(1000, __SCRIBBLE_GEN_WORD.__SIZE); //For some reason, changing the width of this grid causes GM to crash
global.__scribble_temp2_grid           = ds_grid_create(1000, __SCRIBBLE_GEN_GLYPH.__SIZE);
global.__scribble_vbuff_pos_grid       = ds_grid_create(1000, __SCRIBBLE_GEN_VBUFF_POS.__SIZE);

//Give us 1 second breathing room when booting up before trying to garbage collect
global.__scribble_cache_check_time = current_time + 1000;

global.__scribble_null_element = new __scribble_class_null_element();

global.__scribble_mcache_dict       = {};
global.__scribble_mcache_name_array = [];
global.__scribble_mcache_name_index = 0;

global.__scribble_ecache_dict       = {};
global.__scribble_ecache_array      = [];
global.__scribble_ecache_list_index = 0;
global.__scribble_ecache_name_array = [];
global.__scribble_ecache_name_index = 0;

global.__scribble_gc_vbuff_index = 0;
global.__scribble_gc_vbuff_refs  = [];
global.__scribble_gc_vbuff_ids   = [];

global.__scribble_generator_state = {};
if (__SCRIBBLE_ON_WEB) global.__scribble_html5_sprite_height_workaround = {};

if (!variable_global_exists("__scribble_colours")) __scribble_config_colours();

if (!variable_global_exists("__scribble_typewriter_events")) global.__scribble_typewriter_events = ds_map_create();
global.__scribble_typewriter_events[? "pause" ] = undefined;
global.__scribble_typewriter_events[? "delay" ] = undefined;
global.__scribble_typewriter_events[? "speed" ] = undefined;
global.__scribble_typewriter_events[? "/speed"] = undefined;

//Hashtable to accelerate command tag lookup
var _map = ds_map_create();
_map[? ""          ] =  0;
_map[? "/"         ] =  0;
_map[? "/font"     ] =  1;
_map[? "/f"        ] =  1;
_map[? "/colour"   ] =  2;
_map[? "/color"    ] =  2;
_map[? "/c"        ] =  2;
_map[? "/alpha"    ] =  3;
_map[? "/a"        ] =  3;
_map[? "/scale"    ] =  4;
_map[? "/s"        ] =  4;
//5 is unused
_map[? "/page"     ] =  6;
_map[? "scale"     ] =  7;
_map[? "scaleStack"] =  8;
//9 is unused
_map[? "alpha"     ] = 10;
_map[? "fa_left"   ] = 11;
_map[? "fa_center" ] = 12;
_map[? "fa_centre" ] = 12;
_map[? "fa_right"  ] = 13;
_map[? "fa_top"    ] = 14;
_map[? "fa_middle" ] = 15;
_map[? "fa_bottom" ] = 16;
_map[? "pin_left"  ] = 17;
_map[? "pin_center"] = 18;
_map[? "pin_centre"] = 18;
_map[? "pin_right" ] = 19;
_map[? "fa_justify"] = 20;
_map[? "nbsp"      ] = 21;
_map[? "&nbsp"     ] = 21;
_map[? "nbsp;"     ] = 21;
_map[? "&nbsp;"    ] = 21;
_map[? "cycle"     ] = 22;
_map[? "/cycle"    ] = 23;
_map[? "r"         ] = 24;
_map[? "/b"        ] = 24;
_map[? "/i"        ] = 24;
_map[? "/bi"       ] = 24;
_map[? "b"         ] = 25;
_map[? "i"         ] = 26;
_map[? "bi"        ] = 27;
_map[? "surface"   ] = 28;
_map[? "region"    ] = 29;
_map[? "/region"   ] = 30;
_map[? "zwsp"      ] = 31;
global.__scribble_command_tag_lookup_accelerator = _map;

//Add bindings for default effect names
//Effect index 0 is reversed for sprites
global.__scribble_effects[?       "wave"    ] = 1;
global.__scribble_effects[?       "shake"   ] = 2;
global.__scribble_effects[?       "rainbow" ] = 3;
global.__scribble_effects[?       "wobble"  ] = 4;
global.__scribble_effects[?       "pulse"   ] = 5;
global.__scribble_effects[?       "wheel"   ] = 6;
global.__scribble_effects[?       "cycle"   ] = 7;
global.__scribble_effects[?       "jitter"  ] = 8;
global.__scribble_effects[?       "blink"   ] = 9;
global.__scribble_effects[?       "slant"   ] = 10;
global.__scribble_effects_slash[? "/wave"   ] = 1;
global.__scribble_effects_slash[? "/shake"  ] = 2;
global.__scribble_effects_slash[? "/rainbow"] = 3;
global.__scribble_effects_slash[? "/wobble" ] = 4;
global.__scribble_effects_slash[? "/pulse"  ] = 5;
global.__scribble_effects_slash[? "/wheel"  ] = 6;
global.__scribble_effects_slash[? "/cycle"  ] = 7;
global.__scribble_effects_slash[? "/jitter" ] = 8;
global.__scribble_effects_slash[? "/blink"  ] = 9;
global.__scribble_effects_slash[? "/slant"  ] = 10;

global.__scribble_effects[?       "WAVE"    ] = 1;
global.__scribble_effects[?       "SHAKE"   ] = 2;
global.__scribble_effects[?       "RAINBOW" ] = 3;
global.__scribble_effects[?       "WOBBLE"  ] = 4;
global.__scribble_effects[?       "PULSE"   ] = 5;
global.__scribble_effects[?       "WHEEL"   ] = 6;
global.__scribble_effects[?       "CYCLE"   ] = 7;
global.__scribble_effects[?       "JITTER"  ] = 8;
global.__scribble_effects[?       "BLINK"   ] = 9;
global.__scribble_effects[?       "SLANT"   ] = 10;
global.__scribble_effects_slash[? "/WAVE"   ] = 1;
global.__scribble_effects_slash[? "/SHAKE"  ] = 2;
global.__scribble_effects_slash[? "/RAINBOW"] = 3;
global.__scribble_effects_slash[? "/WOBBLE" ] = 4;
global.__scribble_effects_slash[? "/PULSE"  ] = 5;
global.__scribble_effects_slash[? "/WHEEL"  ] = 6;
global.__scribble_effects_slash[? "/CYCLE"  ] = 7;
global.__scribble_effects_slash[? "/JITTER" ] = 8;
global.__scribble_effects_slash[? "/BLINK"  ] = 9;
global.__scribble_effects_slash[? "/SLANT"  ] = 10;

//Create a vertex format for our text
vertex_format_begin();
vertex_format_add_position_3d();                                  //12 bytes
vertex_format_add_normal();                                       //12 bytes
vertex_format_add_colour();                                       // 4 bytes
vertex_format_add_texcoord();                                     // 8 bytes
vertex_format_add_custom(vertex_type_float2, vertex_usage_color); // 8 bytes
global.__scribble_vertex_format = vertex_format_end();            //44 bytes per vertex, 132 bytes per tri, 264 bytes per glyph

vertex_format_begin();
vertex_format_add_position(); //12 bytes
vertex_format_add_color();    // 4 bytes
vertex_format_add_texcoord(); // 8 bytes
global.__scribble_passthrough_vertex_format = vertex_format_end();
    
//Cache uniform indexes
global.__scribble_u_fTime                    = shader_get_uniform(__shd_scribble, "u_fTime"                   );
global.__scribble_u_vColourBlend             = shader_get_uniform(__shd_scribble, "u_vColourBlend"            );
global.__scribble_u_vGradient                = shader_get_uniform(__shd_scribble, "u_vGradient"               );
global.__scribble_u_vSkew                    = shader_get_uniform(__shd_scribble, "u_vSkew"                   );
global.__scribble_u_vFlash                   = shader_get_uniform(__shd_scribble, "u_vFlash"                  );
global.__scribble_u_vRegionActive            = shader_get_uniform(__shd_scribble, "u_vRegionActive"           );
global.__scribble_u_vRegionColour            = shader_get_uniform(__shd_scribble, "u_vRegionColour"           );
global.__scribble_u_aDataFields              = shader_get_uniform(__shd_scribble, "u_aDataFields"             );
global.__scribble_u_aBezier                  = shader_get_uniform(__shd_scribble, "u_aBezier"                 );
global.__scribble_u_fBlinkState              = shader_get_uniform(__shd_scribble, "u_fBlinkState"             );
global.__scribble_u_iTypewriterMethod        = shader_get_uniform(__shd_scribble, "u_iTypewriterMethod"       );
global.__scribble_u_iTypewriterCharMax       = shader_get_uniform(__shd_scribble, "u_iTypewriterCharMax"      );
global.__scribble_u_fTypewriterWindowArray   = shader_get_uniform(__shd_scribble, "u_fTypewriterWindowArray"  );
global.__scribble_u_fTypewriterSmoothness    = shader_get_uniform(__shd_scribble, "u_fTypewriterSmoothness"   );
global.__scribble_u_vTypewriterStartPos      = shader_get_uniform(__shd_scribble, "u_vTypewriterStartPos"     );
global.__scribble_u_vTypewriterStartScale    = shader_get_uniform(__shd_scribble, "u_vTypewriterStartScale"   );
global.__scribble_u_fTypewriterStartRotation = shader_get_uniform(__shd_scribble, "u_fTypewriterStartRotation");
global.__scribble_u_fTypewriterAlphaDuration = shader_get_uniform(__shd_scribble, "u_fTypewriterAlphaDuration");

global.__scribble_msdf_u_fTime                    = shader_get_uniform(__shd_scribble_msdf, "u_fTime"                   );
global.__scribble_msdf_u_vColourBlend             = shader_get_uniform(__shd_scribble_msdf, "u_vColourBlend"            );
global.__scribble_msdf_u_vGradient                = shader_get_uniform(__shd_scribble_msdf, "u_vGradient"               );
global.__scribble_msdf_u_vSkew                    = shader_get_uniform(__shd_scribble_msdf, "u_vSkew"                   );
global.__scribble_msdf_u_vFlash                   = shader_get_uniform(__shd_scribble_msdf, "u_vFlash"                  );
global.__scribble_msdf_u_vRegionActive            = shader_get_uniform(__shd_scribble_msdf, "u_vRegionActive"           );
global.__scribble_msdf_u_vRegionColour            = shader_get_uniform(__shd_scribble_msdf, "u_vRegionColour"           );
global.__scribble_msdf_u_aDataFields              = shader_get_uniform(__shd_scribble_msdf, "u_aDataFields"             );
global.__scribble_msdf_u_aBezier                  = shader_get_uniform(__shd_scribble_msdf, "u_aBezier"                 );
global.__scribble_msdf_u_fBlinkState              = shader_get_uniform(__shd_scribble_msdf, "u_fBlinkState"             );
global.__scribble_msdf_u_vTexel                   = shader_get_uniform(__shd_scribble_msdf, "u_vTexel"                  );
global.__scribble_msdf_u_fMSDFRange               = shader_get_uniform(__shd_scribble_msdf, "u_fMSDFRange"              );
global.__scribble_msdf_u_iTypewriterMethod        = shader_get_uniform(__shd_scribble_msdf, "u_iTypewriterMethod"       );
global.__scribble_msdf_u_iTypewriterCharMax       = shader_get_uniform(__shd_scribble_msdf, "u_iTypewriterCharMax"      );
global.__scribble_msdf_u_fTypewriterWindowArray   = shader_get_uniform(__shd_scribble_msdf, "u_fTypewriterWindowArray"  );
global.__scribble_msdf_u_fTypewriterSmoothness    = shader_get_uniform(__shd_scribble_msdf, "u_fTypewriterSmoothness"   );
global.__scribble_msdf_u_vTypewriterStartPos      = shader_get_uniform(__shd_scribble_msdf, "u_vTypewriterStartPos"     );
global.__scribble_msdf_u_vTypewriterStartScale    = shader_get_uniform(__shd_scribble_msdf, "u_vTypewriterStartScale"   );
global.__scribble_msdf_u_fTypewriterStartRotation = shader_get_uniform(__shd_scribble_msdf, "u_fTypewriterStartRotation");
global.__scribble_msdf_u_fTypewriterAlphaDuration = shader_get_uniform(__shd_scribble_msdf, "u_fTypewriterAlphaDuration");
global.__scribble_msdf_u_vShadowColour            = shader_get_uniform(__shd_scribble_msdf, "u_vShadowColour"           );
global.__scribble_msdf_u_vShadowOffsetAndSoftness = shader_get_uniform(__shd_scribble_msdf, "u_vShadowOffsetAndSoftness");
global.__scribble_msdf_u_vBorderColour            = shader_get_uniform(__shd_scribble_msdf, "u_vBorderColour"           );
global.__scribble_msdf_u_fBorderThickness         = shader_get_uniform(__shd_scribble_msdf, "u_fBorderThickness"        );
global.__scribble_msdf_u_vOutputSize              = shader_get_uniform(__shd_scribble_msdf, "u_vOutputSize"             );
global.__scribble_msdf_u_fMSDFThicknessOffset     = shader_get_uniform(__shd_scribble_msdf, "u_fMSDFThicknessOffset"    );
global.__scribble_msdf_u_fSecondDraw              = shader_get_uniform(__shd_scribble_msdf, "u_fSecondDraw"             );

scribble_msdf_thickness_offset(0);

//Set up animation properties
global.__scribble_os_is_paused = false;

global.__scribble_anim_shader_desync = false;
global.__scribble_anim_shader_desync_to_default = false;
global.__scribble_anim_shader_default = false;

global.__scribble_anim_shader_msdf_desync = false;
global.__scribble_anim_shader_msdf_desync_to_default = false;
global.__scribble_anim_shader_msdf_default = false;

global.__scribble_standard_shader_uniforms_dirty = true;
global.__scribble_msdf_shader_uniforms_dirty = true;

global.__scribble_anim_properties = array_create(__SCRIBBLE_ANIM.__SIZE);
scribble_anim_reset();

//Bezier curve state
global.__scribble_bezier_using      = false;
global.__scribble_bezier_msdf_using = false;
global.__scribble_bezier_null_array = array_create(6, 0);

if (SCRIBBLE_LOAD_FONTS_ON_BOOT) __scribble_font_add_all_from_project();

#endregion



#region Functions

function __scribble_trace()
{
    var _string = "Scribble: ";
    
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
    var _data = global.__scribble_font_data[? _name];
    
    if (_data == undefined)
    {
        __scribble_error("Font \"", _name, "\" not recognised");
    }
    
    return _data;
}

function __scribble_process_colour(_value)
{
    if (is_string(_value))
    {
        if (!variable_struct_exists(global.__scribble_colours, _value))
        {
            __scribble_error("Colour \"", _value, "\" not recognised. Please add it to __scribble_config_colours()");
        }
        
        return (global.__scribble_colours[$ _value] & 0xFFFFFF);
    }
    else
    {
        return _value;
    }
}

function __scribble_random()
{
    global.__scribble_lcg = (48271*global.__scribble_lcg) mod 2147483647; //Lehmer
    return global.__scribble_lcg / 2147483648;
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

#endregion



#region Enums

enum SCRIBBLE_GLYPH
{
    CHARACTER,     // 0
                   
    UNICODE,       // 1 \
    BIDI,          // 2  |
                   //    |
    X_OFFSET,      // 3  |
    Y_OFFSET,      // 4  |
    WIDTH,         // 5  |
    HEIGHT,        // 6  |
    FONT_HEIGHT,   // 7  |
    SEPARATION,    // 8  |
    LEFT_OFFSET,   // 9  | This group of enums must not change order or be split
    FONT_SCALE,    //10  |
                   //    |
    TEXTURE,       //11  |
    U0,            //12  | Be careful of ordering!
    U1,            //13  | scribble_font_bake_shader() relies on this
    V0,            //14  |
    V1,            //15  |
                   //    |
    MSDF_PXRANGE,  //16  |
    BILINEAR,      //17 /
    
    __SIZE        //16
}

enum SCRIBBLE_EASE
{
    NONE,     // 0
    LINEAR,   // 1
    QUAD,     // 2
    CUBIC,    // 3
    QUART,    // 4
    QUINT,    // 5
    SINE,     // 6
    EXPO,     // 7
    CIRC,     // 8
    BACK,     // 9
    ELASTIC,  //10
    BOUNCE,   //11
    CUSTOM_1, //12
    CUSTOM_2, //13
    CUSTOM_3, //14
    __SIZE    //15
}

enum __SCRIBBLE_GLYPH_LAYOUT
{
    __UNICODE, // 0
    __LEFT,    // 1
    __TOP,     // 2
    __RIGHT,   // 3
    __BOTTOM,  // 4
    __SIZE,    // 5
}

enum __SCRIBBLE_VERTEX_BUFFER
{
    __VERTEX_BUFFER, //0
    __TEXTURE,       //1
    __MSDF_RANGE,    //2
    __TEXEL_WIDTH,   //3
    __TEXEL_HEIGHT,  //4
    __SHADER,        //5
    __BUFFER,        //6
    __BILINEAR,      //7
    __SIZE           //8
}

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
    __UNICODE,          // 0  \   Can be negative, see below
    __BIDI,             // 1   |
                        //     |
    __X,                // 2   |
    __Y,                // 3   |
    __WIDTH,            // 4   |
    __HEIGHT,           // 5   |
    __FONT_HEIGHT,      // 6   |
    __SEPARATION,       // 7   |
    __LEFT_OFFSET,      // 8   |
    __SCALE,            // 9   | This group of enums must not change order or be split
                        //     |
    __TEXTURE,          //10   |
    __QUAD_U0,          //11   | Be careful of ordering!
    __QUAD_U1,          //12   | scribble_font_bake_shader() relies on this
    __QUAD_V0,          //13   |
    __QUAD_V1,          //14   |
                        //     |
    __MSDF_PXRANGE,     //15   |
    __BILINEAR,         //16  /
    
    __CONTROL_COUNT,    //17
    __ANIMATION_INDEX,  //18
                      
    __SPRITE_INDEX,     //19  \
    __IMAGE_INDEX,      //20   | Only used for sprites
    __IMAGE_SPEED,      //21  /
                      
    __SIZE,             //22
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
    __EVENT,  //0
    __HALIGN, //1
    __COLOUR, //2
    __EFFECT, //3
    __CYCLE,  //4
    __REGION, //5
    __FONT,   //6
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
    __Y,                  //0
    __WORD_START,         //1
    __WORD_END,           //2
    __WIDTH,              //3
    __HEIGHT,             //4
    __HALIGN,             //5
    __STARTS_MANUAL_PAGE, //6
    __SIZE,               //7
}

#endregion



#region Misc Macros

#macro __SCRIBBLE_ON_DIRECTX           ((os_type == os_windows) || (os_type == os_xboxone) || (os_type == os_xboxseriesxs) || (os_type == os_uwp) || (os_type == os_win8native) || (os_type == os_winphone))
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
#macro __SCRIBBLE_CACHE_TIMEOUT        120 //How long to wait (in milliseconds) before the text element cache automatically cleans up unused data
#macro __SCRIBBLE_AUDIO_COMMAND_TAG    "__scribble_audio_playback__"

#macro __SCRIBBLE_DEVANAGARI_OFFSET  0xFFFF //This probably won't work for any other value

#macro __SCRIBBLE_MAX_LINES  1000  //Maximum number of lines in a textbox. This constant must match the corresponding values in __shd_scribble and __shd_scribble_msdf

#endregion
