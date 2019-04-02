/// Parses a string and turns it into a Scribble data structure that can be drawn with scribble_draw()
///
/// @param string              The string to be parsed. See below for the various in-line formatting commands
/// @param [minLineHeight]     The minimum line height for each line of text. Defaults to the height of a space character of the default font
/// @param [maxLineWidth]      The maximum line width for each line of text. Use a negative number for no limit. Defaults to no limit
/// @param [startingColour]    The (initial) blend colour for the text. Defaults to white
/// @param [startingFont]      The (initial) font for the text. The font name should be provided as a string. Defaults to Scribble's global default font (the first font added during initialisation)
/// @param [startingHAlign]    The (initial) horizontal alignment for the test. Defaults to left justified
/// @param [dataFieldsArray]   The data field array that'll be passed into the shader to control various effects. Defaults to values set in __scribble_config()
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.
///
/// Formatting commands:
/// []                                Reset formatting to defaults
/// [<name of colour>]                Set colour
/// [#<hex code>]                     Set colour via a hexcode, using normal RGB values (#RRGGBB)
/// [/colour]                         Reset colour to the default
/// [/c]                              As above
/// [<name of font>]                  Set font
/// [/font]                           Reset font to the default
/// [/f]                              As above
/// [<name of sprite>,<image>]        Insert a static sprite using the specified image index
/// [fa_left]                         Align horizontally to the left
/// [fa_right]                        Align horizontally to the right
/// [fa_center]                       Align centrally
/// [fa_centre]                       As above
/// [scale,<factor>]                  Scale text
/// [/scale]                          Reset scaling to 1
/// [/s]                              As above
/// [wave]                            Set text to wave up and down
/// [/wave]                           Unset wave animation
/// [shake]                           Set text to shake
/// [/shake]                          Unset shake animation
/// [rainbow]                         Set text to cycle through rainbow colours
/// [/rainbow]                        Unset rainbow animation
/// [slant]                           Set italic emulation
/// [/slant]                          Unset italic emulation
/// [<flag name>]                     Set a custom formatting flag
/// [/<flag name>]                    Unset a custom formatting flag
/// [event,<name>,<arg0>,<arg1>...]   Execute a script bound to an event name (previously defined using scribble_add_event()) with the specified arguments
/// [ev,<name>,<arg0>,<arg1>...]      As above



if ( !variable_global_exists("__scribble_init_complete") )
{
    show_error("scribble_create() should be called after initialising Scribble.\n ", false);
    exit;
}

if (!global.__scribble_init_complete)
{
    show_error("scribble_create() should be called after initialising Scribble.\n ", false);
    exit;
}

var _timer = get_timer();

var _str              = argument[0];
var _line_min_height  = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : -1;
var _width_limit      = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : -1;
var _def_colour       = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : c_white;
var _def_font         = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : global.__scribble_default_font;
var _def_halign       = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : fa_left;
var _data_fields_in   = ((argument_count > 6) &&    is_array(argument[6])  )? argument[6] : undefined;



#region Process input parameters

//Strip out weird newlines
if (SCRIBBLE_FIX_NEWLINES)
{
    _str = string_replace_all(_str, "\n\r", "\n");
    _str = string_replace_all(_str, "\r\n", "\n");
    _str = string_replace_all(_str,   "\n", "\n");
    _str = string_replace_all(_str,  "\\n", "\n");
    _str = string_replace_all(_str,  "\\r", "\n");
}

if (SCRIBBLE_HASH_NEWLINE) _str = string_replace_all(_str, "#", "\n");

//Check if the default font even exists
if ( !ds_map_exists(global.__scribble_font_data, _def_font) )
{
    show_error("\"" + string(_def_font) + "\" not recognised as a font\n ", false);
    var _def_font = global.__scribble_default_font;
}

var _font_data = global.__scribble_font_data[? _def_font ];
var _font_glyphs_array = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_ARRAY ];
if (_font_glyphs_array == undefined)
{
    var _font_glyphs_map = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_MAP ];
    var _array           = _font_glyphs_map[? " " ];
}
else
{
    var _array = _font_glyphs_array[ 32 - _font_data[ __E_SCRIBBLE_FONT.GLYPH_MIN ] ];
    if (_array == undefined)
    {
        show_error("The space character is missing from font definition for \"" + _def_font + "\"\n ", true);
        exit;
    }
}

//Find the default font's space width
var _def_space_width = _array[ __E_SCRIBBLE_GLYPH.W ];

//Find the default line minimum height if not specified
if (_line_min_height < 0) _line_min_height = _array[ __E_SCRIBBLE_GLYPH.H ];

//Try to use a custom colour if the "startingColour" parameter is a string
if ( is_string(_def_colour) )
{
    var _value = global.__scribble_colours[? _def_colour ];
    if (_value == undefined)
    {
        show_error("The starting colour (\"" + _def_colour + "\") has not been added as a custom colour. Defaulting to c_white.\n ", false);
        _value = c_white;
    }
    _def_colour = _value;
}

//Build an array that contains data that'll (eventually) get sent into the shader
var _data_fields = array_create(SCRIBBLE_MAX_DATA_FIELDS);
if ( is_array(_data_fields_in) )
{
    var _length = array_length_1d(_data_fields_in);
    if (_length > SCRIBBLE_MAX_DATA_FIELDS)
    {
        show_error("Length of custom data field array (" + string(_length) + ") is greater than SCRIBBLE_MAX_DATA_FIELDS (" + string(SCRIBBLE_MAX_DATA_FIELDS) + ")\n ", false);
        _length = SCRIBBLE_MAX_DATA_FIELDS;
    }
    array_copy(_data_fields, 0, _data_fields_in, 0, _length);
}
else
{
    _data_fields[0] = SCRIBBLE_DEFAULT_WAVE_SIZE;
    _data_fields[1] = SCRIBBLE_DEFAULT_WAVE_FREQUENCY;
    _data_fields[2] = SCRIBBLE_DEFAULT_WAVE_SPEED;
    _data_fields[3] = SCRIBBLE_DEFAULT_SHAKE_SIZE;
    _data_fields[4] = SCRIBBLE_DEFAULT_SHAKE_SPEED;
    _data_fields[5] = SCRIBBLE_DEFAULT_RAINBOW_WEIGHT;
}

#endregion



#region Break down string into sections using a buffer

var _separator_list  = ds_list_create();
var _position_list   = ds_list_create();
var _parameters_list = ds_list_create();

