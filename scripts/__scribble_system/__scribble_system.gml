// @jujuadams
#macro __SCRIBBLE_VERSION     "8.0.1 beta 1"
#macro __SCRIBBLE_DATE        "2021-12-23"
#macro __SCRIBBLE_DEBUG       false
#macro __SCRIBBLE_VERBOSE_GC  false



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
global.__scribble_lcg                 = date_current_datetime()*100;
global.__scribble_font_directory      = _font_directory;
global.__scribble_font_data           = ds_map_create();  //Stores a data array for each font defined inside Scribble
global.__scribble_effects             = ds_map_create();  //Bidirectional lookup - stores name:index as well as index:name
global.__scribble_effects_slash       = ds_map_create();  //Bidirectional lookup - stores name:index as well as index:name
global.__scribble_external_sound_map  = ds_map_create();
global.__scribble_default_font        = "scribble_fallback_font";
global.__scribble_buffer              = buffer_create(1024, buffer_grow, 1);
global.__scribble_glyph_grid          = ds_grid_create(1000, __SCRIBBLE_GEN_GLYPH.__SIZE);
global.__scribble_control_grid        = ds_grid_create(1000, __SCRIBBLE_GEN_CONTROL.__SIZE);
global.__scribble_word_grid           = ds_grid_create(1000, __SCRIBBLE_GEN_WORD.__SIZE);
global.__scribble_line_grid           = ds_grid_create(__SCRIBBLE_MAX_LINES, __SCRIBBLE_GEN_LINE.__SIZE);
global.__scribble_stretch_grid        = ds_grid_create(1000, __SCRIBBLE_GEN_STRETCH.__SIZE);
global.__scribble_temp_grid           = ds_grid_create(1000, __SCRIBBLE_GEN_WORD.__SIZE); //Somewhat arbitrary size. Feel free to increase this size as is needed
global.__scribble_vbuff_pos_grid      = ds_grid_create(1000, __SCRIBBLE_GEN_VBUFF_POS.__SIZE);
//global.__scribble_window_array_null   = array_create(2*__SCRIBBLE_WINDOW_COUNT, 1.0); //TODO - Do we still need this?

global.__scribble_cache_check_time = current_time;

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

if (!variable_global_exists("__scribble_colours")) global.__scribble_colours = ds_map_create();

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
global.__scribble_anim_shader_desync = false;
global.__scribble_anim_shader_desync_to_default = false;
global.__scribble_anim_shader_default = false;

global.__scribble_anim_shader_msdf_desync = false;
global.__scribble_anim_shader_msdf_desync_to_default = false;
global.__scribble_anim_shader_msdf_default = false;

global.__scribble_anim_properties = array_create(__SCRIBBLE_ANIM.__SIZE);
scribble_anim_reset();

//Bezier curve state
global.__scribble_bezier_using      = false;
global.__scribble_bezier_msdf_using = false;
global.__scribble_bezier_null_array = array_create(6, 0);

//Try to add all fonts in the project to Scribble
var _i = 0;
repeat(1000)
{
    if (!font_exists(_i)) break;
    
    var _skip = false;
    
    var _tags = asset_get_tags(_i, asset_font);
    var _j = 0;
    repeat(array_length(_tags))
    {
        if (string_lower(_tags[_j]) == "scribble skip")
        {
            _skip = true;
            break;
        }
        
        ++_j;
    }
    
    var _name = font_get_name(_i);
    if (string_copy(_name, 1, 9) == "__newfont") //Don't scan fonts created at runtime (e.g. by font_add_sprite())
    {
        _skip = true;
    }
    
    if (!_skip)
    {
        __scribble_font_add_from_project(_i);
    }
    
    ++_i;
}

//Find every sprite asset with the "scribble msdf" tag
//We check variations on the tag because they're case sensitive and people might spell it differently despite what documentation says
var _assets = [];

var _array = tag_get_assets("Scribble MSDF");
array_copy(_assets, array_length(_assets), _array, 0, array_length(_array));

var _array = tag_get_assets("scribble MSDF");
array_copy(_assets, array_length(_assets), _array, 0, array_length(_array));

