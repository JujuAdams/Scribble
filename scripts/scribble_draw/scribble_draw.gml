/// Draws text using Scribble's formatting.
/// 
/// 
/// Returns: A Scribble text element (which is really a complex array)
/// @param x                   The x position in the room to draw at.
/// @param y                   The y position in the room to draw at.
/// @param string(orElement)   The text to be drawn. See below for formatting help.
///                            Alternatively, you can pass a text element into this argument from a previous call to scribble_draw() e.g. for pre-caching.
/// 
/// 
/// Formatting commands:
/// []                                  Reset formatting to defaults
/// [/page]                             Page break
/// [<name of colour>]                  Set colour
/// [#<hex code>]                       Set colour via a hexcode, using the industry standard 24-bit RGB format (#RRGGBB)
/// [/colour] [/c]                      Reset colour to the default
/// [<name of font>] [/font] [/f]       Set font / Reset font
/// [<name of sprite>]                  Insert an animated sprite starting on image 0 and animating using SCRIBBLE_DEFAULT_SPRITE_SPEED
/// [<name of sprite>,<image>]          Insert a static sprite using the specified image index
/// [<name of sprite>,<image>,<speed>]  Insert animated sprite using the specified image index and animation speed
/// [fa_left]                           Align horizontally to the left. This will insert a line break if used in the middle of a line of text
/// [fa_right]                          Align horizontally to the right. This will insert a line break if used in the middle of a line of text
/// [fa_center] [fa_centre]             Align centrally. This will insert a line break if used in the middle of a line of text
/// [scale,<factor>] [/scale] [/s]      Scale text / Reset scale to x1
/// [slant] [/slant]                    Set/unset italic emulation
/// [<event name>,<arg0>,<arg1>...]     Execute a script bound to an event name,previously defined using scribble_add_event(), with the specified arguments
/// [<effect name>] [/<effect name>]    Set/unset an effect
/// 
/// Scribble has the following formatting effects by default:
/// [wave]    [/wave]                   Set/unset text to wave up and down
/// [shake]   [/shake]                  Set/unset text to shake
/// [rainbow] [/rainbow]                Set/unset text to cycle through rainbow colours
/// [wobble]  [/wobble]                 Set/unset text to wobble by rotating back and forth
/// [pulse]   [/pulse]                  Set/unset text to shrink and grow rhythmically



var _draw_x      = argument0;
var _draw_y      = argument1;
var _draw_string = argument2;



