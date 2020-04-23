/// Prepares Scribble for use.
/// This script should be called before any other Scribble script.
/// 
/// 
/// Returns: Whether initialisation was successful
/// @param fontDirectory    The directory to look in (relative to game_save_id) for font .yy files.
/// @param defaultFont      The name of the default Scribble font to use, as a string.
/// @param autoScan         Whether or not to automatically find normal font .yy files in the font directory.
///                         N.B. This only works for normal fonts, and on desktop platforms.
/// 
/// 
/// This script achieves the following things:
/// 1) Define the default font directory to pull font .yy files from
/// 2) Create global text elements to store data and state
/// 3) Define custom colours analogues for GM's native colour constants
/// 4) Define names for default effects - wave, shake, rainbow
/// 5) Creates a vertex format
/// 6) Cache uniform indexes for the shd_scribble shader
/// 7) Build a lookup table for decoding hexcode colours in scribble_draw()
/// 8) Automatically scans Included Files for fonts (if enabled)
/// 
/// 
/// Scribble v5.4.6
/// 2020-04-23
/// @jujuadams
/// With thanks to glitchroy, Mark Turner, DragoniteSpam, sp202, Rob van Saaze, soVes, and @stoozey_
/// 
/// For use with GMS2.2.2 and later

#region Internal Macro Definitions

#macro __SCRIBBLE_VERSION  "5.4.6"
#macro __SCRIBBLE_DATE     "2020-04-23"
#macro __SCRIBBLE_DEBUG    false

//You'll usually only want to modify SCRIBBLE_GLYPH.X_OFFSET, SCRIBBLE_GLYPH.Y_OFFSET, and SCRIBBLE_GLYPH.SEPARATION
enum SCRIBBLE_GLYPH
{
    CHARACTER,  // 0
    INDEX,      // 1
    WIDTH,      // 2
    HEIGHT,     // 3
    X_OFFSET,   // 4
    Y_OFFSET,   // 5
    SEPARATION, // 6
    U0,         // 7
    V0,         // 8
    U1,         // 9
    V1,         //10
    __SIZE      //11
}

enum __SCRIBBLE_FONT
{
    NAME,         // 0
    PATH,         // 1
    TYPE,         // 2
    GLYPHS_MAP,   // 3
    GLYPHS_ARRAY, // 4
    GLYPH_MIN,    // 5
    GLYPH_MAX,    // 6
    TEXTURE,      // 7
    SPACE_WIDTH,  // 8
    MAPSTRING,    // 9
    SEPARATION,   //10
    __SIZE        //11
}

enum __SCRIBBLE_FONT_TYPE
{
    FONT,  //0
    SPRITE //1
}

enum __SCRIBBLE_PAGE
{
    LINES,                //0
    CHARACTERS,           //1
    LINES_ARRAY,          //2
    VERTEX_BUFFERS_ARRAY, //3
    
    EVENT_PREVIOUS,       //4
    EVENT_CHAR_PREVIOUS,  //5
    EVENT_CHAR_ARRAY,     //6
    EVENT_NAME_ARRAY,     //7
    EVENT_DATA_ARRAY,     //8
    
    __SIZE
}

enum __SCRIBBLE_LINE
{
    LAST_CHAR, //0
    Y,         //1
    WIDTH,     //2
    HEIGHT,    //3
    HALIGN,    //4
    __SIZE     //5
}

enum __SCRIBBLE_VERTEX_BUFFER
{
    BUFFER,
    VERTEX_BUFFER,
    TEXTURE,
    CHAR_START_TELL,
    WORD_START_TELL,
    LINE_START_LIST,
    TEXEL_WIDTH,
    TEXEL_HEIGHT,
    __SIZE
}

enum __SCRIBBLE_VERTEX
{
    CENTRE_X       =  0,
    CENTRE_Y       =  4,
    PACKED_INDEXES =  8,
    DELTA_X        = 12,
    DELTA_Y        = 16,
    EFFECT_FLAGS   = 20,
    COLOUR         = 24,
    U              = 28,
    V              = 32,
    __SIZE         = 36
}

