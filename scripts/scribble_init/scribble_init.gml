/// Starts initialisation for Scribble
/// This script should be called before scribble_add_font() / scribble_add_spritefont() and scribble_init_end()
///
/// @param fontDirectory    Directory to look in (relative to game_save_id) for font .yy files
/// @param defaultFont      The name of the default Scribble font, as a string
/// @param autoScan         Set to <true> to automatically find standard font .yy files in the font directory. This only works for standard fonts, and on desktop platforms
///
/// This script achieves the following things:
/// 1) Define the default font directory to pull font .yy files from
/// 2) Define the maximum texture page size available for Scribble
/// 3) Create global data structures to store data
/// 4) Define custom colours analogues for GM's native colour constants
/// 5) Define flag names for default effects - wave, shake, rainbow
/// 6) Creates a vertex format
/// 7) Cache uniform indexes for the shScribble shader
/// 8) Build a lookup table for decoding hexcode colours in scribble_create()
///
/// Initialisation is only fully complete once scribble_init_end() is called

#region Internal Macro Definitions

#macro __SCRIBBLE_VERSION  "4.8.0"
#macro __SCRIBBLE_DATE     "2019/07/08"
#macro __SCRIBBLE_DEBUG    false

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
    FONT,
    SPRITE
}

enum __SCRIBBLE_LINE
{
    LAST_CHAR,       //0
    WIDTH,           //1
    HEIGHT,          //2
    HALIGN,          //3
    __SIZE           //4
}

enum __SCRIBBLE_VERTEX_BUFFER
{
    BUFFER,
    VERTEX_BUFFER,
    TEXTURE,
    WORD_START_TELL,
    LINE_START_LIST,
    __SIZE
}

enum __SCRIBBLE_VERTEX
{
    X      =  0,
    Y      =  4,
    Z      =  8,
    NX     = 12,
    NY     = 16,
    NZ     = 20,
    C      = 24,
    U      = 28,
    V      = 32,
    __SIZE = 36
}

enum __SCRIBBLE
{
    __SECTION0,          // 0
    VERSION,             // 1
    STRING,              // 2
    DEFAULT_FONT,        // 3
    DEFAULT_COLOUR,      // 4
    DEFAULT_HALIGN,      // 5
    WIDTH_LIMIT,         // 6
    LINE_HEIGHT,         // 7
    
    __SECTION1,          // 8
    HALIGN,              // 9
    VALIGN,              //10
    WIDTH,               //11
    HEIGHT,              //12
    LEFT,                //13
    TOP,                 //14
    RIGHT,               //15
    BOTTOM,              //16
    CHARACTERS,          //17
    LINES,               //18
    GLOBAL_INDEX,        //20
    
    __SECTION2,          //21
    TW_DIRECTION,        //22
    TW_SPEED,            //23
    TW_POSITION,         //24
    TW_METHOD,           //25
    TW_SMOOTHNESS,       //26
    CHAR_FADE_T,         //27
    LINE_FADE_T,         //28
    
    __SECTION3,          //29
    HAS_CALLED_STEP,     //30
    NO_STEP_COUNT,       //31
    DATA_FIELDS,         //32
    ANIMATION_TIME,      //33
    
    __SECTION4,          //34
    LINE_LIST,           //35
    VERTEX_BUFFER_LIST,  //36
    
    __SECTION5,          //37
    EVENT_PREVIOUS,      //38
    EVENT_CHAR_PREVIOUS, //39
    EVENT_CHAR_ARRAY,    //40
    EVENT_NAME_ARRAY,    //41
    EVENT_DATA_ARRAY,    //42
    
    __SIZE               //43
}

#macro __SCRIBBLE_ON_DIRECTX        ((os_type == os_windows) || (os_type == os_xboxone) || (os_type == os_uwp) || (os_type == os_win8native) || (os_type == os_winphone))
#macro __SCRIBBLE_ON_OPENGL         !__SCRIBBLE_ON_DIRECTX
#macro __SCRIBBLE_ON_MOBILE         ((os_type == os_ios) || (os_type == os_android))
#macro __SCRIBBLE_GLYPH_BYTE_SIZE   (6*__SCRIBBLE_VERTEX.__SIZE)
#macro __SCRIBBLE_EXPECTED_GLYPHS   100

#endregion

