/// Starts initialisation for Scribble
/// This script should be called before scribble_init_font()/_scribble_init_spritefont() and scribble_init_end()
///
/// @param fontDirectory     Directory to look in (relative to game_save_id) for font .yy files
/// @param texturePageSize   Maximum surface size that Scribble uses to pack fonts
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

if ( variable_global_exists( "__scribble_init_complete" ) )
{
    show_error( "scribble_init_start() should not be called twice!\n ", false );
    exit;
}

show_debug_message( "Scribble: Welcome to Scribble! This is version " + __SCRIBBLE_VERSION + ", " + __SCRIBBLE_DATE );

var _font_directory = argument0;
var _tpage_size     = argument1;

//Fix the font directory name if it's weird
var _char = string_char_at( _font_directory, string_length( _font_directory ) );
if ( _char != "\\" ) && ( _char != "/" ) _font_directory += "\\";

//Check if the directory exists
if ( !directory_exists(_font_directory) )
{
    show_debug_message( "Scribble: WARNING! Font directory \"" + string( _font_directory ) + "\" could not be found in \"" + game_save_id + "\"!" );
}

//Check texture page size for user error
var _exp = ln(_tpage_size)/ln(2);
if ( round(_exp) != _exp )
{
    var _fixed_tpage_size = clamp( power( 2, ceil(_exp) ), 1024, 8192 );
    show_error( "Texture page size \"" + string( _tpage_size ) + "\" isn't a power of 2. Did you mean \"" + string( _fixed_tpage_size ) + "\"?\n ", false );
    _tpage_size = _fixed_tpage_size;
}

if (_tpage_size < 512) || (_tpage_size > 8192)
{
    show_error( "Texture page size \"" + string( _tpage_size ) + "\" is not supported by Scribble!\n ", true );
    exit;
}

//Declare global variables
global.__scribble_font_directory    = _font_directory;
global.__scribble_texture_page_size = _tpage_size;
global.__scribble_font_data         = ds_map_create();  //Stores a data array for each font defined inside Scribble
global.__scribble_sprites           = ds_list_create(); //Stores every sprite created during font packing
global.__scribble_spritefont_map    = ds_map_create();  //Stores a ds_map of all the spritefonts, for use with COMPATIBILITY_DRAW
global.__scribble_colours           = ds_map_create();  //Stores colour definitions, including custom colours
global.__scribble_events            = ds_map_create();  //Stores event bindings; key is the name of the event, the value is the script to call
global.__scribble_flags             = ds_map_create();  //Bidirectional lookup - stores name:index as well as index:name
global.__scribble_alive             = ds_map_create();  //ds_map of all alive Scribble data structures
global.__scribble_global_count      = 0;
global.__scribble_default_font      = "";
global.__scribble_init_complete     = false;

//Duplicate GM's native colour constants in string form for access in scribble_create()
scribble_add_colour( "c_aqua",    c_aqua    );
scribble_add_colour( "c_black",   c_black   );
scribble_add_colour( "c_blue",    c_blue    );
scribble_add_colour( "c_dkgray",  c_dkgray  );
scribble_add_colour( "c_fuchsia", c_fuchsia );
scribble_add_colour( "c_green",   c_green   );
scribble_add_colour( "c_lime",    c_lime    );
scribble_add_colour( "c_ltgray",  c_ltgray  );
scribble_add_colour( "c_maroon",  c_maroon  );
scribble_add_colour( "c_navy",    c_navy    );
scribble_add_colour( "c_olive",   c_olive   );
scribble_add_colour( "c_orange",  c_orange  );
scribble_add_colour( "c_purple",  c_purple  );
scribble_add_colour( "c_red",     c_red     );
scribble_add_colour( "c_silver",  c_silver  );
scribble_add_colour( "c_teal",    c_teal    );
scribble_add_colour( "c_white",   c_white   );
scribble_add_colour( "c_yellow",  c_yellow  );

//Add bindings for default flag names
scribble_add_flag( "wave"   , 0 );
scribble_add_flag( "shake"  , 1 );
scribble_add_flag( "rainbow", 2 );

//Create a vertex format for our text
vertex_format_begin();
vertex_format_add_position();
vertex_format_add_normal(); //X = character index, Y = line index, Z = flags
vertex_format_add_colour();
vertex_format_add_texcoord();
global.__scribble_vertex_format = vertex_format_end();

//Cache uniform indexes
global.__scribble_uniform_pma             = shader_get_uniform( shScribble, "u_fPremultiplyAlpha"   );
global.__scribble_uniform_time            = shader_get_uniform( shScribble, "u_fTime"               );
global.__scribble_uniform_colour_blend    = shader_get_uniform( shScribble, "u_vColourBlend"        );
global.__scribble_uniform_char_t          = shader_get_uniform( shScribble, "u_fCharFadeT"          );
global.__scribble_uniform_char_smoothness = shader_get_uniform( shScribble, "u_fCharFadeSmoothness" );
global.__scribble_uniform_line_t          = shader_get_uniform( shScribble, "u_fLineFadeT"          );
global.__scribble_uniform_line_smoothness = shader_get_uniform( shScribble, "u_fLineFadeSmoothness" );
global.__scribble_uniform_data_fields     = shader_get_uniform( shScribble, "u_aDataFields"         );

//Hex converter array
var _min = ord("0");
var _max = ord("f");
global.__scribble_hex_min = _min;
global.__scribble_hex_max = _max;
global.__scribble_hex_array = array_create( 1 + _max - _min );
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