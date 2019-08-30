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
/// []                                  Reset formatting to defaults
/// [<name of colour>]                  Set colour
/// [#<hex code>]                       Set colour via a hexcode, using normal RGB values (#RRGGBB)
/// [/colour] [/c]                      Reset colour to the default
/// [<name of font>] [/font] [/f]       Set font / Rest font
/// [<name of sprite>]                  Insert an animated sprite starting on image 0 and animating using SCRIBBLE_DEFAULT_SPRITE_SPEED
/// [<name of sprite>,<image>]          Insert a static sprite using the specified image index
/// [<name of sprite>,<image>,<speed>]  Insert animated sprite using the specified image index and animation speed
/// [fa_left]                           Align horizontally to the left
/// [fa_right]                          Align horizontally to the right
/// [fa_center] [fa_centre]             Align centrally
/// [scale,<factor>] [/scale] [/s]      Scale text / Reset scale to 1
/// [slant] [/slant]                    Set/unset italic emulation
/// [<event name>,<arg0>,<arg1>...]     Execute a script bound to an event name (previously defined using scribble_add_event()) with the specified arguments
/// [<flag name>] [/<flag name>]        Set/unset a custom formatting flag
/// 
/// Scribble has the following formatting flags as defaults:
/// [wave]    [/wave]                   Set/unset text to wave up and down
/// [shake]   [/shake]                  Set/unset text to shake
/// [rainbow] [/rainbow]                Set/unset text to cycle through rainbow colours



if ( !variable_global_exists("__scribble_init_complete") )
{
    show_error("Scribble:\nscribble_create() should be called after initialising Scribble.\n ", false);
    exit;
}

if (!global.__scribble_init_complete)
{
    show_error("Scribble:\nscribble_create() should be called after initialising Scribble.\n ", false);
    exit;
}

var _timer_total = get_timer();

var _input_string     = argument[0];
var _line_min_height  = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : -1;
var _width_limit      = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : -1;
var _def_colour       = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : SCRIBBLE_DEFAULT_TEXT_COLOUR;
var _def_font         = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : global.__scribble_default_font;
var _def_halign       = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : fa_left;
var _data_fields_in   = ((argument_count > 6) &&    is_array(argument[6])  )? argument[6] : undefined;



#region Process input parameters

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

//Build an array that contains data that'll (eventually) get sent into the shader
var _data_fields = array_create(SCRIBBLE_MAX_DATA_FIELDS);
if (is_array(_data_fields_in))
{
    var _length = array_length_1d(_data_fields_in);
    if (_length > SCRIBBLE_MAX_DATA_FIELDS)
    {
        show_error("Scribble:\nLength of custom data field array (" + string(_length) + ") is greater than SCRIBBLE_MAX_DATA_FIELDS (" + string(SCRIBBLE_MAX_DATA_FIELDS) + ")\n ", false);
        _length = SCRIBBLE_MAX_DATA_FIELDS;
    }
    array_copy(_data_fields, 0, _data_fields_in, 0, _length);
}
else
{
    _data_fields = SCRIBBLE_DEFAULT_DATA_FIELDS;
}

#endregion



#region Create the data structure

var _json                  = ds_list_create(); //The main data structure
var _line_list             = ds_list_create(); //Stores each line of text
var _vertex_buffer_list    = ds_list_create(); //Stores all the vertex buffers needed to render the text and sprites
var _events_character_list = ds_list_create(); //Stores each event's triggering character
var _events_name_list      = ds_list_create(); //Stores each event's name
var _events_data_list      = ds_list_create(); //Stores each event's parameters
var _texture_to_buffer_map = ds_map_create();

global.__scribble_global_count++;
global.__scribble_alive[? global.__scribble_global_count ] = _json;

_json[| __SCRIBBLE.__SIZE             ] = __SCRIBBLE_VERSION;