if (!is_array(_draw_string))
{
    //Check the cache
    var _cache_string = string(_draw_string) + ":" + string(global.scribble_state_line_min_height) + ":" + string(global.scribble_state_max_width) + ":" + string(global.scribble_state_max_height);
    if (ds_map_exists(global.__scribble_global_cache_map, _cache_string))
    {
        //Grab the text element from the cache
        var _scribble_array = global.__scribble_global_cache_map[? _cache_string];
    }
    else
    {
        //Cache a new text element if we don't have a relevant one for this string
        
        //Record the start time so we can get a duration later
        var _timer_total = get_timer();
        
        //Create a couple data structures
        var _parameters_list       = ds_list_create();
        var _texture_to_buffer_map = ds_map_create();
        
        
        
        #region Process input parameters
    
        var _max_width       = is_real(global.scribble_state_max_width)? global.scribble_state_max_width : SCRIBBLE_DEFAULT_MAX_WIDTH;
        var _max_height      = is_real(global.scribble_state_max_height)? global.scribble_state_max_height : SCRIBBLE_DEFAULT_MAX_HEIGHT;
        var _line_min_height = max(0, is_real(global.scribble_state_line_min_height)? global.scribble_state_line_min_height : SCRIBBLE_DEFAULT_LINE_MIN_HEIGHT);
        var _def_colour      = SCRIBBLE_DEFAULT_TEXT_COLOUR;
        var _def_font        = global.__scribble_default_font;
        var _def_halign      = SCRIBBLE_DEFAULT_HALIGN;
    
        //Check if the default font even exists
        if (!ds_map_exists(global.__scribble_font_data, _def_font))
        {
            show_error("Scribble:\nDefault font \"" + string(_def_font) + "\" not recognised\n ", false);
            exit;
        }
        
        var _font_data         = global.__scribble_font_data[? _def_font];
        var _font_glyphs_map   = _font_data[__SCRIBBLE_FONT.GLYPHS_MAP  ];
        var _font_glyphs_array = _font_data[__SCRIBBLE_FONT.GLYPHS_ARRAY];
        var _font_glyphs_min   = _font_data[__SCRIBBLE_FONT.GLYPH_MIN   ];
        var _font_glyphs_max   = _font_data[__SCRIBBLE_FONT.GLYPH_MAX   ];
        var _font_texture      = _font_data[__SCRIBBLE_FONT.TEXTURE     ];
    
        var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
        if (_glyph_array == undefined)
        {
            show_error("Scribble:\nThe space character is missing from font definition for \"" + _def_font + "\"\n ", true);
            return undefined;
        }
        
        var _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
        var _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH];
    
        //Try to use a custom colour if the "startingColour" parameter is a string
        if (is_string(_def_colour))
        {
            var _value = global.__scribble_colours[? _def_colour];
            if (_value == undefined)
            {
                show_error("Scribble:\nThe starting colour (\"" + _def_colour + "\") has not been added as a custom colour. Defaulting to c_white.\n ", false);
                _value = c_white;
            }
            _def_colour = _value;
        }
    
        #endregion
        
        
        
        #region Create the base text element
        
        var _meta_element_characters = 0;
        var _meta_element_lines      = 0;
        var _meta_element_pages      = 0;
        var _element_width           = 0;
        var _element_height          = 0;
    
        var _scribble_array      = array_create(__SCRIBBLE.__SIZE); //The text element array
        var _element_pages_array = [];                              //Stores each page of text
    
        _scribble_array[@ __SCRIBBLE.__SECTION0            ] = "-- Parameters --";
        _scribble_array[@ __SCRIBBLE.VERSION               ] = __SCRIBBLE_VERSION;
        _scribble_array[@ __SCRIBBLE.STRING                ] = _draw_string;
        _scribble_array[@ __SCRIBBLE.CACHE_STRING          ] = _cache_string;
        _scribble_array[@ __SCRIBBLE.DEFAULT_FONT          ] = _def_font;
        _scribble_array[@ __SCRIBBLE.DEFAULT_COLOUR        ] = _def_colour;
        _scribble_array[@ __SCRIBBLE.DEFAULT_HALIGN        ] = _def_halign;
        _scribble_array[@ __SCRIBBLE.WIDTH_LIMIT           ] = _max_width;
        _scribble_array[@ __SCRIBBLE.HEIGHT_LIMIT          ] = _max_height;
        _scribble_array[@ __SCRIBBLE.LINE_HEIGHT           ] = _line_min_height;
    
        _scribble_array[@ __SCRIBBLE.__SECTION1            ] = "-- Statistics --";
        _scribble_array[@ __SCRIBBLE.WIDTH                 ] = 0;
        _scribble_array[@ __SCRIBBLE.HEIGHT                ] = 0;
        _scribble_array[@ __SCRIBBLE.CHARACTERS            ] = 0;
        _scribble_array[@ __SCRIBBLE.LINES                 ] = 0;
        _scribble_array[@ __SCRIBBLE.PAGES                 ] = 0;
        _scribble_array[@ __SCRIBBLE.GLOBAL_INDEX          ] = global.__scribble_global_count+1;
    
        _scribble_array[@ __SCRIBBLE.__SECTION2            ] = "-- State --";
        _scribble_array[@ __SCRIBBLE.ANIMATION_TIME        ] = 0;
        _scribble_array[@ __SCRIBBLE.TIME                  ] = current_time;
        _scribble_array[@ __SCRIBBLE.FREED                 ] = false;
        _scribble_array[@ __SCRIBBLE.SOUND_FINISH_TIME     ] = current_time;
    
        _scribble_array[@ __SCRIBBLE.__SECTION3            ] = "-- Pages --";
        _scribble_array[@ __SCRIBBLE.PAGES_ARRAY           ] = _element_pages_array;
        
        _scribble_array[@ __SCRIBBLE.__SECTION4            ] = "-- Autotype --";
        _scribble_array[@ __SCRIBBLE.AUTOTYPE_PAGE         ] =  0;
        _scribble_array[@ __SCRIBBLE.AUTOTYPE_FADE_IN      ] = -1;
        _scribble_array[@ __SCRIBBLE.AUTOTYPE_SPEED        ] =  0;
        _scribble_array[@ __SCRIBBLE.AUTOTYPE_POSITION     ] =  0;
        _scribble_array[@ __SCRIBBLE.AUTOTYPE_METHOD       ] = SCRIBBLE_AUTOTYPE_NONE;
        _scribble_array[@ __SCRIBBLE.AUTOTYPE_SMOOTHNESS   ] =  0;
        _scribble_array[@ __SCRIBBLE.AUTOTYPE_SOUND_ARRAY  ] = -1;
        _scribble_array[@ __SCRIBBLE.AUTOTYPE_SOUND_OVERLAP] =  0;
        
        #endregion
        
        
        
        #region Register the text element in a cache group
        
        global.__scribble_global_count++;
        global.scribble_alive[? global.__scribble_global_count] = _scribble_array;
        
        if (__SCRIBBLE_DEBUG) show_debug_message(global.scribble_state_allow_draw? ("Scribble: Caching \"" + _cache_string + "\"") : ("Scribble: Pre-caching \"" + _cache_string + "\""));
        
        //Add this text element to the global cache lookup
        global.__scribble_global_cache_map[? _cache_string] = _scribble_array;
        
        //Find this cache group's list
        //If we're using the default cache group, this list is the same as global.__scribble_global_cache_list
        var _list = global.__scribble_cache_group_map[? global.scribble_state_cache_group];
        if (_list == undefined)
        {
            //Create a new list if one doesn't already exist
            _list = ds_list_create();
            ds_map_add_list(global.__scribble_cache_group_map, global.scribble_state_cache_group, _list);
        }
        
        //Add this string to the cache group's list
        ds_list_add(_list, _cache_string);
        
        #endregion
        
        
        
        #region Add the first page to the text element
        
        var _meta_page_characters = 0;
        var _meta_page_lines      = 0;
        
        var _page_array        = array_create(__SCRIBBLE_PAGE.__SIZE);
        var _page_lines_array  = []; //Stores each line of text (per page)
        var _page_vbuffs_array = []; //Stores all the vertex buffers needed to render the text and sprites (per page)
        var _events_char_array = []; //Stores each event's triggering character
        var _events_name_array = []; //Stores each event's name
        var _events_data_array = []; //Stores each event's parameters
        
        _page_array[@ __SCRIBBLE_PAGE.LINES               ] = 0;
        _page_array[@ __SCRIBBLE_PAGE.CHARACTERS          ] = 0;
        _page_array[@ __SCRIBBLE_PAGE.LINES_ARRAY         ] = _page_lines_array;
        _page_array[@ __SCRIBBLE_PAGE.VERTEX_BUFFERS_ARRAY] = _page_vbuffs_array;
        
        _page_array[@ __SCRIBBLE_PAGE.EVENT_PREVIOUS      ] = -1;
        _page_array[@ __SCRIBBLE_PAGE.EVENT_CHAR_PREVIOUS ] = -1;
        _page_array[@ __SCRIBBLE_PAGE.EVENT_CHAR_ARRAY    ] = _events_char_array; //Stores each event's triggering character
        _page_array[@ __SCRIBBLE_PAGE.EVENT_NAME_ARRAY    ] = _events_name_array; //Stores each event's name
        _page_array[@ __SCRIBBLE_PAGE.EVENT_DATA_ARRAY    ] = _events_data_array; //Stores each event's parameters
        
        _element_pages_array[@ array_length_1d(_element_pages_array)] = _page_array;
        ++_meta_element_pages;
        
        #endregion
        
        
        
        #region Add the first line to the page
        
        var _line_has_space = false;
        var _line_width     = 0;
        var _line_height    = _line_min_height;
        
        var _line_array = array_create(__SCRIBBLE_LINE.__SIZE);
        _line_array[@ __SCRIBBLE_LINE.LAST_CHAR] = 1;
        _line_array[@ __SCRIBBLE_LINE.Y        ] = 0;
        _line_array[@ __SCRIBBLE_LINE.WIDTH    ] = _line_width;
        _line_array[@ __SCRIBBLE_LINE.HEIGHT   ] = _line_height;
        _line_array[@ __SCRIBBLE_LINE.HALIGN   ] = _def_halign;
        _page_lines_array[@ array_length_1d(_page_lines_array)] = _line_array;
        
        #endregion
        
        
        
        #region Set the initial parser state
        
        var _text_x            = 0;
        var _line_y            = 0;
        var _text_font         = _def_font;
        var _text_colour       = _def_colour;
        var _text_halign       = _def_halign;
        var _text_effect_flags = 0;
        var _text_scale        = 1;
        var _text_slant        = false;
        var _previous_texture  = -1;
        
        #endregion
        
        
        
        #region Parse the string
        
        var _command_tag_start      = -1;
        var _command_tag_parameters = 0;
        var _command_name           = "";
        var _force_newline          = false;
        var _force_newpage          = false;
        var _char_width             = 0;
        var _add_character          = true;

        //Write the string into a buffer for faster reading
        var _buffer_size = string_byte_length(_draw_string)+1;
        var _string_buffer = buffer_create(_buffer_size, buffer_fixed, 1);
        buffer_write(_string_buffer, buffer_string, _draw_string);
        buffer_seek(_string_buffer, buffer_seek_start, 0);

        //Iterate over the entire string...
        repeat(_buffer_size)
        {
            var _character_code = buffer_read(_string_buffer, buffer_u8);
            if (_character_code == 0) break;
            _add_character = true;
            
            if (_command_tag_start >= 0) //If we're in a command tag
            {
                if (_character_code == SCRIBBLE_COMMAND_TAG_CLOSE) //If we've hit a command tag close character (usually ])
                {
                    _add_character = false;
                    
                    //Increment the parameter count and place a null byte for string reading
                    ++_command_tag_parameters;
                    buffer_poke(_string_buffer, buffer_tell(_string_buffer)-1, buffer_u8, 0);
            
                    //Jump back to the start of the command tag and read out strings for the command parameters
                    buffer_seek(_string_buffer, buffer_seek_start, _command_tag_start);
                    repeat(_command_tag_parameters) ds_list_add(_parameters_list, buffer_read(_string_buffer, buffer_string));
            
                    //Reset command tag state
                    _command_tag_start = -1;
        
                    #region Command tag handling
                    
                    _command_name = _parameters_list[| 0];
                    switch(_command_name)
                    {
                        #region Reset formatting
                        case "":
                            _text_font         = _def_font;
                            _text_colour       = _def_colour;
                            _text_effect_flags = 0;
                            _text_scale        = 1;
                            _text_slant        = false;
                            
                            _font_data         = global.__scribble_font_data[? _text_font];
                            _font_glyphs_map   = _font_data[__SCRIBBLE_FONT.GLYPHS_MAP  ];
                            _font_glyphs_array = _font_data[__SCRIBBLE_FONT.GLYPHS_ARRAY];
                            _font_glyphs_min   = _font_data[__SCRIBBLE_FONT.GLYPH_MIN   ];
                            _font_glyphs_max   = _font_data[__SCRIBBLE_FONT.GLYPH_MAX   ];
                            _font_texture      = _font_data[__SCRIBBLE_FONT.TEXTURE     ];
                            
                            var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
                            _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
                            _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
                            
                            continue; //Skip the rest of the parser step
                        break;
                
                        case "/font":
                        case "/f":
                            _text_font = _def_font;
                            
                            _font_data         = global.__scribble_font_data[? _text_font];
                            _font_glyphs_map   = _font_data[__SCRIBBLE_FONT.GLYPHS_MAP  ];
                            _font_glyphs_array = _font_data[__SCRIBBLE_FONT.GLYPHS_ARRAY];
                            _font_glyphs_min   = _font_data[__SCRIBBLE_FONT.GLYPH_MIN   ];
                            _font_glyphs_max   = _font_data[__SCRIBBLE_FONT.GLYPH_MAX   ];
                            _font_texture      = _font_data[__SCRIBBLE_FONT.TEXTURE     ];
                            
                            var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
                            _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
                            _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
                    
                            continue; //Skip the rest of the parser step
                        break;
                
                        case "/colour":
                        case "/c":
                            _text_colour = _def_colour;
                    
                            continue; //Skip the rest of the parser step
                        break;
                
                        case "/scale":
                        case "/s":
                            _text_scale = 1;
                    
                            continue; //Skip the rest of the parser step
                        break;
                
                        case "/slant":
                            _text_slant = false;
                    
                            continue; //Skip the rest of the parser step
                        break;
                        #endregion
                        
                        #region Page break
                        
                        case "/page":
                            _force_newline = true;
                            _char_width = 0;
                            _force_newpage = true;
                        break;
                        
                        #endregion
                        
                        #region Scale
                        case "scale":
                            if (_command_tag_parameters <= 1)
                            {
                                show_error("Scribble:\nNot enough parameters for scale tag!", false);
                            }
                            else
                            {
                                var _text_scale = real(_parameters_list[| 1]);
                            }
                    
                            continue; //Skip the rest of the parser step
                        break;
                        #endregion
                
                        #region Slant (italics emulation)
                        case "slant":
                            _text_slant = true;
                    
                            continue; //Skip the rest of the parser step
                        break;
                        #endregion
                
                        #region Font Alignment
                
                        case "fa_left":
                            _text_halign = fa_left;
                            if (_text_x > 0)
                            {
                                _force_newline = true;
                            }
                            else
                            {
                                _line_array[@ __SCRIBBLE_LINE.HALIGN] = fa_left;
                                continue; //Skip the rest of the parser step
                            }
                        break;
                
                        case "fa_right":
                            _text_halign = fa_right;
                            if (_text_x > 0)
                            {
                                _force_newline = true;
                            }
                            else
                            {
                                _line_array[@ __SCRIBBLE_LINE.HALIGN] = fa_right;
                                continue; //Skip the rest of the parser step
                            }
                        break;
                
                        case "fa_center":
                        case "fa_centre":
                            _text_halign = fa_center;
                            if (_text_x > 0)
                            {
                                _force_newline = true;
                            }
                            else
                            {
                                _line_array[@ __SCRIBBLE_LINE.HALIGN] = fa_center;
                                continue; //Skip the rest of the parser step
                            }
                        break;
                        #endregion
                
                        default:
                            if (ds_map_exists(global.__scribble_autotype_events, _command_name))
                            {
                                #region Events
                                
                                var _data = array_create(_command_tag_parameters-1);
                                var _j = 1;
                                repeat(_command_tag_parameters-1)
                                {
                                    _data[@ _j-1] = _parameters_list[| _j];
                                    ++_j;
                                }
                                
                                var _count = array_length_1d(_events_char_array);
                                _events_char_array[@ _count] = _meta_page_characters;
                                _events_name_array[@ _count] = _command_name;
                                _events_data_array[@ _count] = _data;
                                
                                continue; //Skip the rest of the parser step
                                
                                #endregion
                            }
                            else
                            {
                                if (ds_map_exists(global.__scribble_effects, _command_name))
                                {
                                    #region Set effect
                                    
                                    _text_effect_flags = _text_effect_flags | (1 << global.__scribble_effects[? _command_name]);
                                    
                                    continue; //Skip the rest of the parser step
                                    
                                    #endregion
                                }
                                else
                                {
                                    //Check if this is a effect name, but with a forward slash at the front
                                    if (ds_map_exists(global.__scribble_effects_slash, _command_name))
                                    {
                                        #region Unset effect
                                        
                                        _text_effect_flags = ~((~_text_effect_flags) | (1 << global.__scribble_effects_slash[? _command_name]));
                                        
                                        continue; //Skip the rest of the parser step
                                        
                                        #endregion
                                    }
                                    else
                                    {
                                        if (ds_map_exists(global.__scribble_font_data, _command_name))
                                        {
                                            #region Change font
                                            
                                            _text_font = _command_name;
                                            
                                            _font_data         = global.__scribble_font_data[? _command_name];
                                            _font_glyphs_map   = _font_data[__SCRIBBLE_FONT.GLYPHS_MAP  ];
                                            _font_glyphs_array = _font_data[__SCRIBBLE_FONT.GLYPHS_ARRAY];
                                            _font_glyphs_min   = _font_data[__SCRIBBLE_FONT.GLYPH_MIN   ];
                                            _font_glyphs_max   = _font_data[__SCRIBBLE_FONT.GLYPH_MAX   ];
                                            _font_texture      = _font_data[__SCRIBBLE_FONT.TEXTURE     ];
                                            
                                            var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
                                            _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
                                            _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
                                            
                                            continue; //Skip the rest of the parser step
                                            
                                            #endregion
                                        }
                                        else
                                        {
                                            if (asset_get_type(_command_name) == asset_sprite)
                                            {
                                                #region Write sprites
                                                
                                                _line_width = max(_line_width, _text_x);
                                                
                                                var _sprite_index  = asset_get_index(_command_name);
                                                var _sprite_width  = _text_scale*sprite_get_width(_sprite_index);
                                                var _sprite_height = _text_scale*sprite_get_height(_sprite_index);
                                                var _sprite_number = sprite_get_number(_sprite_index);
                                                
                                                if (SCRIBBLE_ADD_SPRITE_ORIGINS)
                                                {
                                                    var _sprite_x = _text_x - _text_scale*sprite_get_xoffset(_sprite_index) + (_sprite_width div 2);
                                                    var _sprite_y = -_text_scale*sprite_get_yoffset(_sprite_index);
                                                }
                                                else
                                                {
                                                    var _sprite_x = _text_x;
                                                    var _sprite_y = -(_sprite_height div 2);
                                                }
                                                
                                                var _packed_indexes = _meta_page_characters*SCRIBBLE_MAX_LINES + _meta_page_lines;
                                                _char_width  = _sprite_width;
                                                _line_height = max(_line_height, _sprite_height);
                                                
                                                if (_sprite_number >= 256)
                                                {
                                                    show_debug_message("Scribble: Sprites cannot have more than 256 frames (" + string(_command_name) + ")");
                                                    _sprite_number = 256;
                                                }
                                                
                                                #region Figure out what images to add to the buffer
                                                
                                                var _image_index = 0;
                                                var _image_speed = 0;
                                                switch(_command_tag_parameters)
                                                {
                                                    case 1:
                                                        _image_index = 0;
                                                        _image_speed = SCRIBBLE_DEFAULT_SPRITE_SPEED;
                                                    break;
                                                    
                                                    case 2:
                                                        _image_index = real(_parameters_list[| 1]);
                                                        _image_speed = 0;
                                                    break;
                                                    
                                                    default:
                                                        _image_index = real(_parameters_list[| 1]);
                                                        _image_speed = real(_parameters_list[| 2]);
                                                    break;
                                                }
                                                
                                                var _colour = SCRIBBLE_COLOURISE_SPRITES? _text_colour : c_white;
                                                if (_image_speed <= 0)
                                                {
                                                    _image_speed = 0;
                                                    _sprite_number = 1;
                                                    _colour = $FF000000 | _colour;
                                                }
                                                else
                                                {
                                                    //Set the "is sprite" effect flag only if we're animating the sprite
                                                    _text_effect_flags = _text_effect_flags | 1;
                                                    
                                                    //Encode image, sprite length, and image speed into the colour channels
                                                    _colour = make_colour_rgb(0, _sprite_number-1, _image_speed*255);
                                                    
                                                    //Encode the starting image into the alpha channel
                                                    _colour = (_image_index << 24) | _colour;
                                                    
                                                    //Make sure we store all frames from the sprite
                                                    _image_index = 0;
                                                }
                                                
                                                #endregion
                                                
                                                #region Pre-create vertex buffer arrays for images for this sprite and update WORD_START_TELL at the same time
                                                
                                                var _image = _image_index;
                                                repeat(_sprite_number)
                                                {
                                                    var _sprite_texture = sprite_get_texture(_sprite_index, _image);
                                                    
                                                    var _vbuff_data = _texture_to_buffer_map[? _sprite_texture];
                                                    if (_vbuff_data == undefined)
                                                    {
                                                        var _vbuff_line_start_list = ds_list_create();
                                                        var _buffer = buffer_create(__SCRIBBLE_GLYPH_BYTE_SIZE, buffer_grow, 1);
                                                        
                                                        _vbuff_data = array_create(__SCRIBBLE_VERTEX_BUFFER.__SIZE);
                                                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.BUFFER         ] = _buffer;
                                                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER  ] = undefined;
                                                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXTURE        ] = _sprite_texture;
                                                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.CHAR_START_TELL] = 0;
                                                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = 0;
                                                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST] = _vbuff_line_start_list;
                                                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXEL_WIDTH    ] = texture_get_texel_width( _sprite_texture);
                                                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXEL_HEIGHT   ] = texture_get_texel_height(_sprite_texture);
                                                        _page_vbuffs_array[@ array_length_1d(_page_vbuffs_array)] = _vbuff_data;
                                                        
                                                        _texture_to_buffer_map[? _sprite_texture] = _vbuff_data;
                                                    }
                                                    else
                                                    {
                                                        var _buffer = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.BUFFER];
                                                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.CHAR_START_TELL] = buffer_tell(_buffer);
                                                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = buffer_tell(_buffer);
                                                        _vbuff_line_start_list = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST];
                                                    }
                                                    
                                                    //Fill link break list
                                                    var _tell = buffer_tell(_buffer);
                                                    repeat(array_length_1d(_page_lines_array) - ds_list_size(_vbuff_line_start_list)) ds_list_add(_vbuff_line_start_list, _tell);
                                                    
                                                    ++_image;
                                                }
                                                
                                                #endregion
                                                
                                                #region Add sprite to buffers
                                                
                                                var _image = _image_index;
                                                repeat(_sprite_number)
                                                {
                                                    //Swap texture and buffer if needed
                                                    var _sprite_texture = sprite_get_texture(_sprite_index, _image);
                                                    if (_sprite_texture != _previous_texture)
                                                    {
                                                        _previous_texture = _sprite_texture;
                                                        var _vbuff_data = _texture_to_buffer_map[? _sprite_texture];
                                                        var _glyph_buffer = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.BUFFER];
                                                    }
                                                    
                                                    //Find the UVs and position of the sprite quad
                                                    var _uvs = sprite_get_uvs(_sprite_index, _image);
                                                    var _quad_l = _sprite_x + _uvs[4]*_text_scale;
                                                    var _quad_t = _sprite_y + _uvs[5]*_text_scale;
                                                    var _quad_r = _quad_l   + _uvs[6]*_sprite_width;
                                                    var _quad_b = _quad_t   + _uvs[7]*_sprite_height;
                                                    
                                                    var _slant_offset = SCRIBBLE_SLANT_AMOUNT*_text_scale*_text_slant*(_quad_b - _quad_t);
                                                    
                                                    var _quad_cx = 0.5*(_quad_l + _quad_r);
                                                    var _quad_cy = 0.5*(_quad_t + _quad_b);
                                                    _quad_l -= _quad_cx;
                                                    _quad_t -= _quad_cy;
                                                    _quad_r -= _quad_cx;
                                                    _quad_b -= _quad_cy;
                                                    
                                                    //                                      Centre X                                           Centre Y                                         Character/Line Index                                                     Delta X                                                 Delta Y                                                 Flags                                                      Colour                                                 U                                                V
                                                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_l + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[0]); buffer_write(_glyph_buffer, buffer_f32, _uvs[1]);
                                                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_r                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[2]); buffer_write(_glyph_buffer, buffer_f32, _uvs[3]);
                                                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_l                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[0]); buffer_write(_glyph_buffer, buffer_f32, _uvs[3]);
                                                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_r                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[2]); buffer_write(_glyph_buffer, buffer_f32, _uvs[3]);
                                                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_l + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[0]); buffer_write(_glyph_buffer, buffer_f32, _uvs[1]);
                                                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_r + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[2]); buffer_write(_glyph_buffer, buffer_f32, _uvs[1]);
                                                    
                                                    ++_image;
                                                    if (_image_speed > 0) ++_colour;
                                                }
                                                
                                                #endregion
                                                
                                                _text_effect_flags = ~((~_text_effect_flags) | 1); //Reset animated sprite effect flag specifically
                                                ++_meta_page_characters;
                                                ++_meta_element_characters;
                                                
                                                #endregion
                                            }
                                            else
                                            {
                                                if (ds_map_exists(global.__scribble_colours, _command_name))
                                                {
                                                    #region Set a pre-defined colour
                                                    
                                                    _text_colour = global.__scribble_colours[? _command_name];
                                                    
                                                    continue; //Skip the rest of the parser step
                                                    
                                                    #endregion
                                                }
                                                else
                                                {
                                                    var _first_char = string_copy(_command_name, 1, 1);
                                                    if ((string_length(_command_name) <= 7) && ((_first_char == "$") || (_first_char == "#")))
                                                    {
                                                        #region Hex colour decoding
                                                        
                                                        var _ord = ord(string_char_at(_command_name, 3));
                                                        var _lsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                                        var _ord = ord(string_char_at(_command_name, 2));
                                                        var _hsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                                        
                                                        var _red = _lsf + (_hsf << 4);
                                                        
                                                        var _ord = ord(string_char_at(_command_name, 5));
                                                        var _lsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                                        var _ord = ord(string_char_at(_command_name, 4));
                                                        var _hsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                                        
                                                        var _green = _lsf + (_hsf << 4);
                                                        
                                                        var _ord = ord(string_char_at(_command_name, 7));
                                                        var _lsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                                        var _ord = ord(string_char_at(_command_name, 6));
                                                        var _hsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                                        
                                                        var _blue = _lsf + (_hsf << 4);
                                                        
                                                        _text_colour = make_colour_rgb(_red, _green, _blue);
                                                        
                                                        continue; //Skip the rest of the parser step
                                                        
                                                        #endregion
                                                    }
                                                    else
                                                    {
                                                        var _command_string = string(_command_name);
                                                        var _j = 1;
                                                        repeat(_command_tag_parameters-1) _command_string += "," + string(_parameters_list[| _j++]);
                                                        show_debug_message("Scribble: Warning! Unrecognised command tag [" + _command_string + "]" );
                                                        
                                                        continue; //Skip the rest of the parser step
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        break;
                    }
        
                    #endregion
                }
                else if (_character_code == SCRIBBLE_COMMAND_TAG_ARGUMENT) //If we've hit a command tag argument delimiter character (usually ,)
                {
                    //Increment the parameter count and place a null byte for string reading later
                    ++_command_tag_parameters;
                    buffer_poke(_string_buffer, buffer_tell(_string_buffer)-1, buffer_u8, 0);
                    continue;
                }
                else if ((_character_code == SCRIBBLE_COMMAND_TAG_OPEN) && (buffer_tell(_string_buffer) - _command_tag_start == 1))
                {
                    _command_tag_start = -1;
                }
                else
                {
                    //If we're in a command tag and we've not read a close character or an argument delimiter, skip everything else
                    continue;
                }
            }
            else if (_character_code == SCRIBBLE_COMMAND_TAG_OPEN) //If we've hit a command tag argument delimiter character (usually [)
            {
                //Record the start of the command tag in the string buffer
                _command_tag_start = buffer_tell(_string_buffer);
                _command_tag_parameters = 0;
                ds_list_clear(_parameters_list);
                continue;
            }
            else if ((_character_code == 10) //If we've hit a newline (\n)
                    || (SCRIBBLE_HASH_NEWLINE && (_character_code == 35)) //If we've hit a hash, and hash newlines are on
                    || ((_character_code == 13) && (buffer_peek(_string_buffer, buffer_tell(_string_buffer)+1, buffer_u8) != 10)))
            {
                _force_newline = true;
                _char_width    = 0;
                _line_width    = max(_line_width, _text_x);
                _line_height   = max(_line_height, _font_line_height*_text_scale);
                
                _add_character = false;
            }
            else if (_character_code == 32) //If we've hit a space
            {
                //Grab this characer's width/height
                _char_width     = _font_space_width*_text_scale;
                _line_has_space = true;
                _line_width     = max(_line_width, _text_x);
                _line_height    = max(_line_height, _font_line_height*_text_scale);
                
                //Iterate over all the vertex buffers we've been using and reset the word start position
                var _v = 0;
                repeat(array_length_1d(_page_vbuffs_array))
                {
                    var _data = _page_vbuffs_array[_v];
                    _data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = buffer_tell(_data[__SCRIBBLE_VERTEX_BUFFER.BUFFER]);
                    ++_v;
                }
                
                _add_character = false;
            }
            else if (_character_code < 32) //If this character code is below a space then ignore it
            {
                continue;
            }
            
            if (_add_character) //If this character is literally any other character at all
            {
                #region Decode UTF8
        
                if ((_character_code & $E0) == $C0) //two-byte
                {
                    _character_code  = (                       _character_code & $1F) <<  6;
                    _character_code += (buffer_read(_string_buffer, buffer_u8) & $3F);
                }
                else if ((_character_code & $F0) == $E0) //three-byte
                {
                    _character_code  = (                       _character_code & $0F) << 12;
                    _character_code += (buffer_read(_string_buffer, buffer_u8) & $3F) <<  6;
                    _character_code +=  buffer_read(_string_buffer, buffer_u8) & $3F;
                }
                else if ((_character_code & $F8) == $F0) //four-byte
                {
                    _character_code  = (                       _character_code & $07) << 18;
                    _character_code += (buffer_read(_string_buffer, buffer_u8) & $3F) << 12;
                    _character_code += (buffer_read(_string_buffer, buffer_u8) & $3F) <<  6;
                    _character_code +=  buffer_read(_string_buffer, buffer_u8) & $3F;
                }
        
                #endregion
        
                #region Swap texture and buffer if needed
            
                if (_font_texture != _previous_texture)
                {
                    _previous_texture = _font_texture;
                
                    var _vbuff_data = _texture_to_buffer_map[? _font_texture];
                    if (_vbuff_data == undefined)
                    {
                        var _vbuff_line_start_list = ds_list_create();
                        var _glyph_buffer = buffer_create(__SCRIBBLE_EXPECTED_GLYPHS*__SCRIBBLE_GLYPH_BYTE_SIZE, buffer_grow, 1);
                        
                        _vbuff_data = array_create(__SCRIBBLE_VERTEX_BUFFER.__SIZE);
                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.BUFFER         ] = _glyph_buffer;
                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER  ] = undefined;
                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXTURE        ] = _font_texture;
                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.CHAR_START_TELL] = 0;
                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = 0;
                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST] = _vbuff_line_start_list;
                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXEL_WIDTH    ] = texture_get_texel_width( _font_texture);
                        _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXEL_HEIGHT   ] = texture_get_texel_height(_font_texture);
                        _page_vbuffs_array[@ array_length_1d(_page_vbuffs_array)] = _vbuff_data;
                        
                        _texture_to_buffer_map[? _font_texture] = _vbuff_data;
                    }
                    else
                    {
                        var _glyph_buffer = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.BUFFER];
                        _vbuff_line_start_list = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST];
                    }
            
                    //Fill link break list
                    var _tell = buffer_tell(_glyph_buffer);
                    repeat(array_length_1d(_page_lines_array) - ds_list_size(_vbuff_line_start_list)) ds_list_add(_vbuff_line_start_list, _tell);
                }
            
                //Update CHAR_START_TELL, and WORD_START_TELL if needed
                _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.CHAR_START_TELL] = buffer_tell(_glyph_buffer);
                if (global.scribble_state_character_wrap)
                {
                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = buffer_tell(_glyph_buffer);
                    _line_width = max(_line_width, _text_x);
                }
            
                #endregion
            
                #region Add glyph
            
                if (_font_glyphs_array == undefined)
                {
                    var _glyph_array = _font_glyphs_map[? _character_code];
                }
                else
                {
                    if ((_character_code < _font_glyphs_min) || (_character_code > _font_glyphs_max)) continue;
                    var _glyph_array = _font_glyphs_array[_character_code - _font_glyphs_min];
                }
            
                if (_glyph_array != undefined)
                {
                    var _quad_l = _text_x + _glyph_array[SCRIBBLE_GLYPH.X_OFFSET]*_text_scale;
                    var _quad_t =           _glyph_array[SCRIBBLE_GLYPH.Y_OFFSET]*_text_scale - ((_font_line_height*_text_scale) div 2);
                    var _quad_r = _quad_l + _glyph_array[SCRIBBLE_GLYPH.WIDTH   ]*_text_scale;
                    var _quad_b = _quad_t + _glyph_array[SCRIBBLE_GLYPH.HEIGHT  ]*_text_scale;
                    
                    var _quad_cx = 0.5*(_quad_l + _quad_r);
                    var _quad_cy = 0.5*(_quad_t + _quad_b);
                    _quad_l -= _quad_cx;
                    _quad_t -= _quad_cy;
                    _quad_r -= _quad_cx;
                    _quad_b -= _quad_cy;
                    
                    var _packed_indexes = _meta_page_characters*SCRIBBLE_MAX_LINES + _meta_page_lines;
                    var _colour = $FF000000 | _text_colour;
                    var _slant_offset = SCRIBBLE_SLANT_AMOUNT*_text_scale*_text_slant*(_quad_b - _quad_t);
            
                    var _quad_u0 = _glyph_array[SCRIBBLE_GLYPH.U0];
                    var _quad_v0 = _glyph_array[SCRIBBLE_GLYPH.V0];
                    var _quad_u1 = _glyph_array[SCRIBBLE_GLYPH.U1];
                    var _quad_v1 = _glyph_array[SCRIBBLE_GLYPH.V1];
                    
                    //                                      Centre X                                           Centre Y                                         Character/Line Index                                                     Delta X                                                 Delta Y                                                 Flags                                                      Colour                                                  U                                                  V
                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_l + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u0); buffer_write(_glyph_buffer, buffer_f32, _quad_v0);
                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_r                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u1); buffer_write(_glyph_buffer, buffer_f32, _quad_v1);
                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_l                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u0); buffer_write(_glyph_buffer, buffer_f32, _quad_v1);
                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_r                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u1); buffer_write(_glyph_buffer, buffer_f32, _quad_v1);
                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_l + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u0); buffer_write(_glyph_buffer, buffer_f32, _quad_v0);
                    buffer_write(_glyph_buffer, buffer_f32, _quad_cx); buffer_write(_glyph_buffer, buffer_f32, _quad_cy); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _quad_r + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u1); buffer_write(_glyph_buffer, buffer_f32, _quad_v0);
                    
                    ++_meta_page_characters;
                    ++_meta_element_characters;
                    _char_width = _glyph_array[SCRIBBLE_GLYPH.SEPARATION]*_text_scale;
                }
                else
                {
                    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: scribble_draw() couldn't find glyph data for character code " + string(_character_code) + " (" + chr(_character_code) + ") in font \"" + string(_text_font) + "\"");
                }
        
                #endregion
            
                //Choose the height of a space for the character's height
                _line_height = max(_line_height, _font_line_height*_text_scale);
            }
            
            
            
            #region Handle new line creation
            
            if (_force_newline
            || ((_char_width + _text_x > _max_width) && (_max_width >= 0) && (_character_code > 32)))
            {
                var _line_offset_x = -_text_x;
                
                var _v = 0;
                repeat(array_length_1d(_page_vbuffs_array))
                {
                    var _data = _page_vbuffs_array[_v];
                    
                    var _vbuff_line_start_list = _data[__SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST];
                    var _buffer                = _data[__SCRIBBLE_VERTEX_BUFFER.BUFFER         ];
                    
                    if (_force_newline)
                    {
                        ds_list_add(_vbuff_line_start_list, buffer_tell(_buffer));
                    }
                    else
                    {
                        //If the line has no space character on it then we know that entire word is longer than the textbox max width
                        //We fall back to use the character start position for this vertex buffer instead
                        if (_line_has_space)
                        {
                            var _tell_a = _data[__SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL];
                        }
                        else
                        {
                            var _tell_a = _data[__SCRIBBLE_VERTEX_BUFFER.CHAR_START_TELL];
                        }
                        
                        var _tell_b = buffer_tell(_buffer);
                        ds_list_add(_vbuff_line_start_list, _tell_a);
                        
                        //If we've added anything to this buffer
                        if (_tell_a < _tell_b)
                        {
                            //If the line has no space character on it then we know that entire word is longer than the textbox max width
                            //We fall back to use the character start position for this vertex buffer instead
                            if (!_line_has_space)
                            {
                                //Set our word start tell position to be the same as the character start tell
                                //This allows us to handle single words that exceed the maximum textbox width multiple times (!)
                                _data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = _tell_a;
                                _line_width = max(_line_width, _text_x);
                            }
                            else
                            {
                                //If our line didn't have a space then set our word/character start position to be the current tell for this buffer
                                _data[@ __SCRIBBLE_VERTEX_BUFFER.CHAR_START_TELL] = _tell_b;
                                _data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = _tell_b;
                            }
                            
                            //Note the negative sign!
                            _line_offset_x = -(buffer_peek(_buffer, _tell_a + __SCRIBBLE_VERTEX.CENTRE_X, buffer_f32) + buffer_peek(_buffer, _tell_a + __SCRIBBLE_VERTEX.DELTA_X, buffer_f32));
                            if (_line_offset_x < 0)
                            {
                                //Retroactively move the last word to a new line
                                var _tell = _tell_a;
                                repeat((_tell_b - _tell_a) / __SCRIBBLE_VERTEX.__SIZE)
                                {
                                    //Increment the line index by 1
                                    buffer_poke(_buffer, _tell + __SCRIBBLE_VERTEX.PACKED_INDEXES, buffer_f32, buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.PACKED_INDEXES, buffer_f32) + 1             );
                                    //Adjust glyph centre position
                                    buffer_poke(_buffer, _tell + __SCRIBBLE_VERTEX.CENTRE_X      , buffer_f32, buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.CENTRE_X      , buffer_f32) + _line_offset_x);
                                    _tell += __SCRIBBLE_VERTEX.__SIZE;
                                }
                            }
                        }
                    }
                    
                    ++_v;
                }
                
                ++_meta_element_lines;
                ++_meta_page_lines;
                _element_width = max(_element_width, _line_width);
                
                //Update the last line
                _line_array[@ __SCRIBBLE_LINE.LAST_CHAR] = _meta_page_characters-1;
                _line_array[@ __SCRIBBLE_LINE.Y        ] = _line_y + (_line_height div 2);
                _line_array[@ __SCRIBBLE_LINE.WIDTH    ] = _line_width;
                _line_array[@ __SCRIBBLE_LINE.HEIGHT   ] = _line_height;
                
                //Reset state
                _text_x        += _line_offset_x;
                _line_y        += _line_height;
                _line_has_space = false;
                _line_width     = 0;
                _line_height    = _line_min_height;
                
                //Create a new line
                var _line_array = array_create(__SCRIBBLE_LINE.__SIZE);
                _line_array[@ __SCRIBBLE_LINE.LAST_CHAR] = _meta_page_characters;
                _line_array[@ __SCRIBBLE_LINE.Y        ] = _line_y;
                _line_array[@ __SCRIBBLE_LINE.WIDTH    ] = 0;
                _line_array[@ __SCRIBBLE_LINE.HEIGHT   ] = _line_min_height;
                _line_array[@ __SCRIBBLE_LINE.HALIGN   ] = _text_halign;
                _page_lines_array[@ array_length_1d(_page_lines_array)] = _line_array; //Add this line to the page
                
                _force_newline = false;
            }
    
            #endregion
            
            
            
            #region Handle new page creation
            
            if (_force_newpage
            || ((_line_height + _line_y > _max_height) && (_max_height >= 0)))
            {
                //Update the metadata of the previous page
                _page_array[@ __SCRIBBLE_PAGE.LINES     ] = _meta_page_lines;
                _page_array[@ __SCRIBBLE_PAGE.CHARACTERS] = _meta_page_characters;
                
                //Wipe the texture -> vertex buffer map
                ds_map_clear(_texture_to_buffer_map);
                
                //Create a new page
                var _new_page_array        = array_create(__SCRIBBLE_PAGE.__SIZE);
                var _new_page_lines_array  = []; //Stores each line of text (per page)
                var _new_page_vbuffs_array = []; //Stores all the vertex buffers needed to render the text and sprites (per page)
                var _events_char_array     = []; //Stores each event's triggering character
                var _events_name_array     = []; //Stores each event's name
                var _events_data_array     = []; //Stores each event's parameters
                
                _new_page_array[@ __SCRIBBLE_PAGE.LINES               ] = 1;
                _new_page_array[@ __SCRIBBLE_PAGE.CHARACTERS          ] = 0;
                _new_page_array[@ __SCRIBBLE_PAGE.LINES_ARRAY         ] = _new_page_lines_array;
                _new_page_array[@ __SCRIBBLE_PAGE.VERTEX_BUFFERS_ARRAY] = _new_page_vbuffs_array;
                
                _new_page_array[@ __SCRIBBLE_PAGE.EVENT_PREVIOUS      ] = -1;
                _new_page_array[@ __SCRIBBLE_PAGE.EVENT_CHAR_PREVIOUS ] = -1;
                _new_page_array[@ __SCRIBBLE_PAGE.EVENT_CHAR_ARRAY    ] = _events_char_array; //Stores each event's triggering character
                _new_page_array[@ __SCRIBBLE_PAGE.EVENT_NAME_ARRAY    ] = _events_name_array; //Stores each event's name
                _new_page_array[@ __SCRIBBLE_PAGE.EVENT_DATA_ARRAY    ] = _events_data_array; //Stores each event's parameters
                
                _element_pages_array[@ array_length_1d(_element_pages_array)] = _new_page_array;
                ++_meta_element_pages;
                
                if (_force_newpage)
                {
                    //Reset state
                    _text_x      = 0;
                    _line_width  = 0;
                    _line_height = _line_min_height;
                    
                    //Create a brand new line to target
                    _line_array = array_create(__SCRIBBLE_LINE.__SIZE);
                    _line_array[@ __SCRIBBLE_LINE.LAST_CHAR] = 1;
                    _line_array[@ __SCRIBBLE_LINE.WIDTH    ] = _line_width;
                    _line_array[@ __SCRIBBLE_LINE.HEIGHT   ] = _line_height;
                    _line_array[@ __SCRIBBLE_LINE.HALIGN   ] = _text_halign;
                }
                else
                {
                    //Steal the last line from the previous page
                    _page_array[@ __SCRIBBLE_PAGE.LINES]--;
                    _page_lines_array[@ array_length_1d(_page_lines_array)-1] = undefined;
                    
                    //Iterate over every vertex buffer on the previous page and steal vertices where we need to
                    var _v = 0;
                    repeat(array_length_1d(_page_vbuffs_array))
                    {
                        var _vbuff_data = _page_vbuffs_array[_v];
                        
                        var _buffer                = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.BUFFER         ];
                        var _vbuff_line_start_list = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST];
                        var _line_tell_prev        = _vbuff_line_start_list[| _meta_page_lines];
                        var _line_tell             = buffer_tell(_buffer);
                        
                        if (_line_tell_prev < _line_tell) //If we've added anything to this buffer on the previous line
                        {
                            var _bytes = _line_tell - _line_tell_prev;
                            
                            //Make a new vertex buffer for the new page
                            var _new_vbuff_data = array_create(__SCRIBBLE_VERTEX_BUFFER.__SIZE);
                            _new_page_vbuffs_array[@ array_length_1d(_new_page_vbuffs_array)] = _new_vbuff_data;
                            _texture_to_buffer_map[? _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXTURE]] = _new_vbuff_data;
                            
                            //Create new data structures
                            var _new_buffer = buffer_create(max(_bytes, __SCRIBBLE_EXPECTED_GLYPHS*__SCRIBBLE_GLYPH_BYTE_SIZE), buffer_grow, 1);
                            var _new_vbuff_line_start_list = ds_list_create();
                            ds_list_add(_new_vbuff_line_start_list, 0);
                            
                            //Fill in vertex buffer data
                            _new_vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.BUFFER         ] = _new_buffer;
                            _new_vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER  ] = undefined;
                            _new_vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXTURE        ] = _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXTURE        ];
                            _new_vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.CHAR_START_TELL] = _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.CHAR_START_TELL] - _line_tell_prev;
                            _new_vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] - _line_tell_prev;
                            _new_vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST] = _new_vbuff_line_start_list;
                            _new_vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXEL_WIDTH    ] = _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXEL_WIDTH    ];
                            _new_vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXEL_HEIGHT   ] = _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXEL_HEIGHT   ];
                            
                            //Copy the relevant vertices of the old buffer to the new buffer
                            buffer_copy(_buffer, _line_tell_prev, _bytes, _new_buffer, 0);
                            buffer_seek(_new_buffer, buffer_seek_start, _bytes);
                            
                            //Resize the old buffer to clip off the vertices we've stolen
                            buffer_resize(_buffer, _line_tell_prev);
                            buffer_seek(_buffer, buffer_seek_start, _line_tell_prev); //Resizing a buffer resets its tell
                            ds_list_delete(_vbuff_line_start_list, ds_list_size(_vbuff_line_start_list)-1);
                            
                            //Go through every vertex and set its line index to 0
                            var _tell = __SCRIBBLE_VERTEX.PACKED_INDEXES;
                            repeat(_bytes / __SCRIBBLE_VERTEX.__SIZE)
                            {
                                buffer_poke(_new_buffer, _tell, buffer_f32,
                                            SCRIBBLE_MAX_LINES*(buffer_peek(_buffer, _tell, buffer_f32) div SCRIBBLE_MAX_LINES));
                                _tell += __SCRIBBLE_VERTEX.__SIZE;
                            }
                        }
                        
                        ++_v;
                    }
                }
                
                //Add the line array to this page
                _new_page_lines_array[@ array_length_1d(_new_page_lines_array)] = _line_array;
                
                //Transfer new page variables into current page variables
                _page_array        = _new_page_array;
                _page_lines_array  = _new_page_lines_array;
                _page_vbuffs_array = _new_page_vbuffs_array;
                
                //Reset some state variables
                _element_height        = max(_element_height, _line_y);
                _meta_page_characters  =  0;
                _meta_page_lines       =  0;
                _line_y                =  0;
                _previous_texture      = -1;
                _vbuff_line_start_list = -1;
                
                _force_newpage = false;
            }
            
            #endregion
            
            
            
            _text_x += _char_width;
        }
        
        _line_width = max(_line_width, _text_x);

        _line_array[@ __SCRIBBLE_LINE.LAST_CHAR] = _meta_page_characters;
        _line_array[@ __SCRIBBLE_LINE.Y        ] = _line_y + (_line_height div 2);
        _line_array[@ __SCRIBBLE_LINE.WIDTH    ] = _line_width;
        _line_array[@ __SCRIBBLE_LINE.HEIGHT   ] = _line_height;

        ++_meta_page_lines;
        ++_meta_element_lines;
        _element_width  = max(_element_width , _line_width);
        _element_height = max(_element_height, _line_y + _line_height);

        //Update metadata
        _page_array[@ __SCRIBBLE_PAGE.LINES     ] = _meta_page_lines;
        _page_array[@ __SCRIBBLE_PAGE.CHARACTERS] = _meta_page_characters;
        
        _scribble_array[@ __SCRIBBLE.LINES     ] = _meta_element_lines;
        _scribble_array[@ __SCRIBBLE.CHARACTERS] = _meta_element_characters;
        _scribble_array[@ __SCRIBBLE.PAGES     ] = _meta_element_pages;
        _scribble_array[@ __SCRIBBLE.WIDTH     ] = _element_width;
        _scribble_array[@ __SCRIBBLE.HEIGHT    ] = _element_height;

        #endregion
        
        
        
        #region Move glyphs around on a line to finalise alignment
        
        //Iterate over every page
        var _p = 0;
        repeat(array_length_1d(_element_pages_array))
        {
            var _page_array = _element_pages_array[_p];
            _page_lines_array  = _page_array[__SCRIBBLE_PAGE.LINES_ARRAY         ];
            _page_vbuffs_array = _page_array[__SCRIBBLE_PAGE.VERTEX_BUFFERS_ARRAY];
            
            //Iterate over every vertex buffer for that page
            var _v = 0;
            repeat(array_length_1d(_page_vbuffs_array))
            {
                var _data = _page_vbuffs_array[_v];
                
                var _vbuff_line_start_list = _data[__SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST];
                var _buffer                = _data[__SCRIBBLE_VERTEX_BUFFER.BUFFER         ];
                
                var _buffer_tell = buffer_tell(_buffer);
                ds_list_add(_vbuff_line_start_list, _buffer_tell);
                
                //Iterate over every line on the page
                var _l = 0;
                repeat(ds_list_size(_vbuff_line_start_list)-1)
                {
                    var _line_data = _page_lines_array[_l];
                    if (is_array(_line_data)) //Someimtes the array can contain <undefined> if a line is moved from one page to another
                    {
                        var _line_y      = _line_data[__SCRIBBLE_LINE.Y     ];
                        var _line_halign = _line_data[__SCRIBBLE_LINE.HALIGN];
                        var _line_height = _line_data[__SCRIBBLE_LINE.HEIGHT];
                        
                        var _tell_a = _vbuff_line_start_list[| _l  ];
                        var _tell_b = _vbuff_line_start_list[| _l+1];
                        
                        //If we're not left-aligned then we need to do some work!
                        if (_line_halign != fa_left)
                        {
                            var _line_width = _line_data[__SCRIBBLE_LINE.WIDTH];
                            
                            var _offset = 0;
                            if (_line_halign == fa_right ) _offset =  _element_width - _line_width;
                            if (_line_halign == fa_center) _offset = (_element_width - _line_width) div 2;
                            
                            //We want to write to the CENTRE_X property of every vertex for horizontal alignment
                            var _tell = _tell_a + __SCRIBBLE_VERTEX.CENTRE_X;
                            repeat((_tell_b - _tell_a) / __SCRIBBLE_VERTEX.__SIZE)
                            {
                                //Poke the new value by adding the offset to the old value
                                buffer_poke(_buffer, _tell, buffer_f32, _offset + buffer_peek(_buffer, _tell, buffer_f32));
                                
                                //Now jump ahead to the next vertex. This means we're always writing to CENTRE_X!
                                _tell += __SCRIBBLE_VERTEX.__SIZE;
                            }
                        }
                        
                        //Now let's do vertical alignment by writing to CENTRE_Y
                        var _tell = _tell_a + __SCRIBBLE_VERTEX.CENTRE_Y;
                        repeat((_tell_b - _tell_a) / __SCRIBBLE_VERTEX.__SIZE)
                        {
                            //Poke the new value by adding the offset to the old value
                            buffer_poke(_buffer, _tell, buffer_f32, _line_y + buffer_peek(_buffer, _tell, buffer_f32));
                                
                            //Now jump ahead to the next vertex. This means we're always writing to CENTRE_Y!
                            _tell += __SCRIBBLE_VERTEX.__SIZE;
                        }
                    }
                    
                    ++_l;
                }
                
                //Wipe buffer start positions
                _data[@ __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST] = undefined;
                ds_list_destroy(_vbuff_line_start_list);
                
                //Create vertex buffer
                var _vertex_buffer = vertex_create_buffer_from_buffer_ext(_buffer, global.__scribble_vertex_format, 0, _buffer_tell / __SCRIBBLE_VERTEX.__SIZE);
                if (global.scribble_state_freeze) vertex_freeze(_vertex_buffer);
                _data[@ __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER] = _vertex_buffer;
                _data[@ __SCRIBBLE_VERTEX_BUFFER.BUFFER       ] = undefined;
                buffer_delete(_buffer);
                
                //Wipe CHAR_START_TELL and WORD_START_TELL
                _data[@ __SCRIBBLE_VERTEX_BUFFER.CHAR_START_TELL] = undefined;
                _data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = undefined;
                
                ++_v;
            }
            
            ++_p;
        }

        #endregion
        
        
        
        ds_map_destroy(_texture_to_buffer_map);
        buffer_delete(_string_buffer);
        ds_list_destroy(_parameters_list);
        
        
        
        if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: scribble_draw() create took " + string((get_timer() - _timer_total)/1000) + "ms");
    }
}
else
{
    var _scribble_array = _draw_string;
    
    if ((array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE)
     || (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION))
    {
        show_error("Scribble:\nArray passed to scribble_draw() is not a valid Scribble text element.\n ", false);
        return undefined;
    }
    else if (_scribble_array[__SCRIBBLE.FREED])
    {
        //This text element has had its memory freed already, ignore it
        return undefined;
    }
}