enum SCRIBBLE_STATE
{
    START_COLOUR,
    START_FONT,
    START_HALIGN,
    XSCALE,
    YSCALE,
    ANGLE,
    COLOUR,
    ALPHA,
    LINE_MIN_HEIGHT,
    MAX_WIDTH,
    MAX_HEIGHT,
    CHARACTER_WRAP,
    HALIGN,
    VALIGN,
    AUTOTYPE_FADE_IN,
    AUTOTYPE_POSITION,
    AUTOTYPE_SMOOTHNESS,
    AUTOTYPE_METHOD,
    ANIMATION_ARRAY,
    CACHE_GROUP,
    ALLOW_DRAW,
    FREEZE,
    __SIZE
}

enum __SCRIBBLE
{
    __SECTION0,             // 0
    VERSION,                // 1
    STRING,                 // 2
    CACHE_STRING,           // 3
    DEFAULT_FONT,           // 3
    DEFAULT_COLOUR,         // 4
    DEFAULT_HALIGN,         // 5
    WIDTH_LIMIT,            // 6
    HEIGHT_LIMIT,           // 7
    LINE_HEIGHT,            // 8
    
    __SECTION1,             // 9
    WIDTH,                  //10
    HEIGHT,                 //11
    CHARACTERS,             //12
    LINES,                  //13
    PAGES,                  //14
    GLOBAL_INDEX,           //15
    
    __SECTION2,             //16
    ANIMATION_TIME,         //17
    TIME,                   //18
    FREED,                  //19
    SOUND_FINISH_TIME,      //20
    
    __SECTION3,             //21
    PAGES_ARRAY,            //22
    
    __SECTION4,             //23
    AUTOTYPE_PAGE,          //24
    AUTOTYPE_FADE_IN,       //25
    AUTOTYPE_SPEED,         //26
    AUTOTYPE_POSITION,      //27
    AUTOTYPE_METHOD,        //28
    AUTOTYPE_SMOOTHNESS,    //29
    AUTOTYPE_SOUND_ARRAY,   //30
    AUTOTYPE_SOUND_OVERLAP, //31
    
    __SIZE                  //32
}

#macro __SCRIBBLE_ON_DIRECTX           ((os_type == os_windows) || (os_type == os_xboxone) || (os_type == os_uwp) || (os_type == os_win8native) || (os_type == os_winphone))
#macro __SCRIBBLE_ON_OPENGL            (!__SCRIBBLE_ON_DIRECTX)
#macro __SCRIBBLE_ON_MOBILE            ((os_type == os_ios) || (os_type == os_android) || (os_type == os_tvos))
#macro __SCRIBBLE_ON_WEB               (os_browser != browser_not_a_browser)
#macro __SCRIBBLE_GLYPH_BYTE_SIZE      (6*__SCRIBBLE_VERTEX.__SIZE)
#macro __SCRIBBLE_EXPECTED_GLYPHS      100
#macro __SCRIBBLE_EXPECTED_FRAME_TIME  (0.95*game_get_speed(gamespeed_microseconds)/1000) //Uses to prevent the autotype from advancing if a draw call is made multiple times a frame to the same text element

//These are tied to values in shd_scribble
//If you need to change these for some reason, you'll need to change shd_scribble too
#macro SCRIBBLE_AUTOTYPE_NONE           0  //No fade
#macro SCRIBBLE_AUTOTYPE_PER_CHARACTER  1  //Fade each character individually
#macro SCRIBBLE_AUTOTYPE_PER_LINE       2  //Fade each line of text as a group
#macro SCRIBBLE_FADE_NONE               SCRIBBLE_AUTOTYPE_NONE
#macro SCRIBBLE_FADE_PER_CHARACTER      SCRIBBLE_AUTOTYPE_PER_CHARACTER
#macro SCRIBBLE_FADE_PER_LINE           SCRIBBLE_AUTOTYPE_PER_LINE

#macro scribble_add_colour  scribble_add_color

