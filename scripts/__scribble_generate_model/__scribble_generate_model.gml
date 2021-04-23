/// @param element

enum __SCRIBBLE_PARSER_GLYPH
{
    X,
    Y,
    CHAR, //TODO - Debug, remove
    ORD,
    FONT_DATA,
    GLYPH_DATA,
    EVENTS,
    WIDTH,
    SEPARATION,
    HEIGHT,
    TEXTURE,
    UVS,
    STATE_COLOUR,
    STATE_EFFECT_FLAGS,
    STATE_SCALE,
    STATE_SLANT,
    STATE_CYCLE,
    STATE_CYCLE_COLOUR,
    STATE_HALIGN,
    __SIZE,
}

enum __SCRIBBLE_PARSER_WORD
{
    GLYPH_START,
    GLYPH_END,
    WIDTH,
    X,
    Y,
    __SIZE,
}

enum __SCRIBBLE_PARSER_LINE
{
    GLYPH_START,
    GLYPH_END,
    WORD_START,
    WORD_END,
    WIDTH,
    HALIGN,
    __SIZE,
}



#macro __SCRIBBLE_PARSER_WRITE_GLYPH_STATE  _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_COLOUR      ] = _state_colour;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_EFFECT_FLAGS] = _state_effect_flags;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_SCALE       ] = _state_scale;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_SLANT       ] = _state_slant;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_CYCLE       ] = _state_cycle;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_CYCLE_COLOUR] = _state_cycle_colour;\n
                                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.STATE_HALIGN      ] = _state_halign;

#macro __SCRIBBLE_PARSER_SET_FONT   var _font_data         = __scribble_get_font_data(_font_name);\n
                                    var _font_glyphs_map   = _font_data.glyphs_map;\n
                                    var _font_glyphs_array = _font_data.glyphs_array;\n
                                    var _font_glyphs_min   = _font_data.glyph_min;\n
                                    var _font_glyphs_max   = _font_data.glyph_max;\n
                                    var _font_msdf_range   = _font_data.msdf_range;\n
                                    var _font_scale_dist   = _font_data.scale_dist;\n
                                    var _space_glyph_data = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];\n
                                    if (_space_glyph_data == undefined)\n
                                    {\n
                                        __scribble_error("The space character is missing from font definition for \"", _font_name, "\"");\n
                                        return false;\n
                                    }\n
                                    var _font_line_height = _space_glyph_data[SCRIBBLE_GLYPH.HEIGHT];\n
                                    var _font_space_width = _space_glyph_data[SCRIBBLE_GLYPH.WIDTH ];

#macro __SCRIBBLE_PARSER_ADD_WORD  _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.GLYPH_START] = _word_glyph_start;\n
                                   _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.GLYPH_END  ] = _word_glyph_end;\n
                                   _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.WIDTH      ] = _word_width;\n
                                   _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.X          ] = _word_x;\n
                                   _word_grid[# _word_count, __SCRIBBLE_PARSER_WORD.Y          ] = _word_y;\n
                                   _word_count++;

#macro __SCRIBBLE_PARSER_FINALIZE_LINE  _line_word_end  = _word_count - 1;\n
                                        _line_glyph_end = _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.GLYPH_END];\n
                                        _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.GLYPH_START] = _line_glyph_start;\n
                                        _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.GLYPH_END  ] = _line_glyph_end;\n
                                        _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_START ] = _line_word_start;\n
                                        _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_END   ] = _line_word_end;\n
                                        _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WIDTH      ] = _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.X] + _word_grid[# _line_word_end, __SCRIBBLE_PARSER_WORD.WIDTH];\n
                                        _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HALIGN     ] = fa_left;\n
                                        _line_count++;