var _buffer_size = string_byte_length(_str)+1;
var _buffer = buffer_create(_buffer_size, buffer_grow, 1);

buffer_write(_buffer, buffer_string, _str);
buffer_seek(_buffer, buffer_seek_start, 0);

var _in_command_tag = false;
var _i = 0;
repeat(_buffer_size)
{
    var _value = buffer_peek(_buffer, _i, buffer_u8);
    
    if (_value == 0) //<null>
    {
        ds_list_add(_separator_list, "");
        ds_list_add(_position_list, _i);
        break;
    }
    
    if (_in_command_tag)
    {
        if (_value == SCRIBBLE_COMMAND_TAG_CLOSE) || (_value == SCRIBBLE_COMMAND_TAG_ARGUMENT)
        {
            if (_value == SCRIBBLE_COMMAND_TAG_CLOSE) _in_command_tag = false;
            buffer_poke(_buffer, _i, buffer_u8, 0);
            ds_list_add(_separator_list, _value);
            ds_list_add(_position_list, _i);
        }
    }
    else
    {
        if (_value == 10) || (_value == 32) || (_value == SCRIBBLE_COMMAND_TAG_OPEN) //\n or <space> or a command tag open character
        {
            if (_value == SCRIBBLE_COMMAND_TAG_OPEN) _in_command_tag = true;
            buffer_poke(_buffer, _i, buffer_u8, 0);
            ds_list_add(_separator_list, _value);
            ds_list_add(_position_list, _i);
        }
    }
    
    ++_i;
}

#endregion



#region Create the data structure

var _json                  = ds_list_create(); //The main data structure
var _text_root_list        = ds_list_create(); //Stores each line of text
var _vbuff_list            = ds_list_create(); //Stores all the vertex buffers needed to render the text and sprites
var _events_character_list = ds_list_create(); //Stores each event's triggering character
var _events_name_list      = ds_list_create(); //Stores each event's name
var _events_data_list      = ds_list_create(); //Stores each event's parameters

global.__scribble_global_count++;
global.__scribble_alive[? global.__scribble_global_count ] = _json;

_json[| __E_SCRIBBLE.__SIZE                  ] = __SCRIBBLE_VERSION;

_json[| __E_SCRIBBLE.__SECTION0              ] = "-- Parameters --";
_json[| __E_SCRIBBLE.STRING                  ] = _str;
_json[| __E_SCRIBBLE.DEFAULT_FONT            ] = _def_font;
_json[| __E_SCRIBBLE.DEFAULT_COLOUR          ] = _def_colour;
_json[| __E_SCRIBBLE.DEFAULT_HALIGN          ] = _def_halign;
_json[| __E_SCRIBBLE.WIDTH_LIMIT             ] = _width_limit;
_json[| __E_SCRIBBLE.LINE_HEIGHT             ] = _line_min_height;

_json[| __E_SCRIBBLE.__SECTION1              ] = "-- Statistics --";
_json[| __E_SCRIBBLE.HALIGN                  ] = SCRIBBLE_DEFAULT_BOX_HALIGN;
_json[| __E_SCRIBBLE.VALIGN                  ] = SCRIBBLE_DEFAULT_BOX_VALIGN;
_json[| __E_SCRIBBLE.WIDTH                   ] = 0;
_json[| __E_SCRIBBLE.HEIGHT                  ] = 0;
_json[| __E_SCRIBBLE.LEFT                    ] = 0;
_json[| __E_SCRIBBLE.TOP                     ] = 0;
_json[| __E_SCRIBBLE.RIGHT                   ] = 0;
_json[| __E_SCRIBBLE.BOTTOM                  ] = 0;
_json[| __E_SCRIBBLE.LENGTH                  ] = 0;
_json[| __E_SCRIBBLE.LINES                   ] = 0;
_json[| __E_SCRIBBLE.WORDS                   ] = 0;
_json[| __E_SCRIBBLE.GLOBAL_INDEX            ] = global.__scribble_global_count;

_json[| __E_SCRIBBLE.__SECTION2              ] = "-- Typewriter --";
_json[| __E_SCRIBBLE.TW_DIRECTION            ] = 0;
_json[| __E_SCRIBBLE.TW_SPEED                ] = SCRIBBLE_DEFAULT_TYPEWRITER_SPEED;
_json[| __E_SCRIBBLE.TW_POSITION             ] = 0;
_json[| __E_SCRIBBLE.TW_METHOD               ] = SCRIBBLE_DEFAULT_TYPEWRITER_METHOD;
_json[| __E_SCRIBBLE.TW_SMOOTHNESS           ] = SCRIBBLE_DEFAULT_TYPEWRITER_SMOOTHNESS;
_json[| __E_SCRIBBLE.CHAR_FADE_T             ] = 1;
_json[| __E_SCRIBBLE.LINE_FADE_T             ] = 1;

_json[| __E_SCRIBBLE.__SECTION3              ] = "-- Animation --";
_json[| __E_SCRIBBLE.HAS_CALLED_STEP         ] = false;
_json[| __E_SCRIBBLE.NO_STEP_COUNT           ] = 0;
_json[| __E_SCRIBBLE.DATA_FIELDS             ] = _data_fields;
_json[| __E_SCRIBBLE.ANIMATION_TIME          ] = 0;

_json[| __E_SCRIBBLE.__SECTION4              ] = "-- Lists --";
_json[| __E_SCRIBBLE.LINE_LIST               ] = _text_root_list;
_json[| __E_SCRIBBLE.VERTEX_BUFFER_LIST      ] = _vbuff_list;

_json[| __E_SCRIBBLE.__SECTION5              ] = "-- Events --";
_json[| __E_SCRIBBLE.EV_CHARACTER_LIST       ] = _events_character_list; //Stores each event's triggering cha
_json[| __E_SCRIBBLE.EV_NAME_LIST            ] = _events_name_list;      //Stores each event's name
_json[| __E_SCRIBBLE.EV_DATA_LIST            ] = _events_data_list;      //Stores each event's parameters
_json[| __E_SCRIBBLE.EV_TRIGGERED_LIST       ] = ds_list_create();
_json[| __E_SCRIBBLE.EV_TRIGGERED_MAP        ] = ds_map_create();
_json[| __E_SCRIBBLE.EV_VALUE_MAP            ] = ds_map_create();
_json[| __E_SCRIBBLE.EV_CHANGED_MAP          ] = ds_map_create();
_json[| __E_SCRIBBLE.EV_PREVIOUS_MAP         ] = ds_map_create();
_json[| __E_SCRIBBLE.EV_DIFFERENT_MAP        ] = ds_map_create();