#endregion

if (variable_global_exists("__scribble_global_count"))
{
    if (SCRIBBLE_WARNING_REINITIALIZE) show_error("Scribble:\nscribble_init() should not be called twice!\n(Set SCRIBBLE_WARNING_REINITIALIZE to <false> to hide this warning)\n ", false);
    return false;
}

show_debug_message("Scribble: Welcome to Scribble by @jujuadams! This is version " + __SCRIBBLE_VERSION + ", " + __SCRIBBLE_DATE);

var _font_directory = argument0;
var _default_font   = argument1;
var _auto_scan      = argument2;

if (__SCRIBBLE_ON_MOBILE)
{
    if (_font_directory != "")
    {
        show_debug_message("Scribble: Included Files work a bit strangely on iOS and Android. Please use an empty string for the font directory and place fonts in the root of Included Files.");
        show_error("Scribble:\nGameMaker's Included Files work a bit strangely on iOS and Android.\nPlease use an empty string for the font directory and place fonts in the root of Included Files.\n ", true);
        exit;
    }
}
else if (__SCRIBBLE_ON_WEB)
{
    if (_font_directory != "")
    {
        show_debug_message("Scribble: Using folders inside Included Files might not work properly on HTML5. If you're having trouble, try using an empty string for the font directory and place fonts in the root of Included Files.");
    }
}

if (_font_directory != "")
{
    //Fix the font directory name if it's weird
    var _char = string_char_at(_font_directory, string_length(_font_directory));
    if (_char != "\\") && (_char != "/") _font_directory += "\\";
}

if (!__SCRIBBLE_ON_WEB)
{
    //Check if the directory exists
    if (!directory_exists(_font_directory))
    {
        show_debug_message("Scribble: WARNING! Font directory \"" + string(_font_directory) + "\" could not be found in \"" + game_save_id + "\"!");
    }
}

//Check if the default font parameter is the correct datatype
if (!is_string(_default_font))
{
    if (is_real(_default_font) && (asset_get_type(font_get_name(_default_font)) == asset_font))
    {
        show_error("Scribble:\nThe default font should be defined using its name as a string.\n(Input was \"" + string(_default_font) + "\", which might be font \"" + font_get_name(_default_font) + "\")\n ", false);
    }
    else
    {
        show_error("Scribble:\nThe default font should be defined using its name as a string.\n(Input was an invalid datatype)\n ", false);
    }
    
    _default_font = "";
}
else if ((asset_get_type(_default_font) != asset_font) && (asset_get_type(_default_font) != asset_sprite) && (_default_font != "")) //Check if the default font even exists!
{
    show_error("Scribble:\nThe default font \"" + _default_font + "\" could not be found in the project.\n ", true);
    _default_font = "";
}

//Declare global variables
global.__scribble_lcg               = date_current_datetime()*100;
global.__scribble_font_directory    = _font_directory;
global.__scribble_font_data         = ds_map_create();  //Stores a data array for each font defined inside Scribble
global.__scribble_colours           = ds_map_create();  //Stores colour definitions, including custom colours
global.__scribble_effects           = ds_map_create();  //Bidirectional lookup - stores name:index as well as index:name
global.__scribble_effects_slash     = ds_map_create();  //Bidirectional lookup - stores name:index as well as index:name
global.__scribble_autotype_events   = ds_map_create();
global.scribble_alive               = ds_map_create();  //ds_map of all alive text elements
global.__scribble_global_count      = 0;
global.__scribble_default_font      = _default_font;
global.__scribble_global_cache_map  = ds_map_create();
global.__scribble_global_cache_list = ds_list_create();
global.__scribble_cache_test_index  = 0;
global.__scribble_cache_group_map   = ds_map_create();
ds_map_add_list(global.__scribble_cache_group_map, SCRIBBLE_DEFAULT_CACHE_GROUP, global.__scribble_global_cache_list);