function __scribble_generate_model(_element)
{
    var _model_max_width  = _element.wrap_max_width;
    var _model_max_height = _element.wrap_max_height;
    
    if (_model_max_width  < 0) _model_max_width  = infinity;
    if (_model_max_height < 0) _model_max_height = infinity;
    
    var _starting_colour = __scribble_process_colour(_element.starting_colour);
    var _starting_halign = _element.starting_halign;
    var _starting_valign = _element.starting_valign;
    
    
    
    #region Collect starting font data
    
    var _starting_font = _element.starting_font;
    if (_starting_font == undefined) __scribble_error("The default font has not been set\nCheck that you've added fonts to Scribble (scribble_font_add() / scribble_font_add_from_sprite() etc.)");
    
    var _font_name = _starting_font;
    __SCRIBBLE_PARSER_SET_FONT;
    
    #endregion
    
    
    
    var _element_text        = _element.text;
    var _element_text_length = string_length(_element_text);
    
    var _string_buffer = global.__scribble_buffer;
    var _glyph_grid    = global.__scribble_glyph_grid;
    var _word_grid     = global.__scribble_word_grid;
    var _line_grid     = global.__scribble_line_grid;
    
    buffer_seek(_string_buffer, buffer_seek_start, 0);
    buffer_write(_string_buffer, buffer_string, _element_text);
    buffer_write(_string_buffer, buffer_u32, 0x0); //Add some extra null characters to avoid errors where we're reading outside the buffer
    buffer_write(_string_buffer, buffer_u32, 0x0); //Add some extra null characters to avoid errors where we're reading outside the buffer
    buffer_seek(_string_buffer, buffer_seek_start, 0);
    
    //Resize grids if we have to
    if (ds_grid_width(_glyph_grid) < _element_text_length) ds_grid_resize(_glyph_grid, _element_text_length+1, __SCRIBBLE_PARSER_GLYPH.__SIZE);
    if (ds_grid_width(_word_grid ) < _element_text_length) ds_grid_resize(_word_grid,  _element_text_length+1, __SCRIBBLE_PARSER_GLYPH.__SIZE);
    
    
    
    var _tag_start           = undefined;
    var _tag_parameter_count = 0;
    var _tag_parameters      = undefined;
    var _tag_command_name    = "";
    
    var _glyph_count     = 0;
    var _glyph_ord       = 0x0;
    var _glyph_x_in_word = 0;
    
    var _state_colour       = _starting_colour;
    var _state_effect_flags = 0;
    var _state_scale        = 1.0;
    var _state_slant        = false;
    var _state_cycle        = false;
    var _state_cycle_colour = 0x00000000; //Uses all 4 bytes
    var _state_halign       = _starting_halign;
    
    repeat(string_byte_length(_element_text))
    {
        _glyph_ord = __scribble_buffer_read_unicode(_string_buffer);
        
        if (_tag_start != undefined)
        {
            if (_glyph_ord == SCRIBBLE_COMMAND_TAG_CLOSE) //If we've hit a command tag close character (usually ])
            {
                //Increment the parameter count and place a null byte for string reading
                ++_tag_parameter_count;
                buffer_poke(_string_buffer, buffer_tell(_string_buffer)-1, buffer_u8, 0);
                
                //Jump back to the start of the command tag and read out strings for the command parameters
                buffer_seek(_string_buffer, buffer_seek_start, _tag_start);
                repeat(_tag_parameter_count) _tag_parameters[@ array_length(_tag_parameters)] = buffer_read(_string_buffer, buffer_string);
                
                //Reset command tag state
                _tag_start = undefined;
                
                _tag_command_name = _tag_parameters[0];
                var _new_halign = undefined;
                var _new_valign = undefined;
                
                #region Command tag handling
                
                switch(_tag_command_name)
                {
                    #region Reset formatting
                    
                    case "":
                    case "/":
                        _state_colour       = _starting_colour;
                        _state_effect_flags = 0;
                        _state_scale        = 1.0;
                        _state_slant        = false;
                        _state_cycle        = false;
                        
                        if (_font_name != _starting_font)
                        {
                            _font_name = _starting_font;
                            __SCRIBBLE_PARSER_SET_FONT;
                        }
                    break;
                    
                    case "/font":
                    case "/f":
                        if (_font_name != _starting_font)
                        {
                            _font_name = _starting_font;
                            __SCRIBBLE_PARSER_SET_FONT;
                        }
                    break;
                    
                    case "/colour":
                    case "/color":
                    case "/c":
                        _state_colour = _starting_colour;
                    break;
                    
                    case "/scale":
                    case "/s":
                        _state_scale = 1.0;
                    break;
                    
                    case "/slant":
                        _state_slant = false;
                    break;
                    
                    #endregion
                    
                    case "/page":
                        //TODO - Page breaks
                    break;
                    
                    #region Scale
                    
                    case "scale":
                        if (_tag_parameter_count <= 1)
                        {
                            __scribble_trace("Not enough parameters for [scale] tag!");
                        }
                        else
                        {
                            _state_scale = real(_tag_parameters[1]);
                        }
                    break;
                    
                    case "scaleStack":
                        if (_tag_parameter_count <= 1)
                        {
                            __scribble_trace("Not enough parameters for [scaleStack] tag!");
                        }
                        else
                        {
                            _state_scale *= real(_tag_parameters[1]);
                        }
                    break;
                    
                    #endregion
                    
                    case "slant":
                        _state_slant = true;
                    break;
                    
                    #region Font Alignment
                    
                    case "fa_left":
                        _new_halign = fa_left;
                    break;
                    
                    case "fa_center":
                    case "fa_centre":
                        _new_halign = fa_center;
                    break;
                    
                    case "fa_right":
                        _new_halign = fa_right;
                    break;
                            
                    case "fa_top":
                        _new_valign = fa_top;
                    break;
                            
                    case "fa_middle":
                        _new_valign = fa_middle;
                    break;
                            
                    case "fa_bottom":
                        _new_valign = fa_bottom;
                    break;
                            
                    case "js_left":
                    case "js_center":
                    case "js_centre":
                    case "js_right":
                        __scribble_error("[js_*] tags have been deprecated. Please use [pin_*]");
                    break;
                            
                    case "pin_left":
                        _new_halign = __SCRIBBLE_PIN_LEFT;
                    break;
                            
                    case "pin_center":
                    case "pin_centre":
                        _new_halign = __SCRIBBLE_PIN_CENTRE;
                    break;
                            
                    case "pin_right":
                        _new_halign = __SCRIBBLE_PIN_RIGHT;
                    break;
                            
                    #endregion
                            
                    #region Non-breaking space emulation
                    
                    case "nbsp":
                    case "&nbsp":
                    case "nbsp;":
                    case "&nbsp;":
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X         ] = 0;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y         ] = 0;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHAR      ] = " "; //TODO - Debug, remove
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 160;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA ] = _font_data;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA] = _space_glyph_data;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS    ] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = _font_space_width;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = 0;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.TEXTURE   ] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.UVS       ] = undefined;
                        __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;
                        ++_glyph_count;
                    break;
                    
                    #endregion
                            
                    #region Cycle
                            
                    case "cycle":
                        var _cycle_r = (_tag_parameter_count > 1)? max(1, real(_tag_parameters[1])) : 0;
                        var _cycle_g = (_tag_parameter_count > 2)? max(1, real(_tag_parameters[2])) : 0;
                        var _cycle_b = (_tag_parameter_count > 3)? max(1, real(_tag_parameters[3])) : 0;
                        var _cycle_a = (_tag_parameter_count > 4)? max(1, real(_tag_parameters[4])) : 0;
                                
                        _state_cycle = true;
                        _state_cycle_colour = (_cycle_a << 24) | (_cycle_b << 16) | (_cycle_g << 8) | _cycle_r;
                                
                        _state_effect_flags = _state_effect_flags | (1 << global.__scribble_effects[? _tag_command_name]);
                    break;
                            
                    case "/cycle":
                        _state_cycle = false;
                        _state_effect_flags = ~((~_state_effect_flags) | (1 << global.__scribble_effects_slash[? _tag_command_name]));
                    break;
                            
                    #endregion
                            
                    #region Style shorthands
                            
                    case "r":
                    case "/b":
                    case "/i":
                    case "/bi":
                        //Get the required font from the font family
                        
                        var _new_font = _font_data.style_regular;
                        if (_new_font == undefined)
                        {
                            __scribble_trace("Regular style not set for font \"", _font_name, "\"");
                        }
                        else if (!ds_map_exists(global.__scribble_font_data, _new_font))
                        {
                            __scribble_trace("Font \"", _font_name, "\" not found (regular style for \"", _font_name, "\")");
                        }
                        else
                        {
                            _font_name = _new_font;
                            __SCRIBBLE_PARSER_SET_FONT;
                        }
                    break;
                            
                    case "b":
                        //Get the required font from the font family
                        
                        var _new_font = _font_data.style_bold;
                        if (_new_font == undefined)
                        {
                            __scribble_trace("Bold style not set for font \"", _font_name, "\"");
                        }
                        else if (!ds_map_exists(global.__scribble_font_data, _new_font))
                        {
                            __scribble_trace("Font \"", _font_name, "\" not found (bold style for \"", _font_name, "\")");
                        }
                        else
                        {
                            _font_name = _new_font;
                            __SCRIBBLE_PARSER_SET_FONT;
                        }
                    break;
                            
                    case "i":
                        //Get the required font from the font family
                        
                        var _new_font = _font_data.style_italic;
                        if (_new_font == undefined)
                        {
                            __scribble_trace("Italic style not set for font \"", _font_name, "\"");
                        }
                        else if (!ds_map_exists(global.__scribble_font_data, _new_font))
                        {
                            __scribble_trace("Font \"", _font_name, "\" not found (italic style for \"", _font_name, "\")");
                        }
                        else
                        {
                            _font_name = _new_font;
                            __SCRIBBLE_PARSER_SET_FONT;
                        }
                    break;
                            
                    case "bi":
                        //Get the required font from the font family
                        
                        var _new_font = _font_data.style_bold_italic;
                        if (_new_font == undefined)
                        {
                            __scribble_trace("Bold-Italic style not set for font \"", _font_name, "\"");
                        }
                        else if (!ds_map_exists(global.__scribble_font_data, _new_font))
                        {
                            __scribble_trace("Font \"", _font_name, "\" not found (bold-italic style for \"", _font_name, "\")");
                        }
                        else
                        {
                            _font_name = _new_font;
                            __SCRIBBLE_PARSER_SET_FONT;
                        }
                    break;
                            
                    #endregion
                            
                    case "surface":
                        //TODO - Insert surface
                    break;
                            
                    default:
                        if (ds_map_exists(global.__scribble_typewriter_events, _tag_command_name)) //Events
                        {
                            var _data = array_create(_tag_parameter_count-1);
                            var _j = 1;
                            repeat(_tag_parameter_count-1)
                            {
                                _data[@ _j-1] = _tag_parameters[_j];
                                ++_j;
                            }
                            
                            __new_event(characters, _tag_command_name, _data);
                        }
                        else if (ds_map_exists(global.__scribble_effects, _tag_command_name)) //Set an effect
                        {
                            _state_effect_flags = _state_effect_flags | (1 << global.__scribble_effects[? _tag_command_name]);
                        }
                        else if (ds_map_exists(global.__scribble_effects_slash, _tag_command_name)) //Check if this is a effect name, but with a forward slash at the front
                        {
                            _state_effect_flags = ~((~_state_effect_flags) | (1 << global.__scribble_effects_slash[? _tag_command_name]));
                        }
                        else if (ds_map_exists(global.__scribble_font_data, _tag_command_name)) //Change font
                        {
                            _font_name = _tag_command_name;
                            __SCRIBBLE_PARSER_SET_FONT;
                        }
                        else if (asset_get_type(_tag_command_name) == asset_sprite)
                        {
                            //TODO - Insert sprite
                        }
                        else if (asset_get_type(_tag_command_name) == asset_sound)
                        {
                            //TODO - Add sound playback event
                        }
                        else if (ds_map_exists(global.__scribble_colours, _tag_command_name)) //Set a pre-defined colour
                        {
                            _state_colour = global.__scribble_colours[? _tag_command_name];
                        }
                        else
                        {
                            var _first_char = string_copy(_tag_command_name, 1, 1);
                            if ((string_length(_tag_command_name) <= 7) && ((_first_char == "$") || (_first_char == "#")))
                            {
                                #region Hex colour decoding
                                
                                var _ord = ord(string_char_at(_tag_command_name, 3));
                                var _lsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                var _ord = ord(string_char_at(_tag_command_name, 2));
                                var _hsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                
                                var _red = _lsf + (_hsf << 4);
                                
                                var _ord = ord(string_char_at(_tag_command_name, 5));
                                var _lsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                var _ord = ord(string_char_at(_tag_command_name, 4));
                                var _hsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                
                                var _green = _lsf + (_hsf << 4);
                                
                                var _ord = ord(string_char_at(_tag_command_name, 7));
                                var _lsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                var _ord = ord(string_char_at(_tag_command_name, 6));
                                var _hsf = ((_ord >= global.__scribble_hex_min) && (_ord <= global.__scribble_hex_max))? global.__scribble_hex_array[_ord - global.__scribble_hex_min] : 0;
                                
                                var _blue = _lsf + (_hsf << 4);
                                
                                if (SCRIBBLE_BGR_COLOR_HEX_CODES)
                                {
                                    _state_colour = make_colour_rgb(_blue, _green, _red);
                                }
                                else
                                {
                                    _state_colour = make_colour_rgb(_red, _green, _blue);
                                }
                                
                                #endregion
                            }
                            else
                            {
                                var _second_char = string_copy(_tag_command_name, 2, 1);
                                if (((_first_char  == "d") || (_first_char  == "D"))
                                &&  ((_second_char == "$") || (_second_char == "#")))
                                {
                                    #region Decimal colour decoding
                                    
                                    //Check if this number is a real
                                    var _is_real = true;
                                    var _c = 3;
                                    repeat(string_length(_tag_command_name) - 2)
                                    {
                                        var _ord = ord(string_char_at(_tag_command_name, _c));
                                        if ((_ord < 48) || (_ord > 57))
                                        {
                                            _is_real = false;
                                            break;
                                        }
                                        
                                        ++_c;
                                    }
                                    
                                    if (_is_real)
                                    {
                                        try
                                        {
                                            _state_colour = real(string_delete(_tag_command_name, 1, 2));
                                        }
                                        catch(_error)
                                        {
                                            __scribble_trace("ERROR! Colour \"", string_delete(_tag_command_name, 1, 2), "\" not supported");
                                            _state_colour = c_white;
                                        }
                                    }
                                    else
                                    {
                                        __scribble_trace("WARNING! Could not decode [" + _tag_command_name + "], ensure it is a positive integer" );
                                    }
                                    
                                    #endregion
                                }
                                else
                                {
                                    var _command_string = string(_tag_command_name);
                                    var _j = 1;
                                    repeat(_tag_parameter_count-1) _command_string += "," + string(_tag_parameters[_j++]);
                                    __scribble_trace("WARNING! Unrecognised command tag [" + _command_string + "]" );
                                }
                            }
                        }
                    break;
                }
                        
                if ((_new_halign != undefined) && (_new_halign != _state_halign))
                {
                    _state_halign = _new_halign;
                    _new_halign = undefined;
                    
                    //TODO - Insert halign change command tag
                }
                        
                //Handle vertical alignment changes
                if (_new_valign != undefined)
                {
                    if (valign == undefined)
                    {
                        valign = _new_valign;
                    }
                    else if (valign != _new_valign)
                    {
                        __scribble_error("In-line vertical alignment cannot be set more than once");
                    }
                    
                    _new_valign = undefined;
                }
                
                #endregion
            }
            else if (_glyph_ord == SCRIBBLE_COMMAND_TAG_ARGUMENT) //If we've hit a command tag argument delimiter character (usually ,)
            {
                //Increment the parameter count and place a null byte for string reading later
                ++_tag_parameter_count;
                buffer_poke(_string_buffer, buffer_tell(_string_buffer)-1, buffer_u8, 0);
            }
        }
        else
        {
            if (_glyph_ord == SCRIBBLE_COMMAND_TAG_OPEN)
            {
                //Begin a command tag
                _tag_start           = buffer_tell(_string_buffer);
                _tag_parameter_count = 0;
                _tag_parameters      = [];
            }
            else if ((_glyph_ord == 10) //If we've hit a newline (\n)
                 || (SCRIBBLE_HASH_NEWLINE && (_glyph_ord == 35)) //If we've hit a hash, and hash newlines are on
                 || ((_glyph_ord == 13) && (buffer_peek(_string_buffer, buffer_tell(_string_buffer), buffer_u8) != 10))) //If this is a line feed but not followed by a newline... this fixes goofy Windows Notepad isses
            {
                //Add a newline glyph to our grid
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X         ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y         ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHAR      ] = "newline"; //TODO - Debug, remove
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 13;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS    ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.TEXTURE   ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.UVS       ] = undefined;
                __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;
                ++_glyph_count;
                
                _glyph_x_in_word = 0;
            }
            else if (_glyph_ord == 9)
            {
                //TODO - Support tabs
                _glyph_x_in_word = 0;
            }
            else if (_glyph_ord == 32)
            {
                //Add a space glyph to our grid
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X         ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y         ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHAR      ] = " "; //TODO - Debug: Remove
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 32;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA ] = _font_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA] = _space_glyph_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS    ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = _font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.TEXTURE   ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.UVS       ] = undefined;
                __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;
                ++_glyph_count;
                
                _glyph_x_in_word = 0;
            }
            else if (_glyph_ord > 32) //Only write glyphs that aren't system control characters
            {
                //TODO - Ligature transform here
                
                //Pull info out of the font's data structures
                if (_font_glyphs_array == undefined)
                {
                    //If there's no font array then check the font map
                    var _glyph_data = _font_glyphs_map[? _glyph_ord];
                    
                    //If our glyph is missing, choose the missing character glyph instead!
                    if (_glyph_data == undefined) _glyph_data = _font_glyphs_map[? ord(SCRIBBLE_MISSING_CHARACTER)];
                }
                else
                {
                    //Make sure this glyph is within the array's limits
                    if ((_glyph_ord >= _font_glyphs_min) && (_glyph_ord <= _font_glyphs_max))
                    {
                        var _glyph_data = _font_glyphs_array[_glyph_ord - _font_glyphs_min];
                    }
                    else
                    {
                        //Otherwise, choose the missing character glyph
                        _glyph_ord = ord(SCRIBBLE_MISSING_CHARACTER);
                        if ((_glyph_ord < _font_glyphs_min) || (_glyph_ord > _font_glyphs_max)) //TODO - Report an error when loading the font
                        {
                            var _glyph_data = undefined;
                        }
                        else
                        {
                            var _glyph_data = _font_glyphs_array[_glyph_ord - _font_glyphs_min];
                        }
                    }
                }
                
                if (_glyph_data == undefined)
                {
                    //This should only happen if SCRIBBLE_MISSING_CHARACTER is missing for a font
                    __scribble_trace("Couldn't find glyph data for character code " + string(_glyph_ord) + " (" + chr(_glyph_ord) + ") in font \"" + string(_font_name) + "\"");
                }
                else
                {
                    var _glyph_separation = _glyph_data[SCRIBBLE_GLYPH.SEPARATION];
                    
                    //Add this glyph to our grid
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X         ] = _glyph_x_in_word;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y         ] = 0;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHAR      ] = chr(_glyph_ord); //TODO - Debug, remove
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = _glyph_ord;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA ] = _font_data;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA] = _glyph_data;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS    ] = undefined;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = _glyph_data[SCRIBBLE_GLYPH.WIDTH];
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = _glyph_separation;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.TEXTURE   ] = _glyph_data[SCRIBBLE_GLYPH.TEXTURE];
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.UVS       ] = undefined;
                    __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;
                    ++_glyph_count;
                    
                    _glyph_x_in_word += _glyph_separation;
                }
            }
        }
    }
    
    //Set our vertical alignment if it hasn't been overrided
    if (valign == undefined) valign = _starting_valign;
    
    //Create a spoof space character so we correctly handle the last character in the string
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 32;
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = 0;
    
    
    
    #region Do line wrapping
    
    var _line_count       = 0;
    var _line_glyph_start = 0;
    var _line_glyph_end   = 0;
    var _line_word_start  = 0;
    var _line_word_end    = 0;
    var _line_height      = 0;
    
    var _word_count       = 0;
    var _word_glyph_start = 0;
    var _word_glyph_end   = 0;
    var _word_width       = 0;
    
    var _word_x      = 0;
    var _word_y      = 0;
    var _space_width = 0;
    
    var _i = 0;
    repeat(_glyph_count + 1) //Ensure we fully handle the last word
    {
        //TODO - Per-character wrapping
        
        var _glyph_ord = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ORD];
        if (_glyph_ord == 32)
        {
            #region Space
            
            _word_glyph_end = _i - 1;
            _space_width = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.WIDTH];
             
            if (_word_glyph_end >= _word_glyph_start)
            {
                var _last_glyph_width = _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.WIDTH];
                
                //Word width is equal to the width of the last glyph plus its x-coordinate in the word
                _word_width = _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X] + _last_glyph_width;
                
                //Steal the empty space for the last glyph and add it onto the space
                _space_width += _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.SEPARATION] - _last_glyph_width;
            }
            else
            {
                //Empty word (usually two spaces together)
                _word_glyph_start = _i + 1;
                _word_x += _space_width;
                ++_i;
                continue;
            }
            
            if (_word_width <= _model_max_width)
            {
                //Word is shorter than the maximum width, wrap it down to the next time
                
                if (_word_x + _word_width > _model_max_width)
                {
                    _line_height = ds_grid_get_max(_glyph_grid, _line_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _line_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT);
                    
                    __SCRIBBLE_PARSER_FINALIZE_LINE;
                    
                    _line_glyph_start = _word_glyph_start;
                    _line_word_start  = _word_count;
                    
                    _word_x  = 0;
                    _word_y += _line_height;
                }
                
                __SCRIBBLE_PARSER_ADD_WORD;
                
                _word_glyph_start = _i + 1;
                _word_x += _space_width + _word_width;
            }
            else
            {
                //The word itself is longer than the maximum width
                //Gotta split it up!
                
                _word_width = 0;
                var _prev_glyph_empty_space = 0;
                var _last_glyph = _word_glyph_end;
                
                var _j = _word_glyph_start;
                repeat(1 + _word_glyph_end - _word_glyph_start)
                {
                    var _glyph_width = _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.WIDTH];
                    if (_word_x + _word_width + _prev_glyph_empty_space + _glyph_width > _model_max_width)
                    {
                        _word_glyph_end = _j - 1;
                        
                        if (_word_glyph_end >= _word_glyph_start)
                        {
                            __SCRIBBLE_PARSER_ADD_WORD;
                        }
                        
                        _word_glyph_start = _j;
                        
                        _line_height = ds_grid_get_max(_glyph_grid, _line_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _line_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT);
                        
                        if (_word_count > 0)
                        {
                            __SCRIBBLE_PARSER_FINALIZE_LINE;
                        }
                        
                        _line_glyph_start = _word_glyph_start;
                        _line_word_start  = _word_count;
                        
                        ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _last_glyph, __SCRIBBLE_PARSER_GLYPH.X, -_glyph_grid[# _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X]);
                        
                        _word_x  = 0;
                        _word_y += _line_height;
                        _word_width = _glyph_width;
                    }
                    else
                    {
                        _word_width += _prev_glyph_empty_space + _glyph_width;
                    }
                    
                    _prev_glyph_empty_space = _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.SEPARATION] - _glyph_width;
                    
                    ++_j;
                }
                
                _word_glyph_end = _i - 1;
                __SCRIBBLE_PARSER_ADD_WORD;
                
                _word_glyph_start = _i + 1;
                _word_x += _word_width + _space_width;
            }
            
            #endregion
        }
        else if (_glyph_ord == 13)
        {
            #region Newline
            
            _word_glyph_end = _i - 1;
            
            if (_word_glyph_end >= _word_glyph_start)
            {
                __SCRIBBLE_PARSER_ADD_WORD;
            }
            
            //Word width is equal to the width of the last glyph plus its x-coordinate in the word
            _word_width = _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X] + _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.WIDTH];
            
            _line_height = ds_grid_get_max(_glyph_grid, _line_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _line_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT);
            
            if (_word_glyph_end >= _word_glyph_start)
            {
                __SCRIBBLE_PARSER_FINALIZE_LINE;
            }
            
            _word_glyph_start = _i + 1;
            
            _line_glyph_start = _word_glyph_start;
            _line_word_start  = _word_count;
            
            _word_x  = 0;
            _word_y += _line_height;
            
            #endregion
        }
        
        ++_i;
    }
    
    //Make sure we add a line for any words we have left on a trailing line
    if ((_line_glyph_end >= _line_glyph_start) && (_line_word_end >= _line_word_start))
    {
        __SCRIBBLE_PARSER_FINALIZE_LINE;
    }
    
    #endregion
    
    
    
    //TODO - Handle pages
    
    
    
    //TODO - Improve this calculation
    width  = ds_grid_get_max(_line_grid, 0, __SCRIBBLE_PARSER_LINE.WIDTH, _line_count - 1, __SCRIBBLE_PARSER_LINE.WIDTH);
    height = ds_grid_get_max(_glyph_grid, _line_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _line_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT) + _word_y;
    
    
    
    #region Handle alignment for each line and position words accordingly
    
    var _i = 0;
    repeat(_line_count)
    {
        var _line_halign = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.HALIGN];
        if (_line_halign != fa_left)
        {
            var _line_word_start = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_START];
            var _line_word_end   = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_END  ];
            var _line_width      = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WIDTH     ];
            
            if ((_line_halign == fa_center) || (_line_halign == fa_right))
            {
                var _empty_space = _model_max_width - _line_width;
                var _xoffset = 0;
                
                switch(_line_halign)
                {
                    case fa_center: _xoffset = _empty_space div 2; break;
                    case fa_right:  _xoffset = _empty_space;       break;
                }
                
                ds_grid_add_region(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.X, _line_word_end, __SCRIBBLE_PARSER_WORD.X, _xoffset);
            }
        }
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Move glyphs relative to where their parent word is located
    
    var _i = 0;
    repeat(_word_count)
    {
        var _word_glyph_start = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.GLYPH_START];
        var _word_glyph_end   = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.GLYPH_END  ];
        
        ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X, _word_grid[# _i, __SCRIBBLE_PARSER_WORD.X]);
        ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.Y, _word_grid[# _i, __SCRIBBLE_PARSER_WORD.Y]);
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Write glyphs to vertex buffers
    
    var _last_glyph_texture = undefined;
    var _page_data          = __new_page();
    var _vbuff              = undefined;
    
    var _i = 0;
    repeat(_glyph_count)
    {
        var _glyph_texture = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.TEXTURE];
        
        //Skip anything that doesn't have a texture (whitespace)
        if (_glyph_texture == undefined)
        {
            ++_i;
            continue;
        }
        
        var _glyph_x            = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X                 ];
        var _glyph_y            = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.Y                 ];
        var _glyph_data         = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA        ];
        var _glyph_uvs          = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.UVS               ];
        var _glyph_colour       = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_COLOUR      ];
        var _glyph_effect_flags = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_EFFECT_FLAGS];
        var _glyph_scale        = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_SCALE       ];
        var _glyph_slant        = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_SLANT       ];
        var _glyph_cycle        = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_CYCLE       ];
        var _glyph_cycle_colour = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.STATE_CYCLE_COLOUR];
        
        if (_glyph_uvs == undefined)
        {
            var _quad_u0 = _glyph_data[SCRIBBLE_GLYPH.U0];
            var _quad_v0 = _glyph_data[SCRIBBLE_GLYPH.V0];
            var _quad_u1 = _glyph_data[SCRIBBLE_GLYPH.U1];
            var _quad_v1 = _glyph_data[SCRIBBLE_GLYPH.V1];
        }
        else
        {
            var _quad_u0 = _glyph_uvs[0];
            var _quad_v0 = _glyph_uvs[1];
            var _quad_u1 = _glyph_uvs[2];
            var _quad_v1 = _glyph_uvs[3];
        }
        
        //Swap texture and buffer if needed
        if (_glyph_texture != _last_glyph_texture)
        {
            _last_glyph_texture = _glyph_texture;
            _vbuff = _page_data.__get_vertex_buffer(_glyph_texture, _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.FONT_DATA], true, self);
        }
                
        //Add glyph to buffer
        var _quad_l = _glyph_data[SCRIBBLE_GLYPH.X_OFFSET] + _glyph_x;
        var _quad_t = _glyph_data[SCRIBBLE_GLYPH.Y_OFFSET] + _glyph_y;
        var _quad_r = _glyph_data[SCRIBBLE_GLYPH.WIDTH   ] + _quad_l;
        var _quad_b = _glyph_data[SCRIBBLE_GLYPH.HEIGHT  ] + _quad_t;
                        
        var _quad_cx = 0.5*(_quad_l + _quad_r);
        var _quad_cy = 0.5*(_quad_t + _quad_b);
        
        var _slant_offset = SCRIBBLE_SLANT_AMOUNT*_glyph_scale*_glyph_slant*(_quad_b - _quad_t);
                
        var _delta_l  = _quad_cx - _quad_l;
        var _delta_t  = _quad_cy - _quad_t;
        var _delta_r  = _quad_cx - _quad_r;
        var _delta_b  = _quad_cy - _quad_b;
        var _delta_ls = _delta_l - _slant_offset;
        var _delta_rs = _delta_r - _slant_offset;
        
        var _glyph_sprite_data = 0; //TODO
        
        var _write_scale = 1.0; //_glyph_scale*_font_scale_dist; //TODO
        
        var _packed_indexes = _i*__SCRIBBLE_MAX_LINES + 1; //TODO
        
        if (_glyph_cycle)
        {
            var _colour = _glyph_cycle_colour;
        }
        else
        {
            var _colour = $FF000000 | _glyph_colour;
        }
        
        vertex_position_3d(_vbuff, _quad_l + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_ls, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);
        vertex_position_3d(_vbuff, _quad_r,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_r,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);
        vertex_position_3d(_vbuff, _quad_l,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_l,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);
        vertex_position_3d(_vbuff, _quad_r,                 _quad_b, _packed_indexes); vertex_normal(_vbuff, _delta_r,  _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v1); vertex_float2(_vbuff, _write_scale, _delta_b);
        vertex_position_3d(_vbuff, _quad_l + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_ls, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u0, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);
        vertex_position_3d(_vbuff, _quad_r + _slant_offset, _quad_t, _packed_indexes); vertex_normal(_vbuff, _delta_rs, _glyph_sprite_data, _glyph_effect_flags); vertex_argb(_vbuff, _colour); vertex_texcoord(_vbuff, _quad_u1, _quad_v0); vertex_float2(_vbuff, _write_scale, _delta_t);
        
        ++_i;
    }
    
    #endregion
    
    
    
    //Ensure we've ended the vertex buffers we created
    __finalize_vertex_buffers();
    
    
    
    return true;
}

