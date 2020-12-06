/// Prepares Scribble for use. This script should be called before any other Scribble scripts
/// 
/// Returns: Whether initialisation was successful
/// @param fontDirectory    The directory to look in for font .yy files, relative to the root folder that Included Files are stored in
/// @param defaultFont      The name of the default Scribble font to use, as a string
/// @param autoscan         Whether or not to automatically find font .yy files in the font directory
///                         N.B. This only works for normal fonts

function scribble_init(_font_directory, _default_font, _auto_scan)
{
    #region Internal Macro Definitions
    
	// @jujuadams
	// With thanks to glitchroy, Mark Turner, DragoniteSpam, sp202, Rob van Saaze, soVes, and @stoozey_
    #macro __SCRIBBLE_VERSION  "6.0.14a"
    #macro __SCRIBBLE_DATE     "2020-10-18"
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
	    TEXTURE,    // 7
	    U0,         // 8
	    V0,         // 9
	    U1,         //10
	    V1,         //11
	    __SIZE      //12
	}
    
	enum __SCRIBBLE_FONT
	{
	    NAME,         // 0
	    PATH,         // 1
        FAMILY_NAME,  // 2
	    TYPE,         // 3
	    GLYPHS_MAP,   // 4
	    GLYPHS_ARRAY, // 5
	    GLYPH_MIN,    // 6
	    GLYPH_MAX,    // 7
	    SPACE_WIDTH,  // 8
	    MAPSTRING,    // 9
	    SEPARATION,   //10
	    __SIZE        //11
	}
    
	enum __SCRIBBLE_FONT_TYPE
	{
	    FONT,    //0
	    SPRITE,  //1
	    RUNTIME, //2
	}
    
	enum __SCRIBBLE_PAGE
	{
	    LINES,                // 0
	    START_CHAR,           // 1
	    LAST_CHAR,            // 2
	    LINES_ARRAY,          // 3
	    VERTEX_BUFFERS_ARRAY, // 4
        START_EVENT,          // 5
        MAX_X,                // 6
        MIN_X,                // 7
        WIDTH,                // 8
        HEIGHT,               // 9
	    __SIZE
	}
    
	enum __SCRIBBLE_LINE
	{
	    START_CHAR, //0
	    LAST_CHAR,  //1
	    Y,          //2
	    WIDTH,      //3
	    HEIGHT,     //4
	    HALIGN,     //5
	    __SIZE      //6
	}
    
	enum __SCRIBBLE_VERTEX_BUFFER
	{
	    BUFFER,
	    VERTEX_BUFFER,
	    TEXTURE,
	    CHAR_START_TELL,
	    WORD_START_TELL,
	    WORD_X_OFFSET,
	    LINE_START_LIST,
	    TEXEL_WIDTH,
	    TEXEL_HEIGHT,
	    __SIZE
	}
    
	enum __SCRIBBLE_VERTEX
	{
	    X              =  0,
	    Y              =  4,
	    PACKED_INDEXES =  8,
        CENTRE_DXDY    = 12,
        SPRITE_DATA    = 16,
	    EFFECT_FLAGS   = 20,
	    COLOUR         = 24,
	    U              = 28,
	    V              = 32,
	    __SIZE         = 36
	}
    
	enum __SCRIBBLE_OCCURANCE
	{
        __SECTION0,          // 0
        PAGE,                // 1
        FADE_IN,             // 2
        SPEED,               // 3
        SKIP,                // 4
        WINDOW,              // 5
        WINDOW_ARRAY,        // 6
        METHOD,              // 7
        SMOOTHNESS,          // 8
        
        __SECTION1,          // 9
        SOUND_ARRAY,         //10
        SOUND_OVERLAP,       //11
        SOUND_PER_CHAR,      //12
        SOUND_MIN_PITCH,     //13
        SOUND_MAX_PITCH,     //14
        
        __SECTION2,
        PAUSED,              //15
        DELAY_PAUSED,        //16
        DELAY_END,           //17
        FUNCTION,            //18
        SOUND_FINISH_TIME,   //19
        DRAWN_TIME,          //10
        ANIMATION_TIME,      //20
        
        __SECTION3,
        EVENT_PREVIOUS,      //21
        EVENT_CHAR_PREVIOUS, //22
        EVENT_VISITED_ARRAY, //23
        
	    __SIZE               //24
	}
    
	enum SCRIBBLE_STATE
	{
	    STARTING_FONT,
	    STARTING_COLOR,
	    STARTING_HALIGN,
	    XSCALE,
	    YSCALE,
	    ANGLE,
	    COLOUR,
	    ALPHA,
	    LINE_MIN_HEIGHT,
	    LINE_MAX_HEIGHT,
	    MAX_WIDTH,
	    MAX_HEIGHT,
	    CHARACTER_WRAP,
	    BOX_HALIGN,
	    BOX_VALIGN,
        BOX_ALIGN_PAGE,
        FOG_COLOUR,
        FOG_BLEND,
        IGNORE_COMMAND_TAGS,
	    ANIMATION_ARRAY,
	    __SIZE
	}
    
	enum SCRIBBLE
	{
	    __SECTION0,       // 0
	    VERSION,          // 1
	    STRING,           // 2
	    CACHE_STRING,     // 3
	    DRAW_STATE,       // 4
        BEZIER_ARRAY,     // 5
	    GARBAGE_COLLECT,  // 6
        
	    __SECTION1,       // 6
	    WIDTH,            // 7
	    MIN_X,            // 8
	    MAX_X,            // 9
	    HEIGHT,           //10
	    VALIGN,           //11
	    CHARACTERS,       //12
	    LINES,            //13
	    PAGES,            //14
	    GLYPH_LTRB_ARRAY, //15
	    CHARACTER_ARRAY,  //16
        
	    __SECTION2,       //17
	    DRAWN_TIME,       //18
	    FREED,            //19
	    OCCURANCES_MAP,   //20
        
	    __SECTION3,       //21
	    PAGES_ARRAY,      //22
	    EVENT_CHAR_ARRAY, //23
	    EVENT_NAME_ARRAY, //24
	    EVENT_DATA_ARRAY, //25
        
	    __SIZE            //26
	}
    
    #macro __SCRIBBLE_ON_DIRECTX           ((os_type == os_windows) || (os_type == os_xboxone) || (os_type == os_uwp) || (os_type == os_win8native) || (os_type == os_winphone))
    #macro __SCRIBBLE_ON_OPENGL            (!__SCRIBBLE_ON_DIRECTX)
    #macro __SCRIBBLE_ON_MOBILE            ((os_type == os_ios) || (os_type == os_android) || (os_type == os_tvos))
    #macro __SCRIBBLE_ON_WEB               (os_browser != browser_not_a_browser)
    #macro __SCRIBBLE_GLYPH_BYTE_SIZE      (6*__SCRIBBLE_VERTEX.__SIZE)
    #macro __SCRIBBLE_EXPECTED_GLYPHS      100
    #macro __SCRIBBLE_EXPECTED_FRAME_TIME  (0.95*game_get_speed(gamespeed_microseconds)/1000) //Uses to prevent the autotype from advancing if a draw call is made multiple times a frame to the same text element
    #macro __SCRIBBLE_PIN_LEFT             3
    #macro __SCRIBBLE_PIN_CENTRE           4
    #macro __SCRIBBLE_PIN_RIGHT            5
    #macro __SCRIBBLE_WINDOW_COUNT         4
    
	//Deprecated
    #macro SCRIBBLE_AUTOTYPE_NONE           undefined
    #macro SCRIBBLE_AUTOTYPE_PER_CHARACTER  undefined
    #macro SCRIBBLE_AUTOTYPE_PER_LINE       undefined
    
	//Normally, Scribble will try to sequentially store glyph data in an array for fast lookup.
	//However, some font definitons may have disjointed character indexes (e.g. Chinese). Scribble will detect these fonts and use a ds_map instead for glyph data lookup
    #macro __SCRIBBLE_SEQUENTIAL_GLYPH_TRY        true
    #macro __SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE  300  //If the glyph range (min index to max index) exceeds this number, a font's glyphs will be indexed using a ds_map
    #macro __SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES  0.50 //Fraction (0 -> 1). If the number of holes exceeds this proportion, a font's glyphs will be indexed using a ds_map
    
    #macro __SCRIBBLE_MAX_LINES  1000  //Maximum number of lines in a textbox. Thise constant must match the corresponding values in shd_scribble
    
    #macro scribble_add_colour  scribble_add_color
    
    #endregion
    
	if (variable_global_exists("__scribble_lcg"))
	{
	    if (SCRIBBLE_WARNING_REINITIALIZE) show_error("Scribble:\nscribble_init() should not be called twice!\n(Set SCRIBBLE_WARNING_REINITIALIZE to <false> to hide this warning)\n ", false);
	    return false;
	}
    
	show_debug_message("Scribble: Welcome to Scribble by @jujuadams! This is version " + __SCRIBBLE_VERSION + ", " + __SCRIBBLE_DATE);
    
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
	    if ((_font_directory != "") && !directory_exists(_font_directory))
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
	global.__scribble_lcg                  = date_current_datetime()*100;
	global.__scribble_font_directory       = _font_directory;
	global.__scribble_font_data            = ds_map_create();  //Stores a data array for each font defined inside Scribble
	global.__scribble_colours              = ds_map_create();  //Stores colour definitions, including custom colours
	global.__scribble_effects              = ds_map_create();  //Bidirectional lookup - stores name:index as well as index:name
	global.__scribble_effects_slash        = ds_map_create();  //Bidirectional lookup - stores name:index as well as index:name
	global.__scribble_autotype_events      = ds_map_create();
	global.__scribble_default_font         = _default_font;
	global.__scribble_global_cache_map     = ds_map_create();
	global.__scribble_global_cache_list    = ds_list_create();
	global.__scribble_cache_test_index     = 0;
	global.__scribble_sprite_whitelist     = false;
	global.__scribble_sprite_whitelist_map = ds_map_create();
	global.__scribble_buffer               = buffer_create(1024, buffer_grow, 1);
	global.__scribble_window_array_null    = array_create(2*__SCRIBBLE_WINDOW_COUNT, 1.0);
	global.__scribble_character_delay      = false;
	global.__scribble_character_delay_map  = ds_map_create();
    global.__scribble_font_family_map      = ds_map_create();
    
	//Declare state variables
	global.scribble_state_anim_array = array_create(SCRIBBLE_ANIM.__SIZE);
	scribble_reset();
    
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
    
	global.__scribble_autotype_events[? "pause"] = undefined;
	global.__scribble_autotype_events[? "delay"] = undefined;
    
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
	global.__scribble_effects_slash[? "/wave"   ] = 1;
	global.__scribble_effects_slash[? "/shake"  ] = 2;
	global.__scribble_effects_slash[? "/rainbow"] = 3;
	global.__scribble_effects_slash[? "/wobble" ] = 4;
	global.__scribble_effects_slash[? "/pulse"  ] = 5;
	global.__scribble_effects_slash[? "/wheel"  ] = 6;
	global.__scribble_effects_slash[? "/cycle"  ] = 7;
	global.__scribble_effects_slash[? "/jitter" ] = 8;
    
	//Create a vertex format for our text
	vertex_format_begin();
	vertex_format_add_position_3d(); //12 bytes
	vertex_format_add_normal();      //12 bytes       //X = character index, Y = line index, Z = effect flags
	vertex_format_add_colour();      // 4 bytes
	vertex_format_add_texcoord();    // 8 bytes
	global.__scribble_vertex_format = vertex_format_end(); //36 bytes per vertex, 108 bytes per tri, 216 bytes per glyph
    
	vertex_format_begin();
	vertex_format_add_position(); //12 bytes
	vertex_format_add_color();    // 4 bytes
	vertex_format_add_texcoord(); // 8 bytes
	global.__scribble_passthrough_vertex_format = vertex_format_end();
    
	//Cache uniform indexes
	global.__scribble_uniform_time            = shader_get_uniform(shd_scribble, "u_fTime"                 );
	global.__scribble_uniform_colour_blend    = shader_get_uniform(shd_scribble, "u_vColourBlend"          );
	global.__scribble_uniform_fog             = shader_get_uniform(shd_scribble, "u_vFog"                  );
	global.__scribble_uniform_tw_method       = shader_get_uniform(shd_scribble, "u_fTypewriterMethod"     );
	global.__scribble_uniform_tw_window_array = shader_get_uniform(shd_scribble, "u_fTypewriterWindowArray");
	global.__scribble_uniform_tw_smoothness   = shader_get_uniform(shd_scribble, "u_fTypewriterSmoothness" );
	global.__scribble_uniform_data_fields     = shader_get_uniform(shd_scribble, "u_aDataFields"           );
    global.__scribble_uniform_bezier_array    = shader_get_uniform(shd_scribble, "u_aBezier"               );
    
	//Hex converter array
	var _min = ord("0");
	var _max = ord("f");
	global.__scribble_hex_min = _min;
	global.__scribble_hex_max = _max;
	global.__scribble_hex_array = array_create(1 + _max - _min);
	global.__scribble_hex_array[@ ord("0") - _min] =  0; //ascii  48 = array  0
	global.__scribble_hex_array[@ ord("1") - _min] =  1; //ascii  49 = array  1
	global.__scribble_hex_array[@ ord("2") - _min] =  2; //ascii  50 = array  2
	global.__scribble_hex_array[@ ord("3") - _min] =  3; //ascii  51 = array  3
	global.__scribble_hex_array[@ ord("4") - _min] =  4; //ascii  52 = array  4
	global.__scribble_hex_array[@ ord("5") - _min] =  5; //ascii  53 = array  5
	global.__scribble_hex_array[@ ord("6") - _min] =  6; //ascii  54 = array  6
	global.__scribble_hex_array[@ ord("7") - _min] =  7; //ascii  55 = array  7
	global.__scribble_hex_array[@ ord("8") - _min] =  8; //ascii  56 = array  8
	global.__scribble_hex_array[@ ord("9") - _min] =  9; //ascii  57 = array  9
	global.__scribble_hex_array[@ ord("A") - _min] = 10; //ascii  65 = array 17
	global.__scribble_hex_array[@ ord("B") - _min] = 11; //ascii  66 = array 18
	global.__scribble_hex_array[@ ord("C") - _min] = 12; //ascii  67 = array 19
	global.__scribble_hex_array[@ ord("D") - _min] = 13; //ascii  68 = array 20
	global.__scribble_hex_array[@ ord("E") - _min] = 14; //ascii  69 = array 21
	global.__scribble_hex_array[@ ord("F") - _min] = 15; //ascii  70 = array 22
	global.__scribble_hex_array[@ ord("a") - _min] = 10; //ascii  97 = array 49
	global.__scribble_hex_array[@ ord("b") - _min] = 11; //ascii  98 = array 50
	global.__scribble_hex_array[@ ord("c") - _min] = 12; //ascii  99 = array 51
	global.__scribble_hex_array[@ ord("d") - _min] = 13; //ascii 100 = array 52
	global.__scribble_hex_array[@ ord("e") - _min] = 14; //ascii 101 = array 53
	global.__scribble_hex_array[@ ord("f") - _min] = 15; //ascii 102 = array 54
    
	if (_auto_scan)
	{
	    global.__scribble_autoscanning = true;
    
		var _i = 0;
		repeat(999)
		{
		    if (!font_exists(_i)) break;
            var _name = font_get_name(_i);
            if (string_copy(_name, 1, 9) != "__newfont") scribble_add_font(_name); //Don't scan fonts created at runtime (e.g. by font_add_sprite())
		    ++_i;
		}
        
	    global.__scribble_autoscanning = false;
	}
    
	return true;
}