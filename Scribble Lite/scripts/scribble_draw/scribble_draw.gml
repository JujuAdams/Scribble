/// Draws text using Scribble's formatting.
/// 
/// 
/// @param x             The x position in the room to draw at.
/// @param y             The y position in the room to draw at.
/// @param string        The text to be drawn. See below for formatting help.
/// @param [cacheGroup]  The cache group that stores the Scribble data. If this argument is unused or is <undefined>, the default cache group will be used instead.
/// 
/// 
/// 
/// Formatting commands:
/// []                                  Reset formatting to defaults
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
/// [<flag name>] [/<flag name>]        Set/unset a custom shader format flag
/// 
/// Scribble has the following formatting flags as defaults:
/// [wave]    [/wave]                   Set/unset text to wave up and down
/// [shake]   [/shake]                  Set/unset text to shake
/// [rainbow] [/rainbow]                Set/unset text to cycle through rainbow colours
/// 
/// 
/// Scribble uses cache groups to help manage memory. Scribble text that has been added to a cache group will be automatically destroyed if...
/// 1) scribble_flush() has been called targetting the text's cache group
/// 2) or the text has not been drawn for a period of time (SCRIBBLE_CACHE_TIMEOUT milliseconds).
/// By default, all Scribble data is put into the same cache group: SCRIBBLE_DEFAULT_CACHE_GROUP. You can specify a different cache group
/// to manage memory more easily (e.g. one cache group for dialogue, another for an inventory screen). Setting SCRIBBLE_CACHE_TIMEOUT to 0
/// halts all time-based memory management; instead, you'll need to manually call scribble_flush(), targetting the relevant cache group(s).
/// 
/// If you're manually creating Scribble data structures by calling scribble_create() directly, you can choose to opt out of using the cache.
/// By setting the "cacheGroup" argument to <undefined>, Scribble will skip adding the data to the cache. However, this means that the data
/// you create *will not be automatically destroyed*. To free memory you will have to call scribble_flush() manually, using the Scribble text
/// array as the argument.
/// 
/// To track how much Scribble data exists at any one time, call ds_map_size(global.scribble_alive).



var _draw_x      = argument[0];
var _draw_y      = argument[1];
var _draw_string = argument[2];
var _cache_group = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : SCRIBBLE_DEFAULT_CACHE_GROUP;