//Now bind the child data structures to the root list
ds_list_mark_as_list(_json, __E_SCRIBBLE.LINE_LIST         );
ds_list_mark_as_list(_json, __E_SCRIBBLE.VERTEX_BUFFER_LIST);
ds_list_mark_as_list(_json, __E_SCRIBBLE.EV_CHARACTER_LIST );
ds_list_mark_as_list(_json, __E_SCRIBBLE.EV_NAME_LIST      );
ds_list_mark_as_list(_json, __E_SCRIBBLE.EV_DATA_LIST      );
ds_list_mark_as_list(_json, __E_SCRIBBLE.EV_TRIGGERED_LIST );
ds_list_mark_as_map( _json, __E_SCRIBBLE.EV_TRIGGERED_MAP  );
ds_list_mark_as_map( _json, __E_SCRIBBLE.EV_VALUE_MAP      );
ds_list_mark_as_map( _json, __E_SCRIBBLE.EV_CHANGED_MAP    );
ds_list_mark_as_map( _json, __E_SCRIBBLE.EV_PREVIOUS_MAP   );
ds_list_mark_as_map( _json, __E_SCRIBBLE.EV_DIFFERENT_MAP  );

#endregion



#region Parse the string

#region Initial parser state

var _text_x = 0;
var _text_y = 0;

var _word_array           = noone;
var _line_array           = noone;
var _line_words_array     = noone;
var _line_length          = 0;
var _line_prev_last_index = 0;
var _line_max_height      = _line_min_height;

var _text_font            = _def_font;
var _text_colour          = _def_colour;
var _text_halign          = _def_halign;
var _text_flags           = array_create(SCRIBBLE_MAX_FLAGS, 0);
var _text_scale           = 1;
var _text_slant           = false;

var _font_line_height     = _line_min_height;
var _font_space_width     = _def_space_width;

#endregion

//Iterate over the entire string...
var _sep_char = 0;
var _in_command_tag = false;
var _new_word = false;