_json[| __SCRIBBLE.__SECTION0         ] = "-- Parameters --";
_json[| __SCRIBBLE.STRING             ] = _input_string;
_json[| __SCRIBBLE.DEFAULT_FONT       ] = _def_font;
_json[| __SCRIBBLE.DEFAULT_COLOUR     ] = _def_colour;
_json[| __SCRIBBLE.DEFAULT_HALIGN     ] = _def_halign;
_json[| __SCRIBBLE.WIDTH_LIMIT        ] = _width_limit;
_json[| __SCRIBBLE.LINE_HEIGHT        ] = _line_min_height;
                                      
_json[| __SCRIBBLE.__SECTION1         ] = "-- Statistics --";
_json[| __SCRIBBLE.HALIGN             ] = SCRIBBLE_DEFAULT_BOX_HALIGN;
_json[| __SCRIBBLE.VALIGN             ] = SCRIBBLE_DEFAULT_BOX_VALIGN;
_json[| __SCRIBBLE.WIDTH              ] = 0;
_json[| __SCRIBBLE.HEIGHT             ] = 0;
_json[| __SCRIBBLE.LEFT               ] = 0;
_json[| __SCRIBBLE.TOP                ] = 0;
_json[| __SCRIBBLE.RIGHT              ] = 0;
_json[| __SCRIBBLE.BOTTOM             ] = 0;
_json[| __SCRIBBLE.LENGTH             ] = 0;
_json[| __SCRIBBLE.LINES              ] = 0;
_json[| __SCRIBBLE.GLOBAL_INDEX       ] = global.__scribble_global_count;
                                      
_json[| __SCRIBBLE.__SECTION2         ] = "-- Typewriter --";
_json[| __SCRIBBLE.TW_DIRECTION       ] = 0;
_json[| __SCRIBBLE.TW_SPEED           ] = SCRIBBLE_DEFAULT_TYPEWRITER_SPEED;
_json[| __SCRIBBLE.TW_POSITION        ] = 0;
_json[| __SCRIBBLE.TW_METHOD          ] = SCRIBBLE_DEFAULT_TYPEWRITER_METHOD;
_json[| __SCRIBBLE.TW_SMOOTHNESS      ] = SCRIBBLE_DEFAULT_TYPEWRITER_SMOOTHNESS;
_json[| __SCRIBBLE.CHAR_FADE_T        ] = 1;
_json[| __SCRIBBLE.LINE_FADE_T        ] = 1;

_json[| __SCRIBBLE.__SECTION3         ] = "-- Animation --";
_json[| __SCRIBBLE.HAS_CALLED_STEP    ] = false;
_json[| __SCRIBBLE.NO_STEP_COUNT      ] = 0;
_json[| __SCRIBBLE.DATA_FIELDS        ] = _data_fields;
_json[| __SCRIBBLE.ANIMATION_TIME     ] = 0;

_json[| __SCRIBBLE.__SECTION4         ] = "-- Lists --";
_json[| __SCRIBBLE.LINE_LIST          ] = _line_list;
_json[| __SCRIBBLE.VERTEX_BUFFER_LIST ] = _vertex_buffer_list;

_json[| __SCRIBBLE.__SECTION5         ] = "-- Events --";
_json[| __SCRIBBLE.EVENT_PREVIOUS     ] = -1;
_json[| __SCRIBBLE.EVENT_CHAR_PREVIOUS] = -1;
_json[| __SCRIBBLE.EV_CHAR_LIST       ] = _events_character_list; //Stores each event's triggering cha
_json[| __SCRIBBLE.EV_NAME_LIST       ] = _events_name_list;      //Stores each event's name
_json[| __SCRIBBLE.EV_DATA_LIST       ] = _events_data_list;      //Stores each event's parameters

//Now bind the child data structures to the root list
ds_list_mark_as_list(_json, __SCRIBBLE.LINE_LIST         );
ds_list_mark_as_list(_json, __SCRIBBLE.VERTEX_BUFFER_LIST);
ds_list_mark_as_list(_json, __SCRIBBLE.EV_CHAR_LIST      );
ds_list_mark_as_list(_json, __SCRIBBLE.EV_NAME_LIST      );
ds_list_mark_as_list(_json, __SCRIBBLE.EV_DATA_LIST      );