//Declare state variables
global.__scribble_default_anim_array = [4, 50, 0.2,   4, 0.4,   0.5, 0.01,   40, 0.15,   0.4, 0.1];
global.scribble_state_anim_array = array_create(SCRIBBLE_MAX_DATA_FIELDS);
scribble_draw_reset();

//Duplicate GM's native colour constants in string form for access in scribble_draw()
global.__scribble_colours[? "c_aqua"   ] = c_aqua;
global.__scribble_colours[? "c_black"  ] = c_black;
global.__scribble_colours[? "c_blue"   ] = c_blue;
global.__scribble_colours[? "c_dkgray" ] = c_dkgray;
global.__scribble_colours[? "c_dkgrey" ] = c_dkgray;
global.__scribble_colours[? "c_fuchsia"] = c_fuchsia;
global.__scribble_colours[? "c_gray"   ] = c_gray;
global.__scribble_colours[? "c_green"  ] = c_green;
global.__scribble_colours[? "c_grey"   ] = c_gray;
global.__scribble_colours[? "c_lime"   ] = c_lime;
global.__scribble_colours[? "c_ltgray" ] = c_ltgray;
global.__scribble_colours[? "c_ltgrey" ] = c_ltgray;
global.__scribble_colours[? "c_maroon" ] = c_maroon;
global.__scribble_colours[? "c_navy"   ] = c_navy;
global.__scribble_colours[? "c_olive"  ] = c_olive;
global.__scribble_colours[? "c_orange" ] = c_orange;
global.__scribble_colours[? "c_purple" ] = c_purple;
global.__scribble_colours[? "c_red"    ] = c_red;
global.__scribble_colours[? "c_silver" ] = c_silver;
global.__scribble_colours[? "c_teal"   ] = c_teal;
global.__scribble_colours[? "c_white"  ] = c_white;
global.__scribble_colours[? "c_yellow" ] = c_yellow;

//Add bindings for default effect names
//Effect index 0 is reversed for sprites
global.__scribble_effects[?       "wave"    ] = 1;
global.__scribble_effects[?       "shake"   ] = 2;
global.__scribble_effects[?       "rainbow" ] = 3;
global.__scribble_effects[?       "wobble"  ] = 4;
global.__scribble_effects[?       "pulse"   ] = 5;
global.__scribble_effects_slash[? "/wave"   ] = 1;
global.__scribble_effects_slash[? "/shake"  ] = 2;
global.__scribble_effects_slash[? "/rainbow"] = 3;
global.__scribble_effects_slash[? "/wobble" ] = 4;
global.__scribble_effects_slash[? "/pulse"  ] = 5;

//Create a vertex format for our text
vertex_format_begin();
vertex_format_add_position_3d(); //12 bytes
vertex_format_add_normal();      //12 bytes       //X = character index, Y = line index, Z = effect flags
vertex_format_add_colour();      // 4 bytes
vertex_format_add_texcoord();    // 8 bytes
global.__scribble_vertex_format = vertex_format_end(); //36 bytes per vertex, 108 bytes per tri, 216 bytes per glyph

//Cache uniform indexes
global.__scribble_uniform_time          = shader_get_uniform(shd_scribble, "u_fTime"                );
global.__scribble_uniform_colour_blend  = shader_get_uniform(shd_scribble, "u_vColourBlend"         );
global.__scribble_uniform_tw_method     = shader_get_uniform(shd_scribble, "u_fTypewriterMethod"    );
global.__scribble_uniform_tw_smoothness = shader_get_uniform(shd_scribble, "u_fTypewriterSmoothness");
global.__scribble_uniform_tw_t          = shader_get_uniform(shd_scribble, "u_fTypewriterT"         );
global.__scribble_uniform_data_fields   = shader_get_uniform(shd_scribble, "u_aDataFields"          );
global.__scribble_uniform_texel         = shader_get_uniform(shd_scribble, "u_fTexel"               );
global.__scribble_uniform_z             = shader_get_uniform(shd_scribble, "u_fZ"                   );