var _separator_count = ds_list_size(_separator_list);
for(var _i = 0; _i < _separator_count; _i++)
{
    var _sep_prev_char = _sep_char;
        _sep_char = _separator_list[| _i ];
    
    if (_new_word) _word_array[@ __E_SCRIBBLE_WORD.NEXT_SEPARATOR ] = _sep_char;
    _new_word = false;
    
    var _input_substr = buffer_read(_buffer, buffer_string);
    var _substr = _input_substr;
    
    #region Reset state
    
    var _skip          = false;
    var _force_newline = false;
    var _new_word      = false;
    
    var _substr_width       = 0;
    var _substr_height      = 0;
    var _substr_length      = string_length(_input_substr);
    var _substr_sprite      = noone;
    var _substr_image       = undefined;
    var _substr_image_speed = 0;
    _text_flags[@ 0] = false; //Reset sprite flag specifically
    
    var _first_character = (is_array(_line_words_array) && (array_length_1d(_line_words_array) <= 1));
    
    #endregion
    
    if (_in_command_tag)
    {
        #region Command tag handling
        
        ds_list_add(_parameters_list, _input_substr);
        
        if (_sep_char != SCRIBBLE_COMMAND_TAG_CLOSE) // ]
        {
            continue;
        }
        else
        {
            _substr_length = 0;
            
            switch(_parameters_list[| 0 ])
            {
                #region Reset formatting
                case "":
                    _text_font        = _def_font;
                    _text_colour      = _def_colour;
                    _text_flags       = array_create(SCRIBBLE_MAX_FLAGS, 0);
                    _text_scale       = 1;
                    _text_slant       = false;
                    
                    _font_line_height = _line_min_height;
                    _font_space_width = _def_space_width;
                    _skip = true;
                break;
                
                case "/font":
                case "/f":
                    _text_font        = _def_font;
                    _font_line_height = _line_min_height;
                    _font_space_width = _def_space_width;
                    _skip = true;
                break;
                
                case "/colour":
                case "/c":
                    _text_colour = _def_colour;
                    _skip = true;
                break;
                
                case "/scale":
                case "/s":
                    _text_scale = 1;
                    _skip = true;
                break;
                
                case "/slant":
                    _text_slant = false;
                    _skip = true;
                break;
                #endregion
                
                #region Scale
                case "scale":
                    var _parameter_count = ds_list_size(_parameters_list);
                    if (_parameter_count <= 1)
                    {
                        show_error("Not enough parameters for scale tag!", false);
                    }
                    else
                    {
                        var _text_scale = real(_parameters_list[| 1]);
                    }
                    
                    _skip = true;
                break;
                #endregion
                
                #region Slant (italics emulation)
                case "slant":
                    _text_slant = true;
                    _skip = true;
                break;
                #endregion
                
                #region Events
                case "event":
                case "ev":
                    var _parameter_count = ds_list_size(_parameters_list);
                    if (_parameter_count <= 1)
                    {
                        show_error("Not enough parameters for event!", false);
                        _skip = true;
                    }
                    else
                    {
                        var _name = _parameters_list[| 1];
                        var _data = array_create(_parameter_count-2, "");
                        for(var _j = 2; _j < _parameter_count; _j++) _data[ _j-2 ] = _parameters_list[| _j ];
                
                        ds_list_add(_events_character_list, _json[| __E_SCRIBBLE.LENGTH ]);
                        ds_list_add(_events_name_list     , _name                        );
                        ds_list_add(_events_data_list     , _data                        );
                    }
                    
                    _skip = true;
                break;
                #endregion
                
                #region Font Alignment
                
                case "fa_left":
                    _text_halign = fa_left;
                    _substr = "";
                    
                    if (_first_character)
                    {
                        if (_line_array != noone) _line_array[@ __E_SCRIBBLE_LINE.HALIGN ] = _text_halign;
                    }
                    else
                    {
                        _force_newline = true;
                    }
                break;
                
                case "fa_right":
                    _text_halign = fa_right;
                    _substr = "";
                    
                    if (_first_character)
                    {
                        if (_line_array != noone) _line_array[@ __E_SCRIBBLE_LINE.HALIGN ] = _text_halign;
                    }
                    else
                    {
                        _force_newline = true;
                    }
                break;
                
                case "fa_center":
                case "fa_centre":
                    _text_halign = fa_center;
                    _substr = "";
                    
                    if (_first_character)
                    {
                        if (_line_array != noone) _line_array[@ __E_SCRIBBLE_LINE.HALIGN ] = _text_halign;
                    }
                    else
                    {
                        _force_newline = true;
                    }
                break;
                #endregion
                
                #region Flags, fonts, sprites, and colours
                default:
                    //Check if this is a flag name
                    var _flag_index = global.__scribble_flags[? _parameters_list[| 0] ];
                    if (_flag_index != undefined)
                    {
                        _text_flags[ _flag_index ] = true;
                        _skip = true;
                    }
                    else
                    {
                        //Check if this is a flag name, but with a forward slash at the front
                        var _flag_index = undefined;
                        if (string_char_at(_parameters_list[| 0], 1) == "/") _flag_index = global.__scribble_flags[? string_delete(_parameters_list[| 0], 1, 1) ];
                        if (_flag_index != undefined)
                        {
                            _text_flags[ _flag_index ] = false;
                            _skip = true;
                        }
                        else
                        {
                            var _font_data = global.__scribble_font_data[? _parameters_list[| 0] ];
                            if (_font_data != undefined)
                            {
                                #region Change font
                                
                                _text_font = _parameters_list[| 0];
                        
                                var _font_glyphs_array = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_ARRAY ];
                                if (_font_glyphs_array == undefined)
                                {
                                    var _font_glyphs_map = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_MAP ];
                                    var _array           = _font_glyphs_map[? " " ];
                                }
                                else
                                {
                                    var _array = _font_glyphs_array[ 32 - _font_data[ __E_SCRIBBLE_FONT.GLYPH_MIN ] ];
                                }
                        
                                _font_space_width = _array[ __E_SCRIBBLE_GLYPH.W ];
                                _font_line_height = _array[ __E_SCRIBBLE_GLYPH.H ];
                                
                                _skip = true;
                        
                                #endregion
                            }
                            else
                            {
                                var _asset = asset_get_index(_parameters_list[| 0]);
                                if (_asset >= 0) && (asset_get_type(_parameters_list[| 0]) == asset_sprite)
                                {
                                    #region Sprites
                            
                                    _substr_sprite = _asset;
                                    _substr_width  = sprite_get_width(_substr_sprite)*_text_scale;
                                    _substr_height = sprite_get_height(_substr_sprite)*_text_scale;
                                    _substr_length = 1;
                                    
                                    if (ds_list_size(_parameters_list) <= 1) _parameters_list[| 1] = "0";
                                    if (ds_list_size(_parameters_list) <= 2) _parameters_list[| 2] = "0";
                                    
                                    _substr_image       = real(_parameters_list[| 1]);
                                    _substr_image_speed = real(_parameters_list[| 2]);
                                    
                                    _text_flags[0] = true;
                            
                                    #endregion
                                }
                                else
                                {
                                    #region Colours
                                    var _colour = global.__scribble_colours[? _parameters_list[| 0] ]; //Test if it's a colour
                                    if (_colour != undefined)
                                    {
                                        _text_colour = _colour;
                                    }
                                    else //Test if it's a hexcode
                                    {
                                        var _colour_string = _parameters_list[| 0];
                                        if (string_length(_colour_string) <= 7) && (string_copy(_colour_string, 1, 1) == "$")
                                        {
                                            #region Hex string decoding
                                    
                                            var _ord = ord(string_char_at(_colour_string, 3));
                                            var _lsf = (_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max)? global.__scribble_hex_array[ _ord - global.__scribble_hex_min ] : 0;
                                            var _ord = ord(string_char_at(_colour_string, 2));
                                            var _hsf = (_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max)? global.__scribble_hex_array[ _ord - global.__scribble_hex_min ] : 0;
                                    
                                            var _red = _lsf + (_hsf << 4);
                                    
                                            var _ord = ord(string_char_at(_colour_string, 5));
                                            var _lsf = (_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max)? global.__scribble_hex_array[ _ord - global.__scribble_hex_min ] : 0;
                                            var _ord = ord(string_char_at(_colour_string, 4));
                                            var _hsf = (_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max)? global.__scribble_hex_array[ _ord - global.__scribble_hex_min ] : 0;
                                    
                                            var _green = _lsf + (_hsf << 4);
                                    
                                            var _ord = ord(string_char_at(_colour_string, 7));
                                            var _lsf = (_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max)? global.__scribble_hex_array[ _ord - global.__scribble_hex_min ] : 0;
                                            var _ord = ord(string_char_at(_colour_string, 6));
                                            var _hsf = (_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max)? global.__scribble_hex_array[ _ord - global.__scribble_hex_min ] : 0;
                                    
                                            var _blue = _lsf + (_hsf << 4);
                                    
                                            #endregion
                                    
                                            _text_colour = make_colour_rgb(_red, _green, _blue);
                                        }
                                    }
                                    _skip = true;
                                    #endregion
                                }
                            }
                        }
                    }
                break;
                #endregion
            }
            
            ds_list_clear(_parameters_list);
            _in_command_tag = false;
            
            if (_skip)
            {
                _skip = false;
                continue;
            }
        }
        #endregion
    }
    else
    {
        #region Find the substring's width and height
        
        var _font_data    = global.__scribble_font_data[? _text_font ];
        var _x            = 0;
        var _substr_width = 0;
        
        var _font_glyphs_array = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_ARRAY ];
        if (_font_glyphs_array == undefined)
        {
            //If we don't have a glyphs array, use the ds_map fallback
            var _font_glyphs_map = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_MAP ];
            
            //Add up the "shift" values for each character...
            var _length = string_length(_substr);
            for(var _j = 1; _j <= _length-1; _j++)
            {
                var _char = string_copy(_substr, _j, 1);
                if (ord(_char) == 10) _x = 0; //If we've hit a newline, reset back to 0
                
                var _array = _font_glyphs_map[? _char ];
                if (_array == undefined) continue;
                
                _x += _array[ __E_SCRIBBLE_GLYPH.SHF ];
                _substr_width = max(_substr_width, _x);
            }
            
            //...but not the last one. We want to use the last character's width instead
            var _char = string_copy(_substr, _length, 1);
            var _array = _font_glyphs_map[? _char ];
            if (_array != undefined)
            {
                _x += _array[ __E_SCRIBBLE_GLYPH.DX ] + _array[ __E_SCRIBBLE_GLYPH.W ];
                _substr_width = max(_substr_width, _x);
            }
            
            //Choose the height of a space for the substring's height
            var _array = _font_glyphs_map[? " " ];
            _substr_height = _array[ __E_SCRIBBLE_GLYPH.H ];
        }
        else
        {
            var _glyph_min = _font_data[ __E_SCRIBBLE_FONT.GLYPH_MIN ];
            var _glyph_max = _font_data[ __E_SCRIBBLE_FONT.GLYPH_MAX ];
            
            //Add up the "shift" values for each character...
            var _length = string_length(_substr);
            for(var _j = 1; _j <= _length-1; _j++)
            {
                var _ord = ord(string_copy(_substr, _j, 1));
                if (_ord == 10) _x = 0; //If we've hit a newline, reset back to 0
                if (_ord < _glyph_min) || (_ord > _glyph_max) continue; //If we're out of range, ignore this glyph
                
                var _array = _font_glyphs_array[ _ord - _font_data[ __E_SCRIBBLE_FONT.GLYPH_MIN ] ];
                if (_array == undefined) continue; //If this character is missing, ignore this glyph
                
                _x += _array[ __E_SCRIBBLE_GLYPH.SHF ];
                _substr_width = max(_substr_width, _x);
            }
            
            //...but not the last one. We want to use the last character's xOffset+width instead
            var _ord = ord(string_copy(_substr, _j, 1));
            if (_ord >= _glyph_min) && (_ord <= _glyph_max)
            {
                var _array = _font_glyphs_array[ _ord - _font_data[ __E_SCRIBBLE_FONT.GLYPH_MIN ] ];
                _x += _array[ __E_SCRIBBLE_GLYPH.DX ] + _array[ __E_SCRIBBLE_GLYPH.W ];
                _substr_width = max(_substr_width, _x);
            }
            
            //Choose the height of a space for the substring's height
            var _array = _font_glyphs_array[ 32 - _font_data[ __E_SCRIBBLE_FONT.GLYPH_MIN ] ];
            _substr_height = _array[ __E_SCRIBBLE_GLYPH.H ];
        }
        
        _substr_width  *= _text_scale;
        _substr_height *= _text_scale;
        
        #endregion
    }
    
    #region Position and store word
    
    //If we've run over the maximum width of the string
    if ((_substr_width + _text_x > _width_limit) && (_width_limit >= 0)) || (_line_array == noone) || (_sep_prev_char == 10) || (_force_newline)
    {
        if (_line_array != noone)
        {
            _line_array[@ __E_SCRIBBLE_LINE.WIDTH     ] = _text_x;
            _line_array[@ __E_SCRIBBLE_LINE.HEIGHT    ] = _line_max_height;
            _line_array[@ __E_SCRIBBLE_LINE.LENGTH    ] = _line_length;
            _line_array[@ __E_SCRIBBLE_LINE.LAST_CHAR ] = _line_array[ __E_SCRIBBLE_LINE.FIRST_CHAR ] + _line_length;
            
            _text_x = 0;
            _text_y += _line_max_height;
            _line_prev_last_index += _line_length;
            _line_length = 0;
            
            _line_max_height = _line_min_height;
        }
            
        if (_word_array != noone)
        {
            // _word_array still holds the previous word
            var _next_separator = _word_array[ __E_SCRIBBLE_WORD.NEXT_SEPARATOR ];
            if (_next_separator == 32) || (_next_separator == SCRIBBLE_COMMAND_TAG_OPEN) // <space> or [
            {
                _word_array[@ __E_SCRIBBLE_WORD.WIDTH ] -= _font_space_width; //If the previous separation character was whitespace, correct the length of the previous word
                _line_array[@ __E_SCRIBBLE_LINE.WIDTH ] -= _font_space_width; //...and the previous line
            }
        }
        
        var _line_array = array_create(__E_SCRIBBLE_LINE.__SIZE, 0);
        
        var _line_words_array = [];
        _line_array[ __E_SCRIBBLE_LINE.X          ] = 0;
        _line_array[ __E_SCRIBBLE_LINE.Y          ] = _text_y;
        _line_array[ __E_SCRIBBLE_LINE.WIDTH      ] = 0;
        _line_array[ __E_SCRIBBLE_LINE.HEIGHT     ] = _line_min_height;
        _line_array[ __E_SCRIBBLE_LINE.LENGTH     ] = 0;
        _line_array[ __E_SCRIBBLE_LINE.FIRST_CHAR ] = _line_prev_last_index;
        _line_array[ __E_SCRIBBLE_LINE.LAST_CHAR  ] = _line_prev_last_index;
        _line_array[ __E_SCRIBBLE_LINE.HALIGN     ] = _text_halign;
        _line_array[ __E_SCRIBBLE_LINE.WORDS      ] = _line_words_array;
        
        ds_list_add(_text_root_list, _line_array);
    }
    
    if (!_force_newline) && (_substr != "")
    {
        _line_max_height = max(_line_max_height, _substr_height);
        
        //Add a new word
        _new_word = true;
        var _word_array = array_create(__E_SCRIBBLE_WORD.__SIZE, 0);
        _word_array[ __E_SCRIBBLE_WORD.X              ] = _text_x;
        _word_array[ __E_SCRIBBLE_WORD.Y              ] = 0;
        _word_array[ __E_SCRIBBLE_WORD.WIDTH          ] = _substr_width;
        _word_array[ __E_SCRIBBLE_WORD.HEIGHT         ] = _substr_height;
        _word_array[ __E_SCRIBBLE_WORD.SCALE          ] = _text_scale;
        _word_array[ __E_SCRIBBLE_WORD.SLANT          ] = _text_slant;
        _word_array[ __E_SCRIBBLE_WORD.VALIGN         ] = fa_middle;
        _word_array[ __E_SCRIBBLE_WORD.STRING         ] = _substr;
        _word_array[ __E_SCRIBBLE_WORD.INPUT_STRING   ] = _input_substr;
        _word_array[ __E_SCRIBBLE_WORD.SPRITE         ] = _substr_sprite;
        _word_array[ __E_SCRIBBLE_WORD.IMAGE          ] = _substr_image;
        _word_array[ __E_SCRIBBLE_WORD.IMAGE_SPEED    ] = _substr_image_speed;
        _word_array[ __E_SCRIBBLE_WORD.LENGTH         ] = _substr_length; //Include the separator character!
        _word_array[ __E_SCRIBBLE_WORD.FONT           ] = _text_font;
        _word_array[ __E_SCRIBBLE_WORD.COLOUR         ] = _text_colour;
        _word_array[ __E_SCRIBBLE_WORD.FLAGS          ] = _text_flags;
        _word_array[ __E_SCRIBBLE_WORD.NEXT_SEPARATOR ] = "";
        
        //Add the word to the line list
        _line_words_array[@ array_length_1d(_line_words_array) ] = _word_array;
        
        //Wipe the text flags
        var _new_text_flags = array_create(SCRIBBLE_MAX_FLAGS, 0);
        array_copy(_new_text_flags, 0, _text_flags, 0, SCRIBBLE_MAX_FLAGS);
        _text_flags = _new_text_flags;
    }
    
    _text_x += _substr_width;
    if (_sep_char == 32) _text_x += _font_space_width; //Add spacing if the separation character is a space
    if ((_sep_char == 32) && _new_word && (_substr != "")) _word_array[@ __E_SCRIBBLE_WORD.WIDTH ] += _font_space_width;
    #endregion
    
    if (_sep_char == SCRIBBLE_COMMAND_TAG_OPEN) _in_command_tag = true; // [
    
    _line_length += _substr_length;
    if (_substr_length > 0) ++_json[| __E_SCRIBBLE.WORDS ];
    _json[| __E_SCRIBBLE.LENGTH ] += _substr_length;
}