#endregion



#region Parse the string

#region Initial parser state

var _parameters_list = ds_list_create();

var _line_width  = 0;
var _line_height = _line_min_height;

var _line_array = array_create(__SCRIBBLE_LINE.__SIZE);
_line_array[@ __SCRIBBLE_LINE.LAST_CHAR] = 1;
_line_array[@ __SCRIBBLE_LINE.WIDTH    ] = _line_width;
_line_array[@ __SCRIBBLE_LINE.HEIGHT   ] = _line_height;
_line_array[@ __SCRIBBLE_LINE.HALIGN   ] = _def_halign;
ds_list_add(_line_list, _line_array);

var _text_x                 = 0;
var _text_y                 = 0;
var _text_font              = _def_font;
var _text_colour            = _def_colour;
var _text_halign            = _def_halign;
var _text_flags             = 0;
var _text_scale             = 1;
var _text_slant             = false;

var _previous_texture       = -1;

var _meta_characters        = 0;
var _meta_lines             = 0;
var _text_x_max             = 0;
var _text_y_max             = 0;

var _command_tag_start      = -1;
var _command_tag_parameters = 0;

#endregion

var _skip          = false;
var _force_newline = false;
var _char_width    = 0;

//Write the string into a buffer for faster reading
var _buffer_size = string_byte_length(_input_string)+1;
var _string_buffer = buffer_create(_buffer_size, buffer_fixed, 1);
buffer_write(_string_buffer, buffer_string, _input_string);
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
        
            #region Command tag handling
        
            #region Replace tags
            
            if (_command_tag_parameters == 1)
            {
                var _replacement_list = global.__scribble_tag_replace[? _parameters_list[|0]];
                if (_replacement_list != undefined)
                {
                    ds_list_clear(_parameters_list);
                    ds_list_copy(_parameters_list, _replacement_list);
                    _command_tag_parameters = ds_list_size(_parameters_list);
                }
            }
            
            #endregion
        
            switch(_parameters_list[| 0])
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
                    if (_command_tag_parameters <= 1)
                    {
                        show_error("Scribble:\nNot enough parameters for scale tag!", false);
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
                
                #region Font Alignment
                
                case "fa_left":
                    _text_halign = fa_left;
                    if (_text_x > 0) _force_newline = true;
                break;
                
                case "fa_right":
                    _text_halign = fa_right;
                    if (_text_x > 0) _force_newline = true;
                break;
                
                case "fa_center":
                case "fa_centre":
                    _text_halign = fa_center;
                    if (_text_x > 0) _force_newline = true;
                break;
                #endregion
                
                default:
                    var _found = false;
                    
                    #region Events
                    if (!_found)
                    {
                        var _name = _parameters_list[| 0];
                        var _script = global.__scribble_events[? _name ];
                        if (_script != undefined)
                        {
                            var _data = array_create(_command_tag_parameters-1);
                            var _j = 1;
                            repeat(_command_tag_parameters)
                            {
                                _data[@ _j-1] = _parameters_list[| _j];
                                ++_j;
                            }
                            
                            ds_list_add(_events_character_list, _meta_characters);
                            ds_list_add(_events_name_list, _name);
                            ds_list_add(_events_data_list, _data);
                            
                            _skip = true;
                            _found = true;
                        }
                    }
                    #endregion
                    
                    #region Flags
                    if (!_found)
                    {
                        //Check if this is a flag name
                        var _flag_index = global.__scribble_flags[? _parameters_list[| 0] ];
                        if (_flag_index != undefined)
                        {
                            _text_flags = _text_flags | (1 << _flag_index);
                            _skip = true;
                            _found = true;
                        }
                    }
                    
                    if (!_found)
                    {
                        //Check if this is a flag name, but with a forward slash at the front
                        var _flag_index = undefined;
                        if (string_char_at(_parameters_list[| 0], 1) == "/") _flag_index = global.__scribble_flags[? string_delete(_parameters_list[| 0], 1, 1) ];
                        if (_flag_index != undefined)
                        {
                            _text_flags = ~((~_text_flags) | (1 << _flag_index));
                            _skip = true;
                            _found = true;
                        }
                    }
                    #endregion
                    
                    #region Change font
                    if (!_found)
                    {
                        //Change font
                        var _new_font_data = global.__scribble_font_data[? _parameters_list[| 0]];
                        if (_new_font_data != undefined)
                        {
                            _text_font = _parameters_list[| 0];
                            _font_data = _new_font_data;
                            _font_glyphs_map   = _font_data[__SCRIBBLE_FONT.GLYPHS_MAP  ];
                            _font_glyphs_array = _font_data[__SCRIBBLE_FONT.GLYPHS_ARRAY];
                            _font_glyphs_min   = _font_data[__SCRIBBLE_FONT.GLYPH_MIN   ];
                            _font_glyphs_max   = _font_data[__SCRIBBLE_FONT.GLYPH_MAX   ];
                            _font_texture      = _font_data[__SCRIBBLE_FONT.TEXTURE     ];
                            
                            var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
                            _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH];
                            _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
                                
                            _skip = true;
                            _found = true;
                        }
                    }
                    #endregion
                    
                    #region Sprites
                    if (!_found)
                    {
                        var _sprite_index = asset_get_index(_parameters_list[| 0]);
                        if ((_sprite_index >= 0) && (asset_get_type(_parameters_list[| 0]) == asset_sprite))
                        {
                            _found = true;
                            
                            _char_width  = _text_scale*sprite_get_width(_sprite_index);
                            _line_height = max(_line_height, _text_scale*sprite_get_height(_sprite_index));
                            
                            var _sprite_x      = _text_x + sprite_get_xoffset(_sprite_index);
                            var _sprite_y      = _text_y + sprite_get_yoffset(_sprite_index);
                            var _sprite_width  = _text_scale*sprite_get_width(_sprite_index);
                            var _sprite_height = _text_scale*sprite_get_height(_sprite_index);
                            var _sprite_number = sprite_get_number(_sprite_index);
                            
                            if (_sprite_number >= 256)
                            {
                                show_debug_message("Scribble: Sprites cannot have more than 256 frames (" + string(_parameters_list[| 0]) + ")");
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
                                
                                var _data = _texture_to_buffer_map[? _sprite_texture];
                                if (_data == undefined)
                                {
                                    var _line_break_list = ds_list_create();
                                    var _buffer = buffer_create(__SCRIBBLE_GLYPH_BYTE_SIZE, buffer_grow, 1);
                                    
                                    _data = ds_list_create();
                                    _data[| __SCRIBBLE_VERTEX_BUFFER.BUFFER         ] = _buffer;
                                    _data[| __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER  ] = undefined;
                                    _data[| __SCRIBBLE_VERTEX_BUFFER.TEXTURE        ] = _sprite_texture;
                                    _data[| __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = 0;
                                    _data[| __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST] = _line_break_list;
                                    ds_list_add(_vertex_buffer_list, _data);
                                    ds_list_mark_as_list(_vertex_buffer_list, ds_list_size(_vertex_buffer_list)-1);
                                    ds_list_mark_as_list(_data, __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST);
                                        
                                    _texture_to_buffer_map[? _sprite_texture] = _data;
                                }
                                else
                                {
                                    var _buffer = _data[| __SCRIBBLE_VERTEX_BUFFER.BUFFER];
                                    _data[| __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = buffer_tell(_buffer);
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
                                    var _glyph_buffer = _vbuff_data[| __SCRIBBLE_VERTEX_BUFFER.BUFFER];
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
                        }
                    }
                    #endregion
                    
                    #region Colours
                    if (!_found)
                    {
                        var _colour = global.__scribble_colours[? _parameters_list[| 0]]; //Test if it's a colour
                        if (_colour != undefined)
                        {
                            _text_colour = _colour;
                            _skip = true;
                            _found = true;
                        }
                        else //Test if it's a hexcode
                        {
                            var _colour_string = _parameters_list[| 0];
                            if (string_length(_colour_string) <= 7) && (string_copy(_colour_string, 1, 1) == "$")
                            {
                                //Hex string decoding
                                var _ord = ord(string_char_at(_colour_string, 3));
                                var _lsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                var _ord = ord(string_char_at(_colour_string, 2));
                                var _hsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                
                                var _red = _lsf + (_hsf << 4);
                                
                                var _ord = ord(string_char_at(_colour_string, 5));
                                var _lsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                var _ord = ord(string_char_at(_colour_string, 4));
                                var _hsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                
                                var _green = _lsf + (_hsf << 4);
                                
                                var _ord = ord(string_char_at(_colour_string, 7));
                                var _lsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                var _ord = ord(string_char_at(_colour_string, 6));
                                var _hsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                
                                var _blue = _lsf + (_hsf << 4);
                                
                                _text_colour = make_colour_rgb(_red, _green, _blue);
                                _skip = true;
                                _found = true;
                            }
                        }
                    }
                    #endregion
                    
                    //If we've not been able to find a relevant command tag, show some debug text
                    if (!_found)
                    {
                        var _command_string = string(_parameters_list[| 0]);
                        for(var _j = 1; _j < _command_tag_parameters; _j++) _command_string += "," + string(_parameters_list[| _j]);
                    
                        show_debug_message("Scribble: WARNING! Unrecognised command tag [" + _command_string + "]" );
                        _skip = true;
                    }
                break;
            }
        
            #endregion
            
            //Reset command tag state
            _command_tag_start      = -1;
            _command_tag_parameters = 0;
            ds_list_clear(_parameters_list);
            
            //If a command tag wants us to skip newline behaviour (which is most of them) then do so
            if (_skip)
            {
                _skip = false;
                continue;
            }
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
            _data[| __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = buffer_tell(_data[| __SCRIBBLE_VERTEX_BUFFER.BUFFER]);
            ++_v;
        }
    }
    else if (_character_code < 32)//If this character code is below a space then ignore it
    {
        continue;
    }
    else//If this character is literally any other character at all
    {
        //Decode UTF8
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
        
        #region Swap texture and buffer if needed
            
        if (_font_texture != _previous_texture)
        {
            _previous_texture = _font_texture;
                
            var _vbuff_data = _texture_to_buffer_map[? _font_texture];
            if (_vbuff_data == undefined)
            {
                var _line_break_list = ds_list_create();
                var _glyph_buffer = buffer_create(__SCRIBBLE_EXPECTED_GLYPHS*__SCRIBBLE_GLYPH_BYTE_SIZE, buffer_grow, 1);
                
                _vbuff_data = ds_list_create();
                _vbuff_data[| __SCRIBBLE_VERTEX_BUFFER.BUFFER         ] = _glyph_buffer;
                _vbuff_data[| __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER  ] = undefined;
                _vbuff_data[| __SCRIBBLE_VERTEX_BUFFER.TEXTURE        ] = _font_texture;
                _vbuff_data[| __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = 0;
                _vbuff_data[| __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST] = _line_break_list;
                ds_list_add(_vertex_buffer_list, _vbuff_data);
                ds_list_mark_as_list(_vertex_buffer_list, ds_list_size(_vertex_buffer_list)-1);
                ds_list_mark_as_list(_vbuff_data, __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST);
                    
                _texture_to_buffer_map[? _font_texture] = _vbuff_data;
            }
            else
            {
                var _glyph_buffer = _vbuff_data[| __SCRIBBLE_VERTEX_BUFFER.BUFFER];
            }
            
            //Fill link break list
            var _tell = buffer_tell(_glyph_buffer);
            repeat(ds_list_size(_line_list) - ds_list_size(_line_break_list)) ds_list_add(_line_break_list, _tell);
        }
            
        //Update WORD_START_TELL
        _vbuff_data[| __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = buffer_tell(_glyph_buffer);
            
        #endregion
            
        #region Add glyph
            
        var _colour = $FF000000 | _text_colour;
        var _slant_offset = SCRIBBLE_SLANT_AMOUNT*_text_scale*_text_slant;
            
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
    
    if (((_char_width + _text_x > _width_limit) && (_width_limit >= 0)) || _force_newline)
    {
        var _v = 0;
        repeat(ds_list_size(_vertex_buffer_list))
        {
            var _data = _vertex_buffer_list[| _v];
            
            var _line_break_list = _data[| __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST];
            var _buffer          = _data[| __SCRIBBLE_VERTEX_BUFFER.BUFFER         ];
            var _tell_b          = buffer_tell(_buffer);
            
            if (_force_newline)
            {
                ds_list_add(_line_break_list, _tell_b);
            }
            else
            {
                var _tell_a = _data[| __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL];
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
            
            _data[| __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = _tell_b;
            
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
_json[| __SCRIBBLE.LINES ] = _meta_lines;
_json[| __SCRIBBLE.LENGTH] = _meta_characters;
_json[| __SCRIBBLE.WIDTH ] = _text_x_max;
_json[| __SCRIBBLE.HEIGHT] = _text_y_max;



var _v = 0;
repeat(ds_list_size(_vertex_buffer_list))
{
    var _data = _vertex_buffer_list[| _v];
    
    var _line_break_list = _data[| __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST];
    var _buffer          = _data[| __SCRIBBLE_VERTEX_BUFFER.BUFFER         ];
    
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
    _data[| __SCRIBBLE_VERTEX_BUFFER.LINE_START_LIST] = undefined;
    ds_list_destroy(_line_break_list);
    
    //Create vertex buffer
    _data[| __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER  ] = vertex_create_buffer_from_buffer_ext(_buffer, global.__scribble_vertex_format, 0, _buffer_tell / __SCRIBBLE_VERTEX.__SIZE);
    _data[| __SCRIBBLE_VERTEX_BUFFER.BUFFER         ] = undefined;
    buffer_delete(_buffer);
    
    //Wipe WORD_START_TELL
    _data[| __SCRIBBLE_VERTEX_BUFFER.WORD_START_TELL] = undefined;
    
    ++_v;
}

#endregion



#region Sort out box alignment

switch(SCRIBBLE_DEFAULT_BOX_HALIGN)
{
    case fa_left:
        _json[| __SCRIBBLE.RIGHT] =  _text_x_max;
    break;
    case fa_center:
        _json[| __SCRIBBLE.LEFT ] = -_text_x_max div 2;
        _json[| __SCRIBBLE.RIGHT] =  _text_x_max div 2;
    break;
    case fa_right:
        _json[| __SCRIBBLE.LEFT ] = -_text_x_max;
    break;
}

switch(SCRIBBLE_DEFAULT_BOX_VALIGN)
{
    case fa_top:
        _json[| __SCRIBBLE.BOTTOM] =  _text_y_max;
    break;
    case fa_middle:
        _json[| __SCRIBBLE.TOP   ] = -_text_y_max div 2;
        _json[| __SCRIBBLE.BOTTOM] =  _text_y_max div 2;
    break;
    case fa_bottom:
        _json[| __SCRIBBLE.TOP   ] = -_text_y_max;
    break;
}

#endregion



ds_map_destroy(_texture_to_buffer_map);
buffer_delete(_string_buffer);
ds_list_destroy(_parameters_list);



if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: scribble_create() took " + string((get_timer() - _timer_total)/1000) + "ms");

return _json;