if (global.scribble_state_allow_draw)
{
    #region Draw this text element
    
    var _element_pages_array = _scribble_array[__SCRIBBLE.PAGES_ARRAY];
    var _page_array = _element_pages_array[_scribble_array[__SCRIBBLE.AUTOTYPE_PAGE]];
    
    //Figure out the left/top offset
    switch(global.scribble_state_box_halign)
    {
        case fa_center: var _left = -_scribble_array[__SCRIBBLE.WIDTH] div 2; break;
        case fa_right:  var _left = -_scribble_array[__SCRIBBLE.WIDTH];       break;
        default:        var _left = 0;                                        break;
    }
    
    switch(global.scribble_state_box_valign)
    {
        case fa_middle: var _top = -_scribble_array[__SCRIBBLE.HEIGHT] div 2; break;
        case fa_bottom: var _top = -_scribble_array[__SCRIBBLE.HEIGHT];       break;
        default:        var _top = 0;                                         break;
    }
    
    //Handle the animation timer
    var _increment_timers = ((current_time - _scribble_array[__SCRIBBLE.TIME]) > __SCRIBBLE_EXPECTED_FRAME_TIME);
    var _animation_time   = _scribble_array[__SCRIBBLE.ANIMATION_TIME];
    
    if (_increment_timers)
    {
        _animation_time += SCRIBBLE_STEP_SIZE;
        _scribble_array[@ __SCRIBBLE.ANIMATION_TIME] = _animation_time;
    }
    
    //Build a matrix to transform the text...
    if ((global.scribble_state_xscale == 1)
    &&  (global.scribble_state_yscale == 1)
    &&  (global.scribble_state_angle  == 0))
    {
        var _matrix = matrix_build(_left + _draw_x, _top + _draw_y, 0,   0,0,0,   1,1,1);
    }
    else
    {
        var _matrix = matrix_build(_left, _top, 0,   0,0,0,   1,1,1);
            _matrix = matrix_multiply(_matrix, matrix_build(_draw_x, _draw_y, 0,
                                                            0, 0, global.scribble_state_angle,
                                                            global.scribble_state_xscale, global.scribble_state_yscale, 1));
    }
    
    //...aaaand set the matrix
    var _old_matrix = matrix_get(matrix_world);
    _matrix = matrix_multiply(_matrix, _old_matrix);
    matrix_set(matrix_world, _matrix);
    
    var _page_vbuffs_array = _page_array[__SCRIBBLE_PAGE.VERTEX_BUFFERS_ARRAY];
    var _count = array_length_1d(_page_vbuffs_array);
    if (_count > 0)
    {
        var _typewriter_method = _scribble_array[__SCRIBBLE.AUTOTYPE_METHOD];
        if (_typewriter_method == SCRIBBLE_AUTOTYPE_NONE)
        {
            //If the text element's internal autotype method hasn't been set then use the global draw set state value
                _typewriter_method     = global.scribble_state_tw_method;
            var _typewriter_smoothness = global.scribble_state_tw_smoothness;
            var _typewriter_position   = global.scribble_state_tw_position;
            var _typewriter_fade_in    = global.scribble_state_tw_fade_in;
            var _typewriter_speed      = 0;
        }
        else
        {
            var _typewriter_smoothness = _scribble_array[__SCRIBBLE.AUTOTYPE_SMOOTHNESS];
            var _typewriter_position   = _scribble_array[__SCRIBBLE.AUTOTYPE_POSITION  ];
            var _typewriter_fade_in    = _scribble_array[__SCRIBBLE.AUTOTYPE_FADE_IN   ];
            var _typewriter_speed      = _scribble_array[__SCRIBBLE.AUTOTYPE_SPEED     ]*SCRIBBLE_STEP_SIZE;
            
            #region Scan for autotype events
        
            if ((_typewriter_fade_in >= 0) && (_typewriter_speed > 0))
            {
                //Find the last character we need to scan
                switch(_typewriter_method)
                {
                    case SCRIBBLE_AUTOTYPE_PER_CHARACTER:
                        var _scan_b = ceil(_typewriter_position + _typewriter_speed);
                        _scan_b = min(_scan_b, _page_array[__SCRIBBLE_PAGE.CHARACTERS]);
                    break;
                
                    case SCRIBBLE_AUTOTYPE_PER_LINE:
                        var _page_lines_array = _page_array[__SCRIBBLE_PAGE.LINES_ARRAY];
                        var _line   = _page_lines_array[min(ceil(_typewriter_position + _typewriter_speed), _page_array[__SCRIBBLE_PAGE.LINES]-1)];
                        var _scan_b = _line[__SCRIBBLE_LINE.LAST_CHAR];
                    break;
                }
            
                var _scan_a = _page_array[__SCRIBBLE_PAGE.EVENT_CHAR_PREVIOUS];
                if (_scan_b > _scan_a)
                {
                    //Play a sound effect as the text is revealed
                    var _sound_array = _scribble_array[__SCRIBBLE.AUTOTYPE_SOUND_ARRAY];
                    if (is_array(_sound_array) && (array_length_1d(_sound_array) > 0))
                    {
                        if (current_time >= _scribble_array[__SCRIBBLE.SOUND_FINISH_TIME]) 
                        {
                            global.__scribble_lcg = (48271*global.__scribble_lcg) mod 2147483647; //Lehmer
                            var _sound = _sound_array[floor(array_length_1d(_sound_array) * global.__scribble_lcg / 2147483648)];
                            audio_play_sound(_sound, 0, false);
                            _scribble_array[@ __SCRIBBLE.SOUND_FINISH_TIME] = current_time + 1000*audio_sound_length(_sound) - _scribble_array[__SCRIBBLE.AUTOTYPE_SOUND_OVERLAP];
                        }
                    }
                    
                    var _event             = _page_array[__SCRIBBLE_PAGE.EVENT_PREVIOUS  ];
                    var _events_char_array = _page_array[__SCRIBBLE_PAGE.EVENT_CHAR_ARRAY];
                    var _events_name_array = _page_array[__SCRIBBLE_PAGE.EVENT_NAME_ARRAY];
                    var _events_data_array = _page_array[__SCRIBBLE_PAGE.EVENT_DATA_ARRAY];
                    var _event_count       = array_length_1d(_events_char_array);
                
                    //Always start scanning at the next event
                    ++_event;
                    if (_event < _event_count)
                    {
                        var _event_char = _events_char_array[_event];
                        
                        //Now iterate from our current character position to the next character position
                        var _break = false;
                        var _scan = _scan_a;
                        repeat(_scan_b - _scan_a)
                        {
                            while ((_event < _event_count) && (_event_char == _scan))
                            {
                                var _script = global.__scribble_autotype_events[? _events_name_array[_event]];
                                if (_script != undefined)
                                {
                                    _page_array[@ __SCRIBBLE_PAGE.EVENT_PREVIOUS] = _event;
                                    script_execute(_script, _scribble_array, _events_data_array[_event], _scan);
                                }
                                
                                if (_scribble_array[__SCRIBBLE.AUTOTYPE_SPEED] <= 0.0)
                                {
                                    _scribble_array[@ __SCRIBBLE.AUTOTYPE_SPEED] = 0;
                                    _typewriter_speed = 0;
                                    _break = true;
                                    break;
                                }
                                
                                ++_event;
                                if (_event < _event_count) _event_char = _events_char_array[_event];
                            }
                            
                            if (_break) break;
                            ++_scan;
                        }
                        
                        if (_break && (_typewriter_method == SCRIBBLE_AUTOTYPE_PER_CHARACTER)) _typewriter_position = _scan;
                        
                        _page_array[@ __SCRIBBLE_PAGE.EVENT_CHAR_PREVIOUS] = _scan;
                    }
                    else
                    {
                        _page_array[@ __SCRIBBLE_PAGE.EVENT_CHAR_PREVIOUS] = _scan_b;
                    }
                }
            }
            
            #endregion
        }
        
        //Figure out the limit and smoothness values
        if (_typewriter_method == SCRIBBLE_AUTOTYPE_NONE)
        {
            var _typewriter_smoothness = 0;
            var _typewriter_t          = 1;
        }
        else
        {
            switch(_typewriter_method)
            {
                case SCRIBBLE_AUTOTYPE_PER_CHARACTER: var _typewriter_count = _page_array[__SCRIBBLE_PAGE.CHARACTERS]; break;
                case SCRIBBLE_AUTOTYPE_PER_LINE:      var _typewriter_count = _page_array[__SCRIBBLE_PAGE.LINES     ]; break;
            }
            
            var _typewriter_t = clamp(_typewriter_position, 0, _typewriter_count + _typewriter_smoothness);
            _typewriter_t *= 1 + _typewriter_smoothness/_typewriter_count; //Correct for smoothness
            
            //If it's been around-about a frame since we called this scripts...
            if (_increment_timers)
            {
                //...then advance the autotype position
                _scribble_array[@ __SCRIBBLE.AUTOTYPE_POSITION] = clamp(_typewriter_position + _typewriter_speed, 0, _typewriter_count);
            }
        }
        
        //Use a negative typewriter method to communicate a fade-out state to the shader
        //It's a bit hacky but it reduces the uniform count for the shader
        if (!_typewriter_fade_in) _typewriter_method = -_typewriter_method;
        
        //Set the shader and its uniforms
        shader_set(shd_scribble);
        shader_set_uniform_f(global.__scribble_uniform_time         , _animation_time);
        shader_set_uniform_f(global.__scribble_uniform_z            , SCRIBBLE_Z);
        
        shader_set_uniform_f(global.__scribble_uniform_tw_method    , _typewriter_method);
        shader_set_uniform_f(global.__scribble_uniform_tw_smoothness, _typewriter_smoothness);
        shader_set_uniform_f(global.__scribble_uniform_tw_t         , _typewriter_t);
        
        shader_set_uniform_f(global.__scribble_uniform_colour_blend , colour_get_red(  global.scribble_state_colour)/255,
                                                                      colour_get_green(global.scribble_state_colour)/255,
                                                                      colour_get_blue( global.scribble_state_colour)/255,
                                                                      global.scribble_state_alpha);
        
        shader_set_uniform_f_array(global.__scribble_uniform_data_fields, global.scribble_state_anim_array);
        
        //Now iterate over the text element's vertex buffers and submit them
        var _i = 0;
        repeat(_count)
        {
            var _vbuff_data = _page_vbuffs_array[_i];
            shader_set_uniform_f(global.__scribble_uniform_texel, _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.TEXEL_WIDTH], _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.TEXEL_HEIGHT]);
            vertex_submit(_vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER], pr_trianglelist, _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.TEXTURE]);
            ++_i;
        }
        
        shader_reset();
    }
    
    //Make sure we reset the world matrix
    matrix_set(matrix_world, _old_matrix);
    
    #endregion
    
    
    
    //Update when this text element was last drawn
    _scribble_array[@ __SCRIBBLE.TIME] = current_time;
}