//Finish defining the last line
_line_array[@ __E_SCRIBBLE_LINE.WIDTH     ] = _text_x;
_line_array[@ __E_SCRIBBLE_LINE.HEIGHT    ] = _line_max_height;
_line_array[@ __E_SCRIBBLE_LINE.LENGTH    ] = _line_length;
_line_array[@ __E_SCRIBBLE_LINE.LAST_CHAR ] = _line_array[@ __E_SCRIBBLE_LINE.FIRST_CHAR ] + _line_length;

_json[| __E_SCRIBBLE.LINES ] = ds_list_size(_json[| __E_SCRIBBLE.LINE_LIST ]);

#endregion



#region Set box width/height and adjust line positions based on alignment

//Textbox width and height
var _lines_size = ds_list_size(_text_root_list);

var _textbox_width = 0;
for(var _i = 0; _i < _lines_size; _i++)
{
    var _line_array = _text_root_list[| _i ];
    _textbox_width = max(_textbox_width, _line_array[ __E_SCRIBBLE_LINE.WIDTH ]);
}

var _line_array = _text_root_list[| _lines_size - 1 ];
var _textbox_height = _line_array[ __E_SCRIBBLE_LINE.Y ] + _line_array[ __E_SCRIBBLE_LINE.HEIGHT ];
  