if ( variable_global_exists("__scribble_global_count") )
{
    show_error("Scribble:\nscribble_init() should not be called twice!\n ", false);
    exit;
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
else
{
    //Fix the font directory name if it's weird
    var _char = string_char_at(_font_directory, string_length(_font_directory));
    if (_char != "\\") && (_char != "/") _font_directory += "\\";
}

//Check if the directory exists
if ( !directory_exists(_font_directory) )
{
    show_debug_message("Scribble: WARNING! Font directory \"" + string(_font_directory) + "\" could not be found in \"" + game_save_id + "\"!");
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
    show_error("Scribble:\nTThe default font \"" + _default_font + "\" could not be found in the project.\n ", true);
    _default_font = "";
}

//Declare global variables
global.__scribble_font_directory = _font_directory;
global.__scribble_font_data      = ds_map_create();  //Stores a data array for each font defined inside Scribble
global.__scribble_colours        = ds_map_create();  //Stores colour definitions, including custom colours
global.__scribble_events         = ds_map_create();  //Stores event bindings; key is the name of the event, the value is the script to call
global.__scribble_flags          = ds_map_create();  //Bidirectional lookup - stores name:index as well as index:name
global.__scribble_flags_slash    = ds_map_create();  //Bidirectional lookup - stores name:index as well as index:name
global.__scribble_tag_copy       = ds_map_create();  //Stores asset bindings; key is the name of the event, the value is the script to call
global.__scribble_alive          = ds_map_create();  //ds_map of all alive Scribble data structures
global.__scribble_global_count   = 0;
global.__scribble_default_font   = _default_font;
global.__scribble_cache_map      = ds_map_create();
global.__scribble_cache_list     = ds_list_create();

global.__scribble_default_animation_parameters = scribble_set_animation(all,   4, 50, 0.2,   4, 0.4,   0.5, 0.01);

//Duplicate GM's native colour constants in string form for access in scribble_create()
scribble_add_colour("c_aqua",    c_aqua   , true);
scribble_add_colour("c_black",   c_black  , true);
scribble_add_colour("c_blue",    c_blue   , true);
scribble_add_colour("c_dkgray",  c_dkgray , true);
scribble_add_colour("c_fuchsia", c_fuchsia, true);
scribble_add_colour("c_green",   c_green  , true);
scribble_add_colour("c_lime",    c_lime   , true);
scribble_add_colour("c_ltgray",  c_ltgray , true);
scribble_add_colour("c_maroon",  c_maroon , true);
scribble_add_colour("c_navy",    c_navy   , true);
scribble_add_colour("c_olive",   c_olive  , true);
scribble_add_colour("c_orange",  c_orange , true);
scribble_add_colour("c_purple",  c_purple , true);
scribble_add_colour("c_red",     c_red    , true);
scribble_add_colour("c_silver",  c_silver , true);
scribble_add_colour("c_teal",    c_teal   , true);
scribble_add_colour("c_white",   c_white  , true);
scribble_add_colour("c_yellow",  c_yellow , true);

//Add bindings for default flag names
//Flag slot 0 is reversed for sprites
scribble_add_flag("wave"   , 1);
scribble_add_flag("shake"  , 2);
scribble_add_flag("rainbow", 3);

//Create a vertex format for our text
vertex_format_begin();
vertex_format_add_position_3d(); //12 bytes
vertex_format_add_normal();      //12 bytes       //X = character index, Y = line index, Z = flags
vertex_format_add_colour();      // 4 bytes
vertex_format_add_texcoord();    // 8 bytes
global.__scribble_vertex_format = vertex_format_end(); //36 bytes per vertex, 108 bytes per tri, 216 bytes per glyph

//Cache uniform indexes
global.__scribble_uniform_time            = shader_get_uniform(shScribble, "u_fTime"              );
global.__scribble_uniform_colour_blend    = shader_get_uniform(shScribble, "u_vColourBlend"       );
global.__scribble_uniform_char_t          = shader_get_uniform(shScribble, "u_fCharFadeT"         );
global.__scribble_uniform_char_smoothness = shader_get_uniform(shScribble, "u_fCharFadeSmoothness");
global.__scribble_uniform_char_count      = shader_get_uniform(shScribble, "u_fCharFadeCount"     );
global.__scribble_uniform_line_t          = shader_get_uniform(shScribble, "u_fLineFadeT"         );
global.__scribble_uniform_line_smoothness = shader_get_uniform(shScribble, "u_fLineFadeSmoothness");
global.__scribble_uniform_line_count      = shader_get_uniform(shScribble, "u_fLineFadeCount"     );
global.__scribble_uniform_data_fields     = shader_get_uniform(shScribble, "u_aDataFields"        );

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
                    show_debug_message("Scribble: WARNING! Autoscan found \"" + _file + "\", but \"" + _font + "\" was not found in the project");
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