#region Check to see if we need to free some memory from the global cache list

if (SCRIBBLE_CACHE_TIMEOUT > 0)
{
    var _size = ds_list_size(global.__scribble_global_cache_list);
    if (_size > 0)
    {
        //Scan through the cache to see if any text elements have elapsed
        global.__scribble_cache_test_index = (global.__scribble_cache_test_index + 1) mod _size;
        var _cache_string = global.__scribble_global_cache_list[| global.__scribble_cache_test_index];
        var _cache_array = global.__scribble_global_cache_map[? _cache_string];
        
        if (!is_array(_cache_array)
        || (array_length_1d(_cache_array) != __SCRIBBLE.__SIZE)
        || (_cache_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION)
        || _cache_array[__SCRIBBLE.FREED])
        {
            if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: \"" + _cache_string + "\" exists in cache but doesn't exist elsewhere");
            ds_list_delete(global.__scribble_global_cache_list, global.__scribble_cache_test_index);
        }
        else if (_cache_array[__SCRIBBLE.TIME] + SCRIBBLE_CACHE_TIMEOUT < current_time)
        {
            if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: Removing \"" + _cache_string + "\" from cache");
            
            var _element_pages_array = _cache_array[__SCRIBBLE.PAGES_ARRAY];
            var _p = 0;
            repeat(array_length_1d(_element_pages_array))
            {
                var _page_array = _element_pages_array[_p];
                var _vertex_buffers_array = _page_array[__SCRIBBLE_PAGE.VERTEX_BUFFERS_ARRAY];
                var _v = 0;
                repeat(array_length_1d(_vertex_buffers_array))
                {
                    var _vbuff_data = _vertex_buffers_array[_v];
                    var _vbuff = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER];
                    vertex_delete_buffer(_vbuff);
                    ++_v;
                }
                ++_p;
            }
            
            _cache_array[@ __SCRIBBLE.FREED] = true;
            
            //Remove reference from cache
            ds_map_delete(global.__scribble_global_cache_map, _cache_string);
            ds_list_delete(global.__scribble_global_cache_list, global.__scribble_cache_test_index);
            
            //Remove global reference
            ds_map_delete(global.scribble_alive, _cache_array[__SCRIBBLE.GLOBAL_INDEX]);
        }
    }
}

#endregion



return _scribble_array;