var _array = tag_get_assets("Scribble msdf");
array_copy(_assets, array_length(_assets), _array, 0, array_length(_array));

var _array = tag_get_assets("scribble msdf");
array_copy(_assets, array_length(_assets), _array, 0, array_length(_array));

var _array = tag_get_assets("scribblemsdf");
array_copy(_assets, array_length(_assets), _array, 0, array_length(_array));

var _i = 0;
repeat(array_length(_assets))
{
    var _asset = _assets[_i];
    if (asset_get_type(_asset) != asset_sprite)
    {
        __scribble_error("\"scribble msdf\" tag should only be applied to sprite assets (\"", _asset, "\" had the tag)");
    }
    else
    {
        __scribble_font_add_msdf_from_project(asset_get_index(_asset));
    }
    
    ++_i;
}

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

function __scribble_error()
{
    var _string = "";
    
    var _i = 0
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message("Scribble: " + string_replace_all(_string, "\n", "\n          "));
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
        if (!ds_map_exists(global.__scribble_colours, _value))
        {
            __scribble_error("Colour \"", _value, "\" not recognised. Please add it to __scribble_config_colours()");
        }
        
        return (global.__scribble_colours[? _value] & 0xFFFFFF);
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

function __scribble_prepare_super_work_array(_input_array)
{
    var _output_array = [];
    
    var _i = 0;
    repeat(array_length(_input_array))
    {
        var _glyph_to_copy = _input_array[_i];
        
        if (is_string(_glyph_to_copy))
        {
            var _j = 1;
            repeat(string_length(_glyph_to_copy))
            {
                var _unicode = ord(string_char_at(_glyph_to_copy, _j));
                array_push(_output_array, [_unicode, _unicode]);
                ++_j;
            }
            
            _glyph_to_copy = undefined;
        }
        
        if (is_numeric(_glyph_to_copy))
        {
            _glyph_to_copy = [_glyph_to_copy, _glyph_to_copy];
        }
        
        if (is_array(_glyph_to_copy))
        {
            array_push(_output_array, _glyph_to_copy);
        }
        
        ++_i;
    }
    
    return _output_array;
}

/// @param oldGlyph
/// @param [yOffset=0]
function __scribble_glyph_duplicate(_old, _y_offset = 0)
{
    var _new = array_create(SCRIBBLE_GLYPH.__SIZE);
    array_copy(_new, 0, _old, 0, SCRIBBLE_GLYPH.__SIZE);
    _new[@ SCRIBBLE_GLYPH.Y_OFFSET] += _y_offset;
    return _new;
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

enum __SCRIBBLE_GLYPH_LAYOUT
{
    UNICODE, // 0
    LEFT,    // 1
    TOP,     // 2
    RIGHT,   // 3
    BOTTOM,  // 4
    __SIZE,  // 5
}

enum __SCRIBBLE_VERTEX_BUFFER
{
    VERTEX_BUFFER, //0
    TEXTURE,       //1
    MSDF_RANGE,    //2
    TEXEL_WIDTH,   //3
    TEXEL_HEIGHT,  //4
    SHADER,        //5
    BUFFER,        //6
    BILINEAR,      //7
    __SIZE         //8
}

enum __SCRIBBLE_ANIM
{
    WAVE_SIZE,        // 0
    WAVE_FREQ,        // 1
    WAVE_SPEED,       // 2
    SHAKE_SIZE,       // 3
    SHAKE_SPEED,      // 4
    RAINBOW_WEIGHT,   // 5
    RAINBOW_SPEED,    // 6
    WOBBLE_ANGLE,     // 7
    WOBBLE_FREQ,      // 8
    PULSE_SCALE,      // 9
    PULSE_SPEED,      //10
    WHEEL_SIZE,       //11
    WHEEL_FREQ,       //12
    WHEEL_SPEED,      //13
    CYCLE_SPEED,      //14
    CYCLE_SATURATION, //15
    CYCLE_VALUE,      //16
    JITTER_MINIMUM,   //17
    JITTER_MAXIMUM,   //18
    JITTER_SPEED,     //19
    SLANT_GRADIENT,   //20
    __SIZE,           //21
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

#endregion



#region Generator Enums

enum __SCRIBBLE_GEN_GLYPH
{
    UNICODE,          // 0  \   Can be negative, see below
    BIDI,             // 1   |
                      //     |
    X,                // 2   |
    Y,                // 3   |
    WIDTH,            // 4   |
    HEIGHT,           // 5   |
    FONT_HEIGHT,      // 6   |
    SEPARATION,       // 7   |
    LEFT_OFFSET,      // 8   |
    SCALE,            // 9   | This group of enums must not change order or be split
                      //     |
    TEXTURE,          //10   |
    QUAD_U0,          //11   | Be careful of ordering!
    QUAD_U1,          //12   | scribble_font_bake_shader() relies on this
    QUAD_V0,          //13   |
    QUAD_V1,          //14   |
                      //     |
    MSDF_PXRANGE,     //15   |
    BILINEAR,         //16  /
    
    CONTROL_COUNT,    //17
    ANIMATION_INDEX,  //18
                      
    SPRITE_INDEX,     //19  \
    IMAGE_INDEX,      //20   | Only used for sprites
    IMAGE_SPEED,      //21  /
                      
    __SIZE,           //20
}

enum __SCRIBBLE_GEN_VBUFF_POS
{
    QUAD_L, //0
    QUAD_T, //1
    QUAD_R, //2
    QUAD_B, //3
    __SIZE, //4
}

enum __SCRIBBLE_GEN_CONTROL_TYPE
{
    EVENT,
    HALIGN,
    COLOUR,
    EFFECT,
    CYCLE,
    REGION,
}

//These can be used for ORD
#macro  __SCRIBBLE_GLYPH_SPRITE   -1
#macro  __SCRIBBLE_GLYPH_SURFACE  -2

enum __SCRIBBLE_GEN_CONTROL
{
    TYPE,   //0
    DATA,   //1
    __SIZE, //2
}

enum __SCRIBBLE_GEN_WORD
{
    BIDI_RAW,    //0
    BIDI,        //1
    GLYPH_START, //2
    GLYPH_END,   //3
    WIDTH,       //4
    HEIGHT,      //5
    __SIZE,      //6
}

enum __SCRIBBLE_GEN_STRETCH
{
    WORD_START, //0
    WORD_END,   //1
    BIDI,       //2
    __SIZE,
}

enum __SCRIBBLE_GEN_LINE
{
    Y,                  //0
    WORD_START,         //1
    WORD_END,           //2
    WIDTH,              //3
    HEIGHT,             //4
    HALIGN,             //5
    STARTS_MANUAL_PAGE, //6
    __SIZE,             //7
}

#endregion



#region Misc Macros

#macro __SCRIBBLE_ON_DIRECTX           ((os_type == os_windows) || (os_type == os_xboxone) || (os_type == os_uwp) || (os_type == os_win8native) || (os_type == os_winphone))
#macro __SCRIBBLE_ON_OPENGL            (!__SCRIBBLE_ON_DIRECTX)
#macro __SCRIBBLE_ON_MOBILE            ((os_type == os_ios) || (os_type == os_android) || (os_type == os_tvos))
#macro __SCRIBBLE_ON_WEB               (os_browser != browser_not_a_browser)
#macro __SCRIBBLE_EXPECTED_FRAME_TIME  (0.95*game_get_speed(gamespeed_microseconds)/1000) //Uses to prevent the autotype from advancing if a draw call is made multiple times a frame to the same text element
#macro __SCRIBBLE_PIN_LEFT             3
#macro __SCRIBBLE_PIN_CENTRE           4
#macro __SCRIBBLE_PIN_RIGHT            5
#macro __SCRIBBLE_JUSTIFY              6
#macro __SCRIBBLE_WINDOW_COUNT         3
#macro __SCRIBBLE_GC_STEP_SIZE         3
#macro __SCRIBBLE_CACHE_TIMEOUT        120 //How long to wait (in milliseconds) before the text element cache automatically cleans up unused data
#macro __SCRIBBLE_AUDIO_COMMAND_TAG    "__scribble_audio_playback__"

#macro __SCRIBBLE_MAX_LINES  1000  //Maximum number of lines in a textbox. This constant must match the corresponding values in __shd_scribble and __shd_scribble_msdf

#endregion