//Check the cache
var _cache_string = string(_draw_string) + ":" + string(global.scribble_state_line_min_height) + ":" + string(global.scribble_state_max_width);
if (ds_map_exists(global.__scribble_global_cache_map, _cache_string))
{
    //Grab the Scribble data structure, and update the TIME property
    var _scribble_array = global.__scribble_global_cache_map[? _cache_string];
    _scribble_array[@ __SCRIBBLE.TIME] = current_time;
}
else
{
    //Cache a new data structure if we don't have a relevant one for this string
    var _timer_total = get_timer();
    
    
    
    #region Process input parameters
    
    var _max_width       = is_real(global.scribble_state_max_width)? global.scribble_state_max_width : SCRIBBLE_DEFAULT_MAX_WIDTH;
    var _line_min_height = is_real(global.scribble_state_line_min_height)? global.scribble_state_line_min_height : SCRIBBLE_DEFAULT_LINE_MIN_HEIGHT;
    var _def_colour      = global.scribble_state_start_colour;
    var _def_font        = global.scribble_state_start_font;
    var _def_halign      = global.scribble_state_start_halign;
    
    //Check if the default font even exists
    if (!ds_map_exists(global.__scribble_font_data, _def_font))
    {
        show_error("Scribble:\n\"" + string(_def_font) + "\" not recognised as a font\n ", false);
        var _def_font = global.__scribble_default_font;
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
        exit;
    }
    
    var _def_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH]; //Find the default font's space width
    if (_line_min_height < 0) _line_min_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT]; //Find the default line minimum height if not specified
    
    var _font_line_height = _line_min_height;
    var _font_space_width = _def_space_width;
    
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
    
    
    
    #region Create the data structure
    
    var _scribble_array        = array_create(__SCRIBBLE.__SIZE); //The main data structure
    var _line_list             = ds_list_create(); //Stores each line of text
    var _vertex_buffer_list    = ds_list_create(); //Stores all the vertex buffers needed to render the text and sprites
    var _events_char_array     = array_create(0);  //Stores each event's triggering character
    var _events_name_array     = array_create(0);  //Stores each event's name
    var _events_data_array     = array_create(0);  //Stores each event's parameters
    var _texture_to_buffer_map = ds_map_create();
    
    _scribble_array[@ __SCRIBBLE.__SECTION0        ] = "-- Parameters --";
    _scribble_array[@ __SCRIBBLE.VERSION           ] = __SCRIBBLE_VERSION;
    _scribble_array[@ __SCRIBBLE.STRING            ] = _draw_string;
    _scribble_array[@ __SCRIBBLE.DEFAULT_FONT      ] = _def_font;
    _scribble_array[@ __SCRIBBLE.DEFAULT_COLOUR    ] = _def_colour;
    _scribble_array[@ __SCRIBBLE.DEFAULT_HALIGN    ] = _def_halign;
    _scribble_array[@ __SCRIBBLE.WIDTH_LIMIT       ] = _max_width;
    _scribble_array[@ __SCRIBBLE.LINE_HEIGHT       ] = _line_min_height;
    
    _scribble_array[@ __SCRIBBLE.__SECTION1        ] = "-- Statistics --";
    _scribble_array[@ __SCRIBBLE.WIDTH             ] = 0;
    _scribble_array[@ __SCRIBBLE.HEIGHT            ] = 0;
    _scribble_array[@ __SCRIBBLE.CHARACTERS        ] = 0;
    _scribble_array[@ __SCRIBBLE.LINES             ] = 0;
    _scribble_array[@ __SCRIBBLE.GLOBAL_INDEX      ] = global.__scribble_global_count+1;
    
    _scribble_array[@ __SCRIBBLE.__SECTION2        ] = "-- State --";
    _scribble_array[@ __SCRIBBLE.ANIMATION_TIME    ] = 0;
    _scribble_array[@ __SCRIBBLE.TIME              ] = current_time;
    _scribble_array[@ __SCRIBBLE.FREED             ] = false;
    
    _scribble_array[@ __SCRIBBLE.__SECTION3        ] = "-- Lists --";
    _scribble_array[@ __SCRIBBLE.LINE_LIST         ] = _line_list;
    _scribble_array[@ __SCRIBBLE.VERTEX_BUFFER_LIST] = _vertex_buffer_list;
    
    _scribble_array[@ __SCRIBBLE.__SECTION4        ] = "-- Events --";
    _scribble_array[@ __SCRIBBLE.EVENT_CHAR_ARRAY  ] = _events_char_array; //Stores each event's triggering cha
    _scribble_array[@ __SCRIBBLE.EVENT_NAME_ARRAY  ] = _events_name_array; //Stores each event's name
    _scribble_array[@ __SCRIBBLE.EVENT_DATA_ARRAY  ] = _events_data_array; //Stores each event's parameters
    
    #endregion
    
    
    
    #region Register the data structure in a cache group
    
    global.__scribble_global_count++;
    global.scribble_alive[? global.__scribble_global_count] = _scribble_array;
    
    if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: Caching \"" + _cache_string + "\"");
    
    //Add this Scribble data structure to the global cache lookup
    if (_cache_group == SCRIBBLE_DEFAULT_CACHE_GROUP) global.__scribble_global_cache_map[? _cache_string] = _scribble_array;
    
    //Find this cache group's list
    var _list = global.__scribble_cache_group_map[? _cache_group];
    if (_list == undefined)
    {
        //Create a new list if one doesn't already exist
        _list = ds_list_create();
        ds_map_add_list(global.__scribble_cache_group_map, _cache_group, _list);
    }
    
    //Add this string to the cache group's list
    ds_list_add(_list, _cache_string);
    
    #endregion
    
    
    
    #region Parse the string

    #region Initial parser state

    var _parameters_list = ds_list_create();

    var _text_x      = 0;
    var _text_y      = 0;
    var _text_font   = _def_font;
    var _text_colour = _def_colour;
    var _text_halign = _def_halign;
    var _text_flags  = 0;
    var _text_scale  = 1;
    var _text_slant  = false;

    var _line_width  = 0;
    var _line_height = _line_min_height;

    var _line_array = array_create(__SCRIBBLE_LINE.__SIZE);
    _line_array[@ __SCRIBBLE_LINE.LAST_CHAR] = 1;
    _line_array[@ __SCRIBBLE_LINE.WIDTH    ] = _line_width;
    _line_array[@ __SCRIBBLE_LINE.HEIGHT   ] = _line_height;
    _line_array[@ __SCRIBBLE_LINE.HALIGN   ] = _def_halign;
    ds_list_add(_line_list, _line_array);

    #endregion

    var _meta_characters = 0;
    var _meta_lines      = 0;
    var _text_x_max      = 0;
    var _text_y_max      = 0;

    var _command_tag_start      = -1;
    var _command_tag_parameters = 0;
    var _command_name           = "";
    var _previous_texture       = -1;
    var _force_newline          = false;
    var _char_width             = 0;

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
    
        if (_command_tag_start >= 0) //If we're in a command tag
        {
            if (_character_code == SCRIBBLE_COMMAND_TAG_CLOSE) //If we've hit a command tag close character (usually ])
            {
                //Increment the parameter count and place a null byte for string reading
                ++_command_tag_parameters;
                buffer_poke(_string_buffer, buffer_tell(_string_buffer)-1, buffer_u8, 0);
            
                //Jump back to the start of the command tag and read out strings for the command parameters
                buffer_seek(_string_buffer, buffer_seek_start, _command_tag_start);
                repeat(_command_tag_parameters) ds_list_add(_parameters_list, buffer_read(_string_buffer, buffer_string));
            
                //Reset command tag state
                _command_tag_start = -1;
        
                #region Command tag handling
        
                #region Replace tags
            
                if (_command_tag_parameters == 1)
                {
                    var _replacement_list = global.__scribble_tag_copy[? _parameters_list[|0]];
                    if (_replacement_list != undefined)
                    {
                        ds_list_clear(_parameters_list);
                        ds_list_copy(_parameters_list, _replacement_list);
                        _command_tag_parameters = ds_list_size(_parameters_list);
                    }
                }
            
                #endregion
            
                _command_name = _parameters_list[| 0];
                switch(_command_name)
                {
                    #region Reset formatting
                    case "":
                        _text_font        = _def_font;
                        _text_colour      = _def_colour;
                        _text_flags       = 0;
                        _text_scale       = 1;
                        _text_slant       = false;
                    
                        _font_line_height = _line_min_height;
                        _font_space_width = _def_space_width;
                    
                        continue; //Skip the rest of the parser step
                    break;
                
                    case "/font":
                    case "/f":
                        _text_font        = _def_font;
                        _font_line_height = _line_min_height;
                        _font_space_width = _def_space_width;
                    
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
                        if (_text_x > 0) _force_newline = true else continue; //Skip the rest of the parser step
                    break;
                
                    case "fa_right":
                        _text_halign = fa_right;
                        if (_text_x > 0) _force_newline = true else continue; //Skip the rest of the parser step
                    break;
                
                    case "fa_center":
                    case "fa_centre":
                        _text_halign = fa_center;
                        if (_text_x > 0) _force_newline = true else continue; //Skip the rest of the parser step
                    break;
                    #endregion
                
                    default:
                        if (ds_map_exists(global.__scribble_events, _command_name))
                        {
                            #region Events
                        
                            var _data = array_create(_command_tag_parameters-1);
                            var _j = 1;
                            repeat(_command_tag_parameters)
                            {
                                _data[@ _j-1] = _parameters_list[| _j];
                                ++_j;
                            }
                        
                            var _count = array_length_1d(_events_char_array);
                            _events_char_array[@ _count] = _meta_characters;
                            _events_name_array[@ _count] = _command_name;
                            _events_data_array[@ _count] = _data;
                        
                            continue; //Skip the rest of the parser step
                        
                            #endregion
                        }
                        else
                        {
                            if (ds_map_exists(global.__scribble_flags, _command_name))
                            {
                                #region Set flag
                            
                                _text_flags = _text_flags | (1 << global.__scribble_flags[? _command_name]);
                            
                                continue; //Skip the rest of the parser step
                            
                                #endregion
                            }
                            else
                            {
                                //Check if this is a flag name, but with a forward slash at the front
                                if (ds_map_exists(global.__scribble_flags_slash, _command_name))
                                {
                                    #region Unset flag
                                
                                    _text_flags = ~((~_text_flags) | (1 << global.__scribble_flags_slash[? _command_name]));
                                
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
                                        
                                            var _sprite_index  = asset_get_index(_command_name);
                                            var _sprite_x      = _text_x + sprite_get_xoffset(_sprite_index);
                                            var _sprite_y      = _text_y + sprite_get_yoffset(_sprite_index);
                                            var _sprite_width  = _text_scale*sprite_get_width(_sprite_index);
                                            var _sprite_height = _text_scale*sprite_get_height(_sprite_index);
                                            var _sprite_number = sprite_get_number(_sprite_index);
                            
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
                                            if ((_image_speed <= 0) || SCRIBBLE_FORCE_NO_SPRITE_ANIMATION)
                                            {
                                                _image_speed = 0;
                                                _sprite_number = 1;
                                                _colour = $FF000000 | _colour;
                                            }
                                            else
                                            {
                                                //Set the "is sprite" flag only if we're animating the sprite
                                                _text_flags = _text_flags | 1;
                                
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
                                                    var _line_break_list = ds_list_create();
                                                    var _buffer = buffer_create(__SCRIBBLE_GLYPH_BYTE_SIZE, buffer_grow, 1);
                                    
                                                    _vbuff_data = array_create(__SCRIBBLE_VERTEX_BUFFER.__SIZE);
                                                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.BUFFER         ] = _buffer;
                                                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER  ] = undefined;
                                                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXTURE        ] = _sprite_texture;
                                                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = 0;
                                                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST] = _line_break_list;
                                                    ds_list_add(_vertex_buffer_list, _vbuff_data);
                                        
                                                    _texture_to_buffer_map[? _sprite_texture] = _vbuff_data;
                                                }
                                                else
                                                {
                                                    var _buffer = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.BUFFER];
                                                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = buffer_tell(_buffer);
                                                }
                                
                                                //Fill link break list
                                                var _tell = buffer_tell(_buffer);
                                                repeat(ds_list_size(_line_list) - ds_list_size(_line_break_list)) ds_list_add(_line_break_list, _tell);
                                
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
                                                var _glyph_l = _sprite_x + _uvs[4];
                                                var _glyph_t = _sprite_y + _uvs[5];
                                                var _glyph_r = _glyph_l  + _uvs[6]*_sprite_width;
                                                var _glyph_b = _glyph_t  + _uvs[7]*_sprite_height;
                                
                                                //                                          X                                                  Y                                                  Z                                                       character %                                                line %                                               flags                                                  colour                                                 U                                                V
                                                buffer_write(_glyph_buffer, buffer_f32, _glyph_l); buffer_write(_glyph_buffer, buffer_f32, _glyph_t); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[0]); buffer_write(_glyph_buffer, buffer_f32, _uvs[1]);
                                                buffer_write(_glyph_buffer, buffer_f32, _glyph_l); buffer_write(_glyph_buffer, buffer_f32, _glyph_b); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[0]); buffer_write(_glyph_buffer, buffer_f32, _uvs[3]);
                                                buffer_write(_glyph_buffer, buffer_f32, _glyph_r); buffer_write(_glyph_buffer, buffer_f32, _glyph_b); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[2]); buffer_write(_glyph_buffer, buffer_f32, _uvs[3]);
                                                buffer_write(_glyph_buffer, buffer_f32, _glyph_r); buffer_write(_glyph_buffer, buffer_f32, _glyph_b); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[2]); buffer_write(_glyph_buffer, buffer_f32, _uvs[3]);
                                                buffer_write(_glyph_buffer, buffer_f32, _glyph_r); buffer_write(_glyph_buffer, buffer_f32, _glyph_t); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[2]); buffer_write(_glyph_buffer, buffer_f32, _uvs[1]);
                                                buffer_write(_glyph_buffer, buffer_f32, _glyph_l); buffer_write(_glyph_buffer, buffer_f32, _glyph_t); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[0]); buffer_write(_glyph_buffer, buffer_f32, _uvs[1]);
                                
                                                ++_image;
                                                if (_image_speed > 0) ++_colour;
                                            }
                        
                                            #endregion
                            
                                            _text_flags = ~((~_text_flags) | 1); //Reset animated sprite flag specifically
                                            ++_meta_characters;
                                        
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
                                                if ((string_length(_command_name) <= 7) && (string_copy(_command_name, 1, 1) == "$"))
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
                                                    var _j = 0;
                                                    repeat(_command_tag_parameters-1) _command_string += "," + string(_parameters_list[| _j++]);
                                                    show_debug_message("Scribble: WARNING! Unrecognised command tag [" + _command_string + "]" );
                                                
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
            _char_width = 0;
            _line_height = max(_line_height, _font_line_height*_text_scale);
        }
        else if (_character_code == 32) //If we've hit a space
        {
            //Grab this characer's width/height
            _char_width  = _font_space_width*_text_scale;
            _line_height = max(_line_height, _font_line_height*_text_scale);
        
            //Iterate over all the vertex buffers we've been using and reset the word start position
            var _v = 0;
            repeat(ds_list_size(_vertex_buffer_list))
            {
                var _data = _vertex_buffer_list[| _v];
                _data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = buffer_tell(_data[__SCRIBBLE_VERTEX_BUFFER.BUFFER]);
                ++_v;
            }
        }
        else if (_character_code < 32)//If this character code is below a space then ignore it
        {
            continue;
        }
        else//If this character is literally any other character at all
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
                    var _line_break_list = ds_list_create();
                    var _glyph_buffer = buffer_create(__SCRIBBLE_EXPECTED_GLYPHS*__SCRIBBLE_GLYPH_BYTE_SIZE, buffer_grow, 1);
                
                    _vbuff_data = array_create(__SCRIBBLE_VERTEX_BUFFER.__SIZE);
                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.BUFFER         ] = _glyph_buffer;
                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER  ] = undefined;
                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.TEXTURE        ] = _font_texture;
                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = 0;
                    _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST] = _line_break_list;
                    ds_list_add(_vertex_buffer_list, _vbuff_data);
                    
                    _texture_to_buffer_map[? _font_texture] = _vbuff_data;
                }
                else
                {
                    var _glyph_buffer = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.BUFFER];
                }
            
                //Fill link break list
                var _tell = buffer_tell(_glyph_buffer);
                repeat(ds_list_size(_line_list) - ds_list_size(_line_break_list)) ds_list_add(_line_break_list, _tell);
            }
            
            //Update WORD_START_TELL
            _vbuff_data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = buffer_tell(_glyph_buffer);
            
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
                var _glyph_l = _text_x  + _glyph_array[SCRIBBLE_GLYPH.X_OFFSET]*_text_scale;
                var _glyph_t = _text_y  + _glyph_array[SCRIBBLE_GLYPH.Y_OFFSET]*_text_scale;
                var _glyph_r = _glyph_l + _glyph_array[SCRIBBLE_GLYPH.WIDTH   ]*_text_scale;
                var _glyph_b = _glyph_t + _glyph_array[SCRIBBLE_GLYPH.HEIGHT  ]*_text_scale;
            
                var _colour = $FF000000 | _text_colour;
                var _slant_offset = SCRIBBLE_SLANT_AMOUNT*_text_scale*_text_slant*(_glyph_b - _glyph_t);
            
                var _glyph_u0  = _glyph_array[SCRIBBLE_GLYPH.U0];
                var _glyph_v0  = _glyph_array[SCRIBBLE_GLYPH.V0];
                var _glyph_u1  = _glyph_array[SCRIBBLE_GLYPH.U1];
                var _glyph_v1  = _glyph_array[SCRIBBLE_GLYPH.V1];
            
                //                                                  X                                                        Y                                                  Z                                                       character %                                               line %                                                flags                                                  colour                                                   U                                                  V
                buffer_write(_glyph_buffer, buffer_f32, _glyph_l+_slant_offset); buffer_write(_glyph_buffer, buffer_f32, _glyph_t); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _glyph_u0); buffer_write(_glyph_buffer, buffer_f32, _glyph_v0);
                buffer_write(_glyph_buffer, buffer_f32, _glyph_l              ); buffer_write(_glyph_buffer, buffer_f32, _glyph_b); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _glyph_u0); buffer_write(_glyph_buffer, buffer_f32, _glyph_v1);
                buffer_write(_glyph_buffer, buffer_f32, _glyph_r              ); buffer_write(_glyph_buffer, buffer_f32, _glyph_b); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _glyph_u1); buffer_write(_glyph_buffer, buffer_f32, _glyph_v1);
                buffer_write(_glyph_buffer, buffer_f32, _glyph_r              ); buffer_write(_glyph_buffer, buffer_f32, _glyph_b); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _glyph_u1); buffer_write(_glyph_buffer, buffer_f32, _glyph_v1);
                buffer_write(_glyph_buffer, buffer_f32, _glyph_r+_slant_offset); buffer_write(_glyph_buffer, buffer_f32, _glyph_t); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _glyph_u1); buffer_write(_glyph_buffer, buffer_f32, _glyph_v0);
                buffer_write(_glyph_buffer, buffer_f32, _glyph_l+_slant_offset); buffer_write(_glyph_buffer, buffer_f32, _glyph_t); buffer_write(_glyph_buffer, buffer_f32, SCRIBBLE_Z);    buffer_write(_glyph_buffer, buffer_f32, _meta_characters); buffer_write(_glyph_buffer, buffer_f32, _meta_lines); buffer_write(_glyph_buffer, buffer_f32, _text_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _glyph_u0); buffer_write(_glyph_buffer, buffer_f32, _glyph_v0);
                
                ++_meta_characters;
                _char_width = _glyph_array[SCRIBBLE_GLYPH.SEPARATION]*_text_scale;
            }
            else
            {
                if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: scribble_create() couldn't find glyph data for character code " + string(_character_code) + " (" + chr(_character_code) + ") in font \"" + string(_text_font) + "\"");
            }
        
            #endregion
            
            //Choose the height of a space for the character's height
            _line_height = max(_line_height, _font_line_height*_text_scale);
        }
    
        #region Handle new line creation
    
        if (_force_newline || ((_char_width + _text_x > _max_width) && (_max_width >= 0)))
        {
            var _v = 0;
            repeat(ds_list_size(_vertex_buffer_list))
            {
                var _data = _vertex_buffer_list[| _v];
            
                var _line_break_list = _data[__SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST];
                var _buffer          = _data[__SCRIBBLE_VERTEX_BUFFER.BUFFER         ];
                var _tell_b          = buffer_tell(_buffer);
            
                if (_force_newline)
                {
                    ds_list_add(_line_break_list, _tell_b);
                }
                else
                {
                    var _tell_a = _data[__SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL];
                    ds_list_add(_line_break_list, _tell_a);
                
                    if (_tell_a < _tell_b)
                    {
                        //Retroactively move the last word to a new line
                        var _tell = _tell_a + __SCRIBBLE_VERTEX.X;
                        repeat((_tell_b - _tell_a) / __SCRIBBLE_VERTEX.__SIZE)
                        {
                            buffer_poke(_buffer, _tell, buffer_f32, buffer_peek(_buffer, _tell, buffer_f32) - _text_x);
                        
                            _tell += __SCRIBBLE_VERTEX.Y - __SCRIBBLE_VERTEX.X;
                            buffer_poke(_buffer, _tell, buffer_f32, buffer_peek(_buffer, _tell, buffer_f32) + _line_height);
                        
                            _tell += __SCRIBBLE_VERTEX.NY - __SCRIBBLE_VERTEX.Y;
                            buffer_poke(_buffer, _tell, buffer_f32, _meta_lines+1);
                        
                            _tell += __SCRIBBLE_VERTEX.X + __SCRIBBLE_VERTEX.__SIZE - __SCRIBBLE_VERTEX.NY;
                        }
                    }
                }
            
                _data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = _tell_b;
            
                ++_v;
            }
        
            ++_meta_lines;
            _text_x_max = max(_text_x_max, _line_width);
        
            //Update the last line
            _line_array[@ __SCRIBBLE_LINE.LAST_CHAR] = _meta_characters-1;
            _line_array[@ __SCRIBBLE_LINE.WIDTH    ] = _line_width;
            _line_array[@ __SCRIBBLE_LINE.HEIGHT   ] = _line_height;
        
            //Create a new line
            var _line_array = array_create(__SCRIBBLE_LINE.__SIZE);
            _line_array[@ __SCRIBBLE_LINE.LAST_CHAR] = _meta_characters;
            _line_array[@ __SCRIBBLE_LINE.WIDTH    ] = 0;
            _line_array[@ __SCRIBBLE_LINE.HEIGHT   ] = _line_min_height;
            _line_array[@ __SCRIBBLE_LINE.HALIGN   ] = _text_halign;
            ds_list_add(_line_list, _line_array);
        
            //Reset state
            _text_x      = 0;
            _text_y      = _text_y + _line_height;
            _line_width  = 0;
            _line_height = _line_min_height;
        
            _force_newline = false;
        }
    
        #endregion
    
        _text_x += _char_width;
        _line_width = max(_line_width, _text_x);
    }

    _line_array[@ __SCRIBBLE_LINE.LAST_CHAR] = _meta_characters;
    _line_array[@ __SCRIBBLE_LINE.WIDTH    ] = _line_width;
    _line_array[@ __SCRIBBLE_LINE.HEIGHT   ] = _line_height;

    ++_meta_lines;
    _text_x_max = max(_text_x_max, _line_width);
    _text_y_max = _text_y + _line_height;

    //Fill out metadata
    _scribble_array[@ __SCRIBBLE.LINES     ] = _meta_lines;
    _scribble_array[@ __SCRIBBLE.CHARACTERS] = _meta_characters;
    _scribble_array[@ __SCRIBBLE.WIDTH     ] = _text_x_max;
    _scribble_array[@ __SCRIBBLE.HEIGHT    ] = _text_y_max;

    #endregion
    
    
    
    #region Move glyphs around on a line to finalise alignment

    var _v = 0;
    repeat(ds_list_size(_vertex_buffer_list))
    {
        var _data = _vertex_buffer_list[| _v];
    
        var _line_break_list = _data[__SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST];
        var _buffer          = _data[__SCRIBBLE_VERTEX_BUFFER.BUFFER         ];
    
        var _buffer_tell = buffer_tell(_buffer);
        ds_list_add(_line_break_list, _buffer_tell);
    
        var _l = 0;
        repeat(ds_list_size(_line_break_list)-1)
        {
            var _line_data = _line_list[| _l];
            var _line_halign = _line_data[__SCRIBBLE_LINE.HALIGN];
        
            if (_line_halign != fa_left)
            {
                var _line_width = _line_data[__SCRIBBLE_LINE.WIDTH ];
            
                var _offset = 0;
                if (_line_halign == fa_right ) _offset =  _text_x_max - _line_width;
                if (_line_halign == fa_center) _offset = (_text_x_max - _line_width) div 2;
            
                var _tell_a = _line_break_list[| _l  ];
                var _tell_b = _line_break_list[| _l+1];
            
                var _tell = _tell_a + __SCRIBBLE_VERTEX.X;
                repeat((_tell_b - _tell_a)/__SCRIBBLE_VERTEX.__SIZE)
                {
                    buffer_poke(_buffer, _tell, buffer_f32, _offset + buffer_peek(_buffer, _tell, buffer_f32));
                    _tell += __SCRIBBLE_VERTEX.__SIZE;
                }
            }
        
            ++_l;
        }
    
        //Wipe buffer start positions
        _data[@ __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST] = undefined;
        ds_list_destroy(_line_break_list);
    
        //Create vertex buffer
        _data[@ __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER  ] = vertex_create_buffer_from_buffer_ext(_buffer, global.__scribble_vertex_format, 0, _buffer_tell / __SCRIBBLE_VERTEX.__SIZE);
        _data[@ __SCRIBBLE_VERTEX_BUFFER.BUFFER         ] = undefined;
        buffer_delete(_buffer);
    
        //Wipe WORD_START_TELL
        _data[@ __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = undefined;
    
        ++_v;
    }

    #endregion
    
    
    
    ds_map_destroy(_texture_to_buffer_map);
    buffer_delete(_string_buffer);
    ds_list_destroy(_parameters_list);
    
    
    
    if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: scribble_create() took " + string((get_timer() - _timer_total)/1000) + "ms");
}