//Hex converter array
var _min = ord("0");
var _max = ord("f");
global.__scribble_hex_min = _min;
global.__scribble_hex_max = _max;
global.__scribble_hex_array = array_create(1 + _max - _min);
global.__scribble_hex_array[@ ord("0") - _min ] =  0; //ascii  48 = array  0
global.__scribble_hex_array[@ ord("1") - _min ] =  1; //ascii  49 = array  1
global.__scribble_hex_array[@ ord("2") - _min ] =  2; //ascii  50 = array  2
global.__scribble_hex_array[@ ord("3") - _min ] =  3; //ascii  51 = array  3
global.__scribble_hex_array[@ ord("4") - _min ] =  4; //ascii  52 = array  4
global.__scribble_hex_array[@ ord("5") - _min ] =  5; //ascii  53 = array  5
global.__scribble_hex_array[@ ord("6") - _min ] =  6; //ascii  54 = array  6
global.__scribble_hex_array[@ ord("7") - _min ] =  7; //ascii  55 = array  7
global.__scribble_hex_array[@ ord("8") - _min ] =  8; //ascii  56 = array  8
global.__scribble_hex_array[@ ord("9") - _min ] =  9; //ascii  57 = array  9
global.__scribble_hex_array[@ ord("A") - _min ] = 10; //ascii  65 = array 17
global.__scribble_hex_array[@ ord("B") - _min ] = 11; //ascii  66 = array 18
global.__scribble_hex_array[@ ord("C") - _min ] = 12; //ascii  67 = array 19
global.__scribble_hex_array[@ ord("D") - _min ] = 13; //ascii  68 = array 20
global.__scribble_hex_array[@ ord("E") - _min ] = 14; //ascii  69 = array 21
global.__scribble_hex_array[@ ord("F") - _min ] = 15; //ascii  70 = array 22
global.__scribble_hex_array[@ ord("a") - _min ] = 10; //ascii  97 = array 49
global.__scribble_hex_array[@ ord("b") - _min ] = 11; //ascii  98 = array 50
global.__scribble_hex_array[@ ord("c") - _min ] = 12; //ascii  99 = array 51
global.__scribble_hex_array[@ ord("d") - _min ] = 13; //ascii 100 = array 52
global.__scribble_hex_array[@ ord("e") - _min ] = 14; //ascii 101 = array 53
global.__scribble_hex_array[@ ord("f") - _min ] = 15; //ascii 102 = array 54

if (_auto_scan)
{
    if (__SCRIBBLE_ON_MOBILE || __SCRIBBLE_ON_WEB)
    {
        show_error("Scribble:\nFont autoscan is not supported on this platform.\nPlease manually add fonts using scribble_add_font() ", false);
    }
    else
    {
        var _root_directory_size = string_length(global.__scribble_font_directory);
        
        var _directory_list = ds_list_create();
        ds_list_add(_directory_list, _font_directory);
        while(!ds_list_empty(_directory_list))
        {
            var _directory = _directory_list[| 0];
            ds_list_delete(_directory_list, 0);
            
            var _file = file_find_first(_directory + "*.*", fa_readonly | fa_hidden | fa_directory);
            while(_file != "")
            {
                if (directory_exists(_directory + _file))
                {
                    ds_list_add(_directory_list, _font_directory + _file + "\\");
                }
                
                _file = file_find_next();
            }
            file_find_close();
            
            var _file = file_find_first(_directory + "*.*", 0);
            while(_file != "")
            {
                if (filename_ext(_file) == ".yy")
                {
                    var _font = filename_change_ext(_file, "");
                    
                    if (asset_get_type(_font) != asset_font)
                    {
                        show_debug_message("Scribble: Warning! Autoscan found \"" + _file + "\", but \"" + _font + "\" was not found in the project as a font asset");
                    }
                    else
                    {
                        scribble_add_font(_font, string_delete(_directory + _file, 1, _root_directory_size));
                        if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Autoscan added \"" + _font + "\" as a standard font (via " + string(_directory + _file) + ")");
                    }
                }
                _file = file_find_next();
            }
            file_find_close();
        }
        ds_list_destroy(_directory_list);
    }
}

return true;