_json[| __E_SCRIBBLE.WIDTH  ] = _textbox_width;
_json[| __E_SCRIBBLE.HEIGHT ] = _textbox_height;

//Adjust word positions
for(var _line = 0; _line < _lines_size; _line++)
{
    var _line_array = _text_root_list[| _line ];
    switch(_line_array[ __E_SCRIBBLE_LINE.HALIGN ])
    {
        case fa_left:
            _line_array[@ __E_SCRIBBLE_LINE.X ] = 0;
        break;
        
        case fa_center:
            _line_array[@ __E_SCRIBBLE_LINE.X ] += (_textbox_width - _line_array[ __E_SCRIBBLE_LINE.WIDTH ]) div 2;
        break;
        
        case fa_right:
            _line_array[@ __E_SCRIBBLE_LINE.X ] += _textbox_width - _line_array[ __E_SCRIBBLE_LINE.WIDTH ];
        break;
    }
    
    var _line_height     = _line_array[ __E_SCRIBBLE_LINE.HEIGHT ];
    var _line_word_array = _line_array[ __E_SCRIBBLE_LINE.WORDS  ];
    
    var _word_count = array_length_1d(_line_word_array);
    for(var _word = 0; _word < _word_count; _word++)
    {
        var _word_array = _line_word_array[ _word ];
        
        switch(_word_array[ __E_SCRIBBLE_WORD.VALIGN ])
        {
            case fa_top:
                _word_array[@ __E_SCRIBBLE_WORD.Y ] = 0;
            break;
            
            case fa_middle:
                _word_array[@ __E_SCRIBBLE_WORD.Y ] = (_line_height - _word_array[ __E_SCRIBBLE_WORD.HEIGHT ]) div 2;
            break;
            
            case fa_bottom:
                _word_array[@ __E_SCRIBBLE_WORD.Y ] = _line_height - _word_array[ __E_SCRIBBLE_WORD.HEIGHT ];
            break;
        }
    }
}

scribble_set_box_alignment(_json);

#endregion



//Clean up some misc data structures that we used
buffer_delete(_buffer);
ds_list_destroy(_separator_list );
ds_list_destroy(_position_list  );
ds_list_destroy(_parameters_list);



#region Build the vertex buffers

var _json_offset_x   = _json[| __E_SCRIBBLE.LEFT                    ];
var _json_offset_y   = _json[| __E_SCRIBBLE.TOP                     ];
var _vbuff_list      = _json[| __E_SCRIBBLE.VERTEX_BUFFER_LIST      ];

var _texture_to_vbuff_map = ds_map_create();

var _previous_font    = "";
var _previous_texture = -1;

var _text_char = 0;
var _max_char = _json[| __E_SCRIBBLE.LENGTH ]-1;