#region Draw this Scribble data structure

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

var _old_matrix = matrix_get(matrix_world);
_matrix = matrix_multiply(_matrix, _old_matrix);
matrix_set(matrix_world, _matrix);

var _animation_time = _scribble_array[__SCRIBBLE.ANIMATION_TIME] + SCRIBBLE_STEP_SIZE;
_scribble_array[@ __SCRIBBLE.ANIMATION_TIME] = _animation_time;

var _vbuff_list = _scribble_array[__SCRIBBLE.VERTEX_BUFFER_LIST];
var _count = ds_list_size(_vbuff_list);
if (_count > 0)
{
    shader_set(shScribble);
    shader_set_uniform_f(global.__scribble_uniform_time           , _animation_time);
    
    shader_set_uniform_f(global.__scribble_uniform_char_t         , 1.0);
    shader_set_uniform_f(global.__scribble_uniform_char_smoothness, 0.0);
    shader_set_uniform_f(global.__scribble_uniform_char_count     , _scribble_array[__SCRIBBLE.CHARACTERS]);
    
    shader_set_uniform_f(global.__scribble_uniform_line_t         , 1.0);
    shader_set_uniform_f(global.__scribble_uniform_line_smoothness, 0.0);
    shader_set_uniform_f(global.__scribble_uniform_line_count     , _scribble_array[__SCRIBBLE.LINES]);
    
    shader_set_uniform_f(global.__scribble_uniform_colour_blend   , colour_get_red(  global.scribble_state_colour)/255,
                                                                    colour_get_green(global.scribble_state_colour)/255,
                                                                    colour_get_blue( global.scribble_state_colour)/255,
                                                                    global.scribble_state_alpha);
        
    shader_set_uniform_f_array(global.__scribble_uniform_data_fields, global.scribble_state_anim_array);
    
    var _i = 0;
    repeat(_count)
    {
        var _vbuff_data = _vbuff_list[| _i];
        vertex_submit(_vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER], pr_trianglelist, _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.TEXTURE]);
        ++_i;
    }
    
    shader_reset();
}