function __scribble_buffer_read_unicode(_buffer)
{
    var _value = buffer_read(_buffer, buffer_u8);
    
    if ((_value & $E0) == $C0) //two-byte
    {
        _value  = (                         _value & $1F) <<  6;
        _value += (buffer_read(_buffer, buffer_u8) & $3F);
    }
    else if ((_value & $F0) == $E0) //three-byte
    {
        _value  = (                         _value & $0F) << 12;
        _value += (buffer_read(_buffer, buffer_u8) & $3F) <<  6;
        _value +=  buffer_read(_buffer, buffer_u8) & $3F;
    }
    else if ((_value & $F8) == $F0) //four-byte
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
    var _value = buffer_peek(_buffer, _offset, buffer_u8);
    
    if ((_value & $E0) == $C0) //two-byte
    {
        _value  = (                                    _value & $1F) <<  6;
        _value += (buffer_peek(_buffer, _offset+1, buffer_u8) & $3F);
    }
    else if ((_value & $F0) == $E0) //three-byte
    {
        _value  = (                                    _value & $0F) << 12;
        _value += (buffer_peek(_buffer, _offset+1, buffer_u8) & $3F) <<  6;
        _value +=  buffer_peek(_buffer, _offset+2, buffer_u8) & $3F;
    }
    else if ((_value & $F8) == $F0) //four-byte
    {
        _value  = (                                     _value & $07) << 18;
        _value += (buffer_peek(_buffer, _offset+1,  buffer_u8) & $3F) << 12;
        _value += (buffer_peek(_buffer, _offset+2,  buffer_u8) & $3F) <<  6;
        _value +=  buffer_peek(_buffer, _offset+3,  buffer_u8) & $3F;
    }
    
    return _value;
}