var _lines = _json[| __E_SCRIBBLE.LINE_LIST ];
var _lines_size = ds_list_size(_lines);
var _line = 0;
repeat(_lines_size)
{
    var _line_pc = _line / _lines_size;
    
    var _line_array = _lines[| _line ];
    var _line_l = _line_array[ __E_SCRIBBLE_LINE.X ] + _json_offset_x;
    var _line_t = _line_array[ __E_SCRIBBLE_LINE.Y ] + _json_offset_y;
    
    var _line_word_array = _line_array[ __E_SCRIBBLE_LINE.WORDS ];
    var _words_count = array_length_1d(_line_word_array);
    var _word = 0;
    repeat(_words_count)
    {
        var _word_array = _line_word_array[ _word ];
        var _word_l = _word_array[ __E_SCRIBBLE_WORD.X      ] + _line_l;
        var _word_t = _word_array[ __E_SCRIBBLE_WORD.Y      ] + _line_t;
        var _sprite = _word_array[ __E_SCRIBBLE_WORD.SPRITE ];
        
        if (_sprite != noone)
        {
            #region Add a sprite
            
            _previous_font = "";
            
            var _char_pc     = _text_char / _max_char;
            var _colour      = SCRIBBLE_COLOURISE_SPRITES? _word_array[ __E_SCRIBBLE_WORD.COLOUR ] : c_white;
            var _flag_data   = _word_array[ __E_SCRIBBLE_WORD.FLAGS  ];
            var _image_start = _word_array[ __E_SCRIBBLE_WORD.IMAGE  ];
            var _scale       = _word_array[ __E_SCRIBBLE_WORD.SCALE  ];
            var _image_speed = SCRIBBLE_FORCE_NO_SPRITE_ANIMATION? 0 : _word_array[ __E_SCRIBBLE_WORD.IMAGE_SPEED ];
            
            var _flags  = 0;
            if (_image_speed > 0) _flags += 1; //Set the "is sprite" flag only if we're animating the sprite
            var _offset = 2;
            
            for(var _i = 1; _i < SCRIBBLE_MAX_FLAGS; _i++)
            {
                _flags += _flag_data[_i] * _offset;
                _offset *= 2;
            }
            
            //Default to only adding one image from the sprite to the vertex buffer
            var _image_a = _image_start;
            var _image_b = _image_start;
            
            //If we want to animate the sprite, add all images from the sprite
            if (_image_speed > 0)
            {
                _image_a = 0;
                _image_b = sprite_get_number(_sprite)-1;
            }
            
            for(var _image = _image_a; _image <= _image_b; _image++)
            {
                if (_image_speed > 0)
                {
                    //Encode image, sprite length, and image speed into the colour channels
                    _colour = make_colour_rgb(_image, sprite_get_number(_sprite)-1, _image_speed*255);
                    //Encode the starting image into the alpha channel
                    var _alpha = _image_start/255;
                }
                else
                {
                    var _alpha = 1;
                }
                
                var _sprite_texture = sprite_get_texture(_sprite, _image);
                if (_sprite_texture != _previous_texture)
                {
                    _previous_texture = _sprite_texture;
                    
                    var _vbuff_data = _texture_to_vbuff_map[? _sprite_texture ];
                    if (_vbuff_data == undefined)
                    {
                        var _vbuff = vertex_create_buffer();
                        vertex_begin(_vbuff, global.__scribble_vertex_format);
                        
                        _vbuff_data = ds_list_create();
                        _vbuff_data[| __E_SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER ] = _vbuff;
                        _vbuff_data[| __E_SCRIBBLE_VERTEX_BUFFER.TEXTURE       ] = _sprite_texture;
                        ds_list_add(_vbuff_list, _vbuff_data);
                        ds_list_mark_as_list(_vbuff_list, ds_list_size(_vbuff_list)-1);
                    
                        _texture_to_vbuff_map[? _sprite_texture ] = _vbuff_data;
                    }
                    else
                    {
                        var _vbuff = _vbuff_data[| __E_SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER ];
                    }
                }
                
                var _uvs = sprite_get_uvs(_sprite, _image);
                var _glyph_l = _word_l  + _uvs[4] + sprite_get_xoffset(_sprite);
                var _glyph_t = _word_t  + _uvs[5] + sprite_get_yoffset(_sprite);
                var _glyph_r = _glyph_l + _uvs[6]*_scale*sprite_get_width(_sprite);
                var _glyph_b = _glyph_t + _uvs[7]*_scale*sprite_get_height(_sprite);
                
                vertex_position_3d(_vbuff,   _glyph_l, _glyph_t, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, _alpha); vertex_texcoord(_vbuff,   _uvs[0], _uvs[1]);
                vertex_position_3d(_vbuff,   _glyph_l, _glyph_b, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, _alpha); vertex_texcoord(_vbuff,   _uvs[0], _uvs[3]);
                vertex_position_3d(_vbuff,   _glyph_r, _glyph_b, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, _alpha); vertex_texcoord(_vbuff,   _uvs[2], _uvs[3]);
                vertex_position_3d(_vbuff,   _glyph_r, _glyph_b, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, _alpha); vertex_texcoord(_vbuff,   _uvs[2], _uvs[3]);
                vertex_position_3d(_vbuff,   _glyph_r, _glyph_t, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, _alpha); vertex_texcoord(_vbuff,   _uvs[2], _uvs[1]);
                vertex_position_3d(_vbuff,   _glyph_l, _glyph_t, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, _alpha); vertex_texcoord(_vbuff,   _uvs[0], _uvs[1]);
            }
            
            ++_text_char;
            #endregion
        }
        else
        {
            #region Check the font and texture to see if we need a new vertex buffer
            
            var _font = _word_array[ __E_SCRIBBLE_WORD.FONT ];
            if (_font != _previous_font)
            {
                _previous_font = _font;
                
                var _font_data         = global.__scribble_font_data[? _font ];
                var _font_glyphs_map   = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_MAP   ];
                var _font_glyphs_array = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_ARRAY ];
                var _font_glyphs_min   = _font_data[ __E_SCRIBBLE_FONT.GLYPH_MIN    ];
                var _font_glyphs_max   = _font_data[ __E_SCRIBBLE_FONT.GLYPH_MAX    ];
                var _font_texture      = _font_data[ __E_SCRIBBLE_FONT.TEXTURE      ];
                
                if (_font_texture != _previous_texture)
                {
                    _previous_texture = _font_texture;
                    
                    var _lookup_map   = _texture_to_vbuff_map;
                    var _storage_list = _vbuff_list;
                    
                    var _vbuff_data = _lookup_map[? _font_texture ];
                    if (_vbuff_data == undefined)
                    {
                        var _vbuff = vertex_create_buffer();
                        vertex_begin(_vbuff, global.__scribble_vertex_format);
                        
                        _vbuff_data = ds_list_create();
                        _vbuff_data[| __E_SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER ] = _vbuff;
                        _vbuff_data[| __E_SCRIBBLE_VERTEX_BUFFER.TEXTURE       ] = _font_texture;
                        ds_list_add(_storage_list, _vbuff_data);
                        ds_list_mark_as_list(_storage_list, ds_list_size(_storage_list)-1);
                            
                        _lookup_map[? _font_texture ] = _vbuff_data;
                    }
                    else
                    {
                        var _vbuff = _vbuff_data[| __E_SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER ];
                    }
                }
            }
            
            #endregion
            
            #region Add vertex data for each character in the string
            
            var _colour    = _word_array[ __E_SCRIBBLE_WORD.COLOUR ];
            var _flag_data = _word_array[ __E_SCRIBBLE_WORD.FLAGS  ];
            var _scale     = _word_array[ __E_SCRIBBLE_WORD.SCALE  ];
            var _slant     = _word_array[ __E_SCRIBBLE_WORD.SLANT  ];
            var _slant_offset = SCRIBBLE_SLANT_AMOUNT*_scale*_slant;
            
            var _flags  = 0;
            var _offset = 1;
            for(var _i = 0; _i < SCRIBBLE_MAX_FLAGS; _i++)
            {
                _flags += _offset*_flag_data[_i];
                _offset *= 2;
            }
            
            var _str = _word_array[ __E_SCRIBBLE_WORD.STRING ];
            var _string_size = string_length(_str);
            
            var _char_l = _word_l;
            var _char_t = _word_t;
            var _char_index = 1;
            
            if (_font_glyphs_array == undefined)
            {
                repeat(_string_size)
                {
                    var _array = _font_glyphs_map[? string_char_at(_str, _char_index) ];
                    if (_array == undefined) continue;
                    
                    var _glyph_w   = _array[ __E_SCRIBBLE_GLYPH.W   ];
                    var _glyph_h   = _array[ __E_SCRIBBLE_GLYPH.H   ];
                    var _glyph_u0  = _array[ __E_SCRIBBLE_GLYPH.U0  ];
                    var _glyph_v0  = _array[ __E_SCRIBBLE_GLYPH.V0  ];
                    var _glyph_u1  = _array[ __E_SCRIBBLE_GLYPH.U1  ];
                    var _glyph_v1  = _array[ __E_SCRIBBLE_GLYPH.V1  ];
                    var _glyph_dx  = _array[ __E_SCRIBBLE_GLYPH.DX  ];
                    var _glyph_dy  = _array[ __E_SCRIBBLE_GLYPH.DY  ];
                    var _glyph_shf = _array[ __E_SCRIBBLE_GLYPH.SHF ];
                    
                    var _glyph_l = _char_l + _glyph_dx*_scale;
                    var _glyph_t = _char_t + _glyph_dy*_scale;
                    var _glyph_r = _glyph_l + _glyph_w*_scale;
                    var _glyph_b = _glyph_t + _glyph_h*_scale;
                    
                    var _char_pc = _text_char / _max_char;
                    
                    vertex_position_3d(_vbuff,   _glyph_l+_slant_offset, _glyph_t, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u0, _glyph_v0);
                    vertex_position_3d(_vbuff,   _glyph_l              , _glyph_b, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u0, _glyph_v1);
                    vertex_position_3d(_vbuff,   _glyph_r              , _glyph_b, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u1, _glyph_v1);
                    vertex_position_3d(_vbuff,   _glyph_r              , _glyph_b, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u1, _glyph_v1);
                    vertex_position_3d(_vbuff,   _glyph_r+_slant_offset, _glyph_t, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u1, _glyph_v0);
                    vertex_position_3d(_vbuff,   _glyph_l+_slant_offset, _glyph_t, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u0, _glyph_v0);
                    
                    _char_l += _glyph_shf*_scale;
                    ++_text_char;
                    ++_char_index;
                }
            }
            else
            {
                repeat(_string_size)
                {
                    var _ord = ord(string_char_at(_str, _char_index));
                    if (_ord < _font_glyphs_min) || (_ord > _font_glyphs_max) continue;
                    var _array = _font_glyphs_array[ _ord - _font_glyphs_min ];
                    if (_array == undefined) continue;
                    
                    var _glyph_w   = _array[ __E_SCRIBBLE_GLYPH.W   ];
                    var _glyph_h   = _array[ __E_SCRIBBLE_GLYPH.H   ];
                    var _glyph_u0  = _array[ __E_SCRIBBLE_GLYPH.U0  ];
                    var _glyph_v0  = _array[ __E_SCRIBBLE_GLYPH.V0  ];
                    var _glyph_u1  = _array[ __E_SCRIBBLE_GLYPH.U1  ];
                    var _glyph_v1  = _array[ __E_SCRIBBLE_GLYPH.V1  ];
                    var _glyph_dx  = _array[ __E_SCRIBBLE_GLYPH.DX  ];
                    var _glyph_dy  = _array[ __E_SCRIBBLE_GLYPH.DY  ];
                    var _glyph_shf = _array[ __E_SCRIBBLE_GLYPH.SHF ];
                    
                    var _glyph_l = _char_l + _glyph_dx*_scale;
                    var _glyph_t = _char_t + _glyph_dy*_scale;
                    var _glyph_r = _glyph_l + _glyph_w*_scale;
                    var _glyph_b = _glyph_t + _glyph_h*_scale;
                    
                    var _char_pc = _text_char / _max_char;
                    
                    vertex_position_3d(_vbuff,   _glyph_l+_slant_offset, _glyph_t, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u0, _glyph_v0);
                    vertex_position_3d(_vbuff,   _glyph_l              , _glyph_b, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u0, _glyph_v1);
                    vertex_position_3d(_vbuff,   _glyph_r              , _glyph_b, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u1, _glyph_v1);
                    vertex_position_3d(_vbuff,   _glyph_r              , _glyph_b, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u1, _glyph_v1);
                    vertex_position_3d(_vbuff,   _glyph_r+_slant_offset, _glyph_t, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u1, _glyph_v0);
                    vertex_position_3d(_vbuff,   _glyph_l+_slant_offset, _glyph_t, SCRIBBLE_Z); vertex_normal(_vbuff,   _char_pc, _line_pc, _flags); vertex_colour(_vbuff,   _colour, 1); vertex_texcoord(_vbuff,   _glyph_u0, _glyph_v0);
                    
                    _char_l += _glyph_shf*_scale;
                    ++_text_char;
                    ++_char_index;
                }
            }
            
            #endregion
        }
        
        ++_word;
    }
    
    ++_line;
}

//Finish off and freeze all the vertex buffers we created
var _count = ds_list_size(_vbuff_list);
for(var _i = 0; _i < _count; _i++)
{
    var _vbuff_data = _vbuff_list[| _i ];
    var _vbuff = _vbuff_data[| __E_SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER ];
    vertex_end(_vbuff);
    vertex_freeze(_vbuff);
}

ds_map_destroy(_texture_to_vbuff_map);

#endregion



show_debug_message("Scribble: scribble_create() took " + string((get_timer() - _timer)/1000) + "ms");

return _json;