matrix_set(matrix_world, _old_matrix);

#endregion



#region Check to see if we need to free some memory from the global cache list

if (SCRIBBLE_CACHE_TIMEOUT > 0)
{
    var _size = ds_list_size(global.__scribble_global_cache_list);
    if (_size > 0)
    {
        //Scan through the cache to see if any scribble data structures have elapsed
        global.__scribble_cache_test_index = (global.__scribble_cache_test_index + 1) mod _size;
        var _cache_string = global.__scribble_global_cache_list[| global.__scribble_cache_test_index];
        var _scribble_array = global.__scribble_global_cache_map[? _cache_string];
        
        if (!is_array(_scribble_array)
        || (array_length_1d(_scribble_array) != __SCRIBBLE.__SIZE)
        || (_scribble_array[__SCRIBBLE.VERSION] != __SCRIBBLE_VERSION)
        || _scribble_array[__SCRIBBLE.FREED])
        {
            if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: \"" + _cache_string + "\" exists in cache but doesn't exist elsewhere");
            ds_list_delete(global.__scribble_global_cache_list, global.__scribble_cache_test_index);
        }
        else if (_scribble_array[__SCRIBBLE.TIME] + SCRIBBLE_CACHE_TIMEOUT < current_time)
        {
            if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: Removing \"" + _cache_string + "\" from cache");
            
            //Free data (basically a duplicate of scribble_flush)
            var _vbuff_list = _scribble_array[__SCRIBBLE.VERTEX_BUFFER_LIST];
            var _count = ds_list_size(_vbuff_list);
            for(var _i = 0; _i < _count; _i++)
            {
                var _vbuff_data = _vbuff_list[| _i];
                var _vbuff = _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER];
                vertex_delete_buffer(_vbuff);
            }
            
            ds_list_destroy(_scribble_array[@ __SCRIBBLE.LINE_LIST]);
            ds_list_destroy(_vbuff_list);
            
            _scribble_array[@ __SCRIBBLE.FREED] = true;
            
            //Remove reference from cache
            ds_map_delete(global.__scribble_global_cache_map,_cache_string);
            ds_list_delete(global.__scribble_global_cache_list, global.__scribble_cache_test_index);
            
            //Remove global reference
            ds_map_delete(global.scribble_alive, _scribble_array[__SCRIBBLE.GLOBAL_INDEX]);
        }
    }
}

#endregion



return _scribble_array;