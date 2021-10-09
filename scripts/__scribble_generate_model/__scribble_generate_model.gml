/// @param element

function __scribble_generate_model(_element)
{
    var _model_max_width  = _element.wrap_max_width;
    var _model_max_height = _element.wrap_max_height;
    
    if (_model_max_width  < 0) _model_max_width  = infinity;
    if (_model_max_height < 0) _model_max_height = infinity;
    
    
    
    #region Build Bezier curve segment lengths
      
    //Make a copy of the Bezier array
    var _element_bezier_array = _element.bezier_array;
    var _bezier_do = ((_element_bezier_array[0] != _element_bezier_array[4]) || (_element_bezier_array[1] != _element_bezier_array[5]));
    if (_bezier_do)
    {
        var _bezier_array = array_create(6);
        array_copy(_bezier_array, 0, _element_bezier_array, 0, 6);
        
        var _bx2 = _bezier_array[0];
        var _by2 = _bezier_array[1];
        var _bx3 = _bezier_array[2];
        var _by3 = _bezier_array[3];
        var _bx4 = _bezier_array[4];
        var _by4 = _bezier_array[5];
        
        var _bezier_lengths = array_create(SCRIBBLE_BEZIER_ACCURACY, 0.0);
        var _x1 = undefined;
        var _y1 = undefined;
        var _x2 = 0;
        var _y2 = 0;
        
        var _dist = 0;
        
        var _bezier_param_increment = 1 / (SCRIBBLE_BEZIER_ACCURACY-1);
        var _t = _bezier_param_increment;
        var _i = 1;
        repeat(SCRIBBLE_BEZIER_ACCURACY-1)
        {
            var _inv_t = 1 - _t;
            
            _x1 = _x2;
            _y1 = _y2;
            _x2 = 3.0*_inv_t*_inv_t*_t*_bx2 + 3.0*_inv_t*_t*_t*_bx3 + _t*_t*_t*_bx4;
            _y2 = 3.0*_inv_t*_inv_t*_t*_by2 + 3.0*_inv_t*_t*_t*_by3 + _t*_t*_t*_by4;
            
            var _dx = _x2 - _x1;
            var _dy = _y2 - _y1;
            _dist += sqrt(_dx*_dx + _dy*_dy);
            _bezier_lengths[@ _i] = _dist;
            
            _t += _bezier_param_increment;
            ++_i;
        }
        
        if (_model_max_width >= 0) __scribble_trace("Warning! Maximum width set by scribble_set_wrap() (" + string(_model_max_width) + ") has been replaced with Bezier curve length (" + string(_dist) + "). Use -1 as the maximum width to turn off this warning");
        _model_max_width = _dist;
    }
    
    #endregion
    
    
    
    var _starting_colour = __scribble_process_colour(_element.starting_colour);
    var _starting_halign = _element.starting_halign;
    var _starting_valign = _element.starting_valign;
    var _character_wrap  = _element.wrap_per_char;
    var _ignore_commands = _element.__ignore_command_tags;
    
    
    
    #region Collect starting font data
    
    var _starting_font = _element.starting_font;
    if (_starting_font == undefined) __scribble_error("The default font has not been set\nCheck that you've added fonts to Scribble (scribble_font_add() / scribble_font_add_from_sprite() etc.)");
    
    var _font_name = _starting_font;
    __SCRIBBLE_PARSER_SET_FONT;
    
    #endregion
    
    
    
    //Set up line height limits
    var _line_height_min = _element.line_height_min;
    var _line_height_max = _element.line_height_max;
    
    if (_line_height_min < 0) _line_height_min = _font_line_height;
    if (_line_height_max < 0) _line_height_max = infinity;
    
    
    
    //Start the parser!
    var _element_text        = _element.text;
    var _element_text_length = string_length(_element_text);
    
    var _string_buffer = global.__scribble_buffer;
    var _glyph_grid    = global.__scribble_glyph_grid;
    var _word_grid     = global.__scribble_word_grid;
    var _line_grid     = global.__scribble_line_grid;
    
    buffer_seek(_string_buffer, buffer_seek_start, 0);
    buffer_write(_string_buffer, buffer_string, _element_text);
    buffer_write(_string_buffer, buffer_u64, 0x0); //Add some extra null characters to avoid errors where we're reading outside the buffer
    buffer_seek(_string_buffer, buffer_seek_start, 0);
    
    //Resize grids if we have to
    if (ds_grid_width(_glyph_grid) < _element_text_length) ds_grid_resize(_glyph_grid, _element_text_length+1, __SCRIBBLE_PARSER_GLYPH.__SIZE);
    if (ds_grid_width(_word_grid ) < _element_text_length) ds_grid_resize(_word_grid,  _element_text_length+1, __SCRIBBLE_PARSER_GLYPH.__SIZE);
    
    
    
    #region Glyph parser
    
    var _tag_start           = undefined;
    var _tag_parameter_count = 0;
    var _tag_parameters      = undefined;
    var _tag_command_name    = "";
    
    var _glyph_count     = 0;
    var _glyph_ord       = 0x0;
    var _glyph_x_in_word = 0;
    
    var _state_colour       = _starting_colour;
    var _state_alpha_255    = 0xFF;
    var _state_final_colour = (_state_alpha_255 << 24) | _state_colour; //Uses all four bytes
    var _state_effect_flags = 0;
    var _state_scale        = 1.0;
    var _state_slant        = false;
    var _state_cycle        = false;
    var _state_halign       = _starting_halign;
    var _state_command_tag_flipflop = false;
    var _character_index    = 0;
    
    __SCRIBBLE_PARSER_WRITE_HALIGN;
    
    //Repeat a fixed number of times. This prevents infinite loops and generally is more stable...
    //...though we do still check for a null terminator
    repeat(string_byte_length(_element_text))
    {
        _glyph_ord = __scribble_buffer_read_unicode(_string_buffer);
        
        //Break out if we hit a null terminator
        if (_glyph_ord == 0x00) break;
        
        if (SCRIBBLE_FIX_ESCAPED_NEWLINES)
        {
            if ((_glyph_ord == 0x5C) && (buffer_peek(_string_buffer, buffer_tell(_string_buffer), buffer_u8) == 0x6E)) //Backslash followed by "n"
            {
                buffer_seek(_string_buffer, buffer_seek_relative, 1);
                _glyph_ord = 0x0A;
            }
        }
        
        if (_tag_start != undefined)
        {
            #region Command tag handling
            
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
                
                switch(_tag_command_name)
                {
                    #region Reset formatting
                    
                    //Resets:
                    //    - colour
                    //    - effect flags (inc. cycle)
                    //    - scale
                    //    - slant
                    //    - font
                    //But NOT alignment
                    
                    case "":
                    case "/":
                        _state_colour       = _starting_colour;
                        _state_alpha_255    = 0xFF;
                        _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
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
                        if (!_state_cycle) _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                    break;
                    
                    case "/alpha":
                    case "/a":
                        _state_alpha_255 = 0xFF;
                        if (!_state_cycle) _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
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
                        #region Add a pagebreak (ASCII 0x0C, "form feed") glyph to our grid
                        
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD        ] = 0x0C; //ASCII form feed (dec = 12)
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA  ] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA ] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS     ] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH      ] = 0;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT     ] = 0;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION ] = 0;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED] = undefined;
                        __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;
                        ++_glyph_count;
                        
                        _glyph_x_in_word = 0;
                        
                        #endregion
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
                    
                    case "alpha":
                        _state_alpha_255 = floor(255*clamp(_tag_parameters[1], 0, 1));
                        if (!_state_cycle) _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
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
                            
                    case "fa_justify":
                        _new_halign = __SCRIBBLE_JUSTIFY;
                    break;
                            
                    #endregion
                            
                    #region Non-breaking space emulation
                    
                    case "nbsp":
                    case "&nbsp":
                    case "nbsp;":
                    case "&nbsp;":
                        var _glyph_separation = _state_scale*_font_space_width;
                        
                        repeat((array_length(_tag_parameters) == 2)? real(_tag_parameters[1]) : 1)
                        {
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD            ] = 0xA0; //Non-breaking space (dec = 160)
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA      ] = _font_data;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA     ] = _space_glyph_data;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS         ] = undefined;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH          ] = _state_scale*_font_space_width;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT         ] = _state_scale*_font_line_height;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION     ] = _glyph_separation;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX    ] = undefined;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX    ] = undefined;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED    ] = undefined;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX] = _character_index;
                            __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;
                            ++_glyph_count;
                            
                            ++_character_index;
                            _glyph_x_in_word += _glyph_separation; //Already includes scaling
                        }
                    break;
                    
                    #endregion
                            
                    #region Cycle
                            
                    case "cycle":
                        var _cycle_r = (_tag_parameter_count > 1)? max(1, real(_tag_parameters[1])) : 0;
                        var _cycle_g = (_tag_parameter_count > 2)? max(1, real(_tag_parameters[2])) : 0;
                        var _cycle_b = (_tag_parameter_count > 3)? max(1, real(_tag_parameters[3])) : 0;
                        var _cycle_a = (_tag_parameter_count > 4)? max(1, real(_tag_parameters[4])) : 0;
                                
                        _state_cycle = true;
                        _state_final_colour = (_cycle_a << 24) | (_cycle_b << 16) | (_cycle_g << 8) | _cycle_r;
                                
                        _state_effect_flags = _state_effect_flags | (1 << global.__scribble_effects[? _tag_command_name]);
                    break;
                            
                    case "/cycle":
                        _state_cycle = false;
                        _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                        
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
                    
                    #region Surface
                    
                    case "surface":
                        var _surface = real(_tag_parameters[1]);
                        var _surface_width = _state_scale*surface_get_width(_surface);
                        
                        if (!SCRIBBLE_COLORIZE_SPRITES)
                        {
                            var _old_colour       = _state_final_colour;
                            var _old_effect_flags = _state_effect_flags;
                            
                            _state_final_colour = 0xFFFFFFFF;
                            
                            //Switch off rainbow
                            _glyph_effect_flags = ~((~_glyph_effect_flags) | (1 << global.__scribble_effects[? "rainbow"]));
                            
                            //Switch off colour cycling
                            _glyph_effect_flags = ~((~_glyph_effect_flags) | (1 << global.__scribble_effects[? "cycle"]));
                        }
                        
                        //Add this glyph to our grid
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD            ] = __SCRIBBLE_PARSER_SURFACE;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA      ] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA     ] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS         ] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH          ] = _surface_width; //Already includes scaling
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT         ] = _state_scale*surface_get_height(_surface);
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION     ] = _surface_width; //Already includes scaling
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX    ] = _surface;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX    ] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED    ] = undefined;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX] = _character_index;
                        __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;
                        ++_glyph_count;
                            
                        ++_character_index;
                        _glyph_x_in_word += _surface_width;
                        
                        if (!SCRIBBLE_COLORIZE_SPRITES)
                        {
                            _state_final_colour = _old_colour;
                            _state_effect_flags = _old_effect_flags;
                        }
                    break;
                    
                    #endregion
                            
                    default:
                        if (ds_map_exists(global.__scribble_colours, _tag_command_name)) //Set a pre-defined colour
                        {
                            _state_colour = global.__scribble_colours[? _tag_command_name] & 0xFFFFFF;
                            if (!_state_cycle) _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                        }
                        else if (ds_map_exists(global.__scribble_typewriter_events, _tag_command_name)) //Events
                        {
                            array_delete(_tag_parameters, 0, 1);
                            __SCRIBBLE_PARSER_WRITE_EVENT;
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
                            #region Sprite
                            
                            var _sprite_index = asset_get_index(_tag_command_name);
                            var _sprite_width = _state_scale*sprite_get_width(_sprite_index);
                            
                            var _image_index = 0;
                            var _image_speed = 0;
                            switch(_tag_parameter_count)
                            {
                                case 1:
                                    _image_index = 0;
                                    _image_speed = SCRIBBLE_DEFAULT_SPRITE_SPEED;
                                break;
                                                            
                                case 2:
                                    _image_index = real(_tag_parameters[1]);
                                    _image_speed = 0;
                                break;
                                                            
                                default:
                                    _image_index = real(_tag_parameters[1]);
                                    _image_speed = real(_tag_parameters[2]);
                                break;
                            }
                            
                            var _old_effect_flags = _state_effect_flags;
                            if (_image_speed > 0) _state_effect_flags |= 1; //Set the sprite flag bit
                        
                            if (!SCRIBBLE_COLORIZE_SPRITES)
                            {
                                var _old_colour = _state_final_colour;
                                _state_final_colour = 0xFFFFFFFF;
                                
                                //Switch off rainbow
                                _state_effect_flags = ~((~_state_effect_flags) | (1 << global.__scribble_effects[? "rainbow"]));
                                
                                //Switch off colour cycling
                                _state_effect_flags = ~((~_state_effect_flags) | (1 << global.__scribble_effects[? "cycle"]));
                            }
                            
                            //Add this glyph to our grid
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD            ] = __SCRIBBLE_PARSER_SPRITE;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA      ] = undefined;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA     ] = undefined;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS         ] = undefined;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH          ] = _sprite_width; //Already includes scaling
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT         ] = _state_scale*sprite_get_height(_sprite_index);
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION     ] = _sprite_width; //Already includes scaling
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX    ] = _sprite_index;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX    ] = _image_index;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED    ] = _image_speed;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX] = _character_index;
                            __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;
                            ++_glyph_count;
                            
                            ++_character_index;
                            _glyph_x_in_word += _sprite_width;
                            
                            _state_effect_flags = _old_effect_flags;
                            if (!SCRIBBLE_COLORIZE_SPRITES) _state_final_colour = _old_colour;
                            
                            #endregion
                        }
                        else if (asset_get_type(_tag_command_name) == asset_sound)
                        {
                            var _tag_command_name = __SCRIBBLE_AUDIO_COMMAND_TAG;
                            __SCRIBBLE_PARSER_WRITE_EVENT;
                        }
                        else
                        {
                            var _first_char = string_copy(_tag_command_name, 1, 1);
                            if ((string_length(_tag_command_name) <= 7) && ((_first_char == "$") || (_first_char == "#")))
                            {
                                #region Hex colour decoding
                                
                                try
                                {
                                    var _state_colour = real("0x" + string_delete(_tag_command_name, 1, 1));
                                    
                                    if (!SCRIBBLE_BGR_COLOR_HEX_CODES)
                                    {
                                        _state_colour = scribble_rgb_to_bgr(_state_colour);
                                    }
                                }
                                catch(_)
                                {
                                    __scribble_trace("Error! \"", string_delete(_tag_command_name, 1, 2), "\" could not be converted into a hexcode");
                                    _state_colour = _starting_colour;
                                }
                                
                                if (!_state_cycle) _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                                
                                #endregion
                            }
                            else
                            {
                                var _second_char = string_copy(_tag_command_name, 2, 1);
                                if (((_first_char  == "d") || (_first_char  == "D"))
                                &&  ((_second_char == "$") || (_second_char == "#")))
                                {
                                    #region Decimal colour decoding
                                    
                                    try
                                    {
                                        _state_colour = real(string_delete(_tag_command_name, 1, 2));
                                    }
                                    catch(_error)
                                    {
                                        __scribble_trace("Error! \"", string_delete(_tag_command_name, 1, 2), "\" could not be converted into a decimal");
                                        _state_colour = _starting_colour;
                                    }
                                    
                                    if (!_state_cycle) _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                                    
                                    #endregion
                                }
                                else
                                {
                                    var _command_string = string(_tag_command_name);
                                    var _j = 1;
                                    repeat(_tag_parameter_count-1) _command_string += "," + string(_tag_parameters[_j++]);
                                    __scribble_trace("Warning! Unrecognised command tag [" + _command_string + "]" );
                                }
                            }
                        }
                    break;
                }
                
                if ((_new_halign != undefined) && (_new_halign != _state_halign))
                {
                    _state_halign = _new_halign;
                    _new_halign = undefined;
                    
                    if ((_glyph_grid[# _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.ORD] != 13) && (_glyph_grid[# _glyph_count-1, __SCRIBBLE_PARSER_GLYPH.ORD] != __SCRIBBLE_PARSER_HALIGN))
                    {
                        //Add a newline glyph to our grid
                        __SCRIBBLE_PARSER_WRITE_NEWLINE;
                        
                        _glyph_x_in_word = 0;
                    }
                    
                    __SCRIBBLE_PARSER_WRITE_HALIGN;
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
            }
            else if (_glyph_ord == SCRIBBLE_COMMAND_TAG_ARGUMENT) //If we've hit a command tag argument delimiter character (usually ,)
            {
                //Increment the parameter count and place a null byte for string reading later
                ++_tag_parameter_count;
                buffer_poke(_string_buffer, buffer_tell(_string_buffer)-1, buffer_u8, 0);
            }
            
            #endregion
        }
        else
        {
            if (!_ignore_commands && (_glyph_ord == SCRIBBLE_COMMAND_TAG_OPEN) && (_state_command_tag_flipflop || (__scribble_buffer_peek_unicode(_string_buffer, buffer_tell(_string_buffer)) != SCRIBBLE_COMMAND_TAG_OPEN)))
            {
                if (_state_command_tag_flipflop)
                {
                    _state_command_tag_flipflop = false;
                }
                else
                {
                    //Begin a command tag
                    _tag_start           = buffer_tell(_string_buffer);
                    _tag_parameter_count = 0;
                    _tag_parameters      = [];
                }
            }
            else if ((_glyph_ord == 0x0A) //If we've hit a newline (\n)
                 || (SCRIBBLE_HASH_NEWLINE && (_glyph_ord == 0x23)) //If we've hit a hash, and hash newlines are on
                 || ((_glyph_ord == 0x0D) && (buffer_peek(_string_buffer, buffer_tell(_string_buffer), buffer_u8) != 0x0A))) //If this is a line feed but not followed by a newline... this fixes goofy Windows Notepad isses
            {
                //Add a newline glyph to our grid
                __SCRIBBLE_PARSER_WRITE_NEWLINE;
                
                _glyph_x_in_word = 0;
            }
            else if (_glyph_ord == 0x09) //ASCII horizontal tab (dec = 9, obviously)
            {
                #region Add a tab glyph to our grid
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD            ] = 0x09; //ASCII horizontal tab (dec = 9, obviously)
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA      ] = _font_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA     ] = _space_glyph_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS         ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH          ] = _state_scale*SCRIBBLE_TAB_WIDTH*_font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT         ] = _state_scale*_font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION     ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX    ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX    ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED    ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX] = _character_index;
                __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;
                ++_glyph_count;
                
                ++_character_index;
                _glyph_x_in_word = 0;
                
                #endregion
            }
            else if (_glyph_ord == 0x20) //ASCII space (dec = 32)
            {
                #region Add a space glyph to our grid
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD            ] = 0x20; //ASCII space (dec = 32)
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA      ] = _font_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA     ] = _space_glyph_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS         ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH          ] = _state_scale*_font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT         ] = _state_scale*_font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION     ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX    ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX    ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED    ] = undefined;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX] = _character_index;
                __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;
                ++_glyph_count;
                
                ++_character_index;
                _glyph_x_in_word = 0;
                
                #endregion
            }
            else if (_glyph_ord > 0x20) //Only write glyphs that aren't system control characters
            {
                #region Add a standard glyph
                
                //TODO - Ligature transform here
                
                #region Pull info out of the font's data structures
                
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
                
                #endregion
                
                if (_glyph_data == undefined)
                {
                    //This should only happen if SCRIBBLE_MISSING_CHARACTER is missing for a font
                    __scribble_trace("Couldn't find glyph data for character code " + string(_glyph_ord) + " (" + chr(_glyph_ord) + ") in font \"" + string(_font_name) + "\"");
                }
                else
                {
                    var _glyph_separation = _state_scale*_glyph_data[SCRIBBLE_GLYPH.SEPARATION];
                    
                    //Add this glyph to our grid
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD            ] = _glyph_ord;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA      ] = _font_data;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA     ] = _glyph_data;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.EVENTS         ] = undefined;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH          ] = _state_scale*_glyph_data[SCRIBBLE_GLYPH.WIDTH];
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT         ] = _state_scale*_font_line_height;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION     ] = _glyph_separation; //Already includes scaling
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX    ] = undefined;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX    ] = undefined;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED    ] = undefined;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX] = _character_index;
                    __SCRIBBLE_PARSER_WRITE_GLYPH_STATE;
                    ++_glyph_count;
                    
                    ++_character_index;
                    _glyph_x_in_word += _glyph_separation; //Already includes scaling
                }
                
                if (_glyph_ord == SCRIBBLE_COMMAND_TAG_OPEN) _state_command_tag_flipflop = true;
                
                //Add a per-character delay if required
                if (global.__scribble_character_delay)
                {
                    var _delay = global.__scribble_character_delay_map[? _glyph_ord];
                    if (_delay != undefined)
                    {
                        var _tag_command_name = "delay";
                        var _tag_parameters = [_delay];
                        __SCRIBBLE_PARSER_WRITE_EVENT;
                    }
                }
                
                #endregion
            }
        }
    }
    
    //Set our vertical alignment if it hasn't been overrided
    if (valign == undefined) valign = _starting_valign;
    
    //Create a null terminator so we correctly handle the last character in the string
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD            ] = 0x00;
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH          ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION     ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX] = _character_index;
    
    #endregion
    
    
    
    #region Organise glyphs into words, and handle newlines and line wrapping
    
    var _line_count      = 0;
    var _line_word_start = 0;
    var _line_word_end   = 0;
    
    var _word_count       = 0;
    var _word_glyph_start = 0;
    var _word_glyph_end   = 0;
    var _word_width       = 0;
    
    var _word_x       = 0;
    var _space_width  = 0;
    var _state_halign = fa_left;
    
    var _i = 0;
    repeat(_glyph_count + 1) //Ensure we fully handle the last word
    {
        var _glyph_ord = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ORD];
        if ((_glyph_ord == 0x00)  //Null
        ||  (_glyph_ord == 0x09)  //Horizontal tab (dec = 9)
        ||  (_glyph_ord == 0x0C)  //Page break ("form feed", dec = 12)
        ||  (_glyph_ord == 0x0D)  //Line break (dec = 13)
        ||  (_glyph_ord == 0x20)) //Space (dec = 32)
        {
            #region Word break
            
            _word_glyph_end = _i - 1;
            _space_width = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.WIDTH];
            
            if (_word_glyph_end < _word_glyph_start)
            {
                //Empty word (usually two spaces together)
                _word_glyph_start = _i + 1;
                _word_x += _space_width;
            }
            else
            {
                var _last_glyph_width = _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.WIDTH];
                
                //Word width is equal to the width of the last glyph plus its x-coordinate in the word
                _word_width = _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X] + _last_glyph_width;
                
                //Steal the empty space for the last glyph and add it onto the space
                _space_width += _glyph_grid[# _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.SEPARATION] - _last_glyph_width;
                
                if ((_word_width <= _model_max_width) && !_character_wrap) //TODO - Optimise per-character wrapping
                {
                    //Word is shorter than the maximum width, wrap it down to the next time
                    
                    if (_word_x + _word_width > _model_max_width)
                    {
                        _line_word_end = _word_count - 1;
                        __SCRIBBLE_PARSER_ADD_LINE;
                        _line_word_start = _word_count;
                        
                        _word_x = 0;
                    }
                    
                    __SCRIBBLE_PARSER_ADD_WORD;
                    
                    _word_glyph_start = _i + 1;
                    _word_x += _space_width + _word_width;
                }
                else
                {
                    #region The word itself is longer than the maximum width
                
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
                        
                            if (_word_count > 0)
                            {
                                _line_word_end = _word_count - 1;
                                __SCRIBBLE_PARSER_ADD_LINE;
                                _line_word_start = _word_count;
                            }
                        
                            //Adjust the x-coord-in-word position of the remaining glyphs in the word
                            ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _last_glyph, __SCRIBBLE_PARSER_GLYPH.X, -_glyph_grid[# _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X]);
                        
                            _word_x     = 0;
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
                
                    #endregion
                }
            }
            
            #endregion
        }
        
        if (_glyph_ord == 0x0C)
        {
            #region Page break
            
            _word_glyph_end = _i - 1;
            
            if (_word_glyph_end >= _word_glyph_start)
            {
                __SCRIBBLE_PARSER_ADD_WORD;
            }
            
            _line_word_end = _word_count - 1;
            __SCRIBBLE_PARSER_ADD_LINE;
            _line_word_start = _word_count;
            
            //Add an infinitely high line (which we'll read as a page break in a later step)
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.Y         ] = 0;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_START] = -1;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WORD_END  ] = -2;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.WIDTH     ] = 0;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HEIGHT    ] = infinity;
            _line_grid[# _line_count, __SCRIBBLE_PARSER_LINE.HALIGN    ] = _state_halign;
            _line_count++;
            
            _word_x     = 0;
            _word_width = 0;
            _word_glyph_start = _i + 1;
            
            #endregion
        }
        else if (_glyph_ord == 0x0D)
        {
            #region Line break
            
            _word_glyph_end = _i - 1;
            
            if (_word_glyph_end >= _word_glyph_start)
            {
                __SCRIBBLE_PARSER_ADD_WORD;
            }
            
            _line_word_end = _word_count - 1;
            __SCRIBBLE_PARSER_ADD_LINE;
            _line_word_start = _word_count;
            
            _word_x     = 0;
            _word_width = 0;
            _word_glyph_start = _i + 1;
            
            #endregion
        }
        else if (_glyph_ord == __SCRIBBLE_PARSER_HALIGN)
        {
            _state_halign = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX];
        }
        
        ++_i;
    }
    
    //Make sure we add a line for any words we have left on a trailing line
    _line_word_end = _word_count - 1;
    if (_line_word_end >= _line_word_start)
    {
        __SCRIBBLE_PARSER_ADD_LINE;
    }
    
    #endregion
    
    
    
    width = ds_grid_get_max(_line_grid, 0, __SCRIBBLE_PARSER_LINE.WIDTH, _line_count - 1, __SCRIBBLE_PARSER_LINE.WIDTH);
    
    
    
    #region Handle alignment for each line and position words accordingly
    
    var _page_data = __new_page();
    _page_data.__glyph_start = _word_grid[# _line_grid[# 0, __SCRIBBLE_PARSER_LINE.WORD_START], __SCRIBBLE_PARSER_WORD.GLYPH_START];
    
    if (_model_max_width != infinity)
    {
        var _alignment_width = _model_max_width;
    }
    else
    {
        var _alignment_width = width;
    }
    
    var _line_y = 0;
    var _i = 0;
    repeat(_line_count)
    {
        var _line_height     = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.HEIGHT    ];
        var _line_word_start = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_START];
        var _line_word_end   = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_END  ];
        
        if (_line_height == infinity)
        {
            _page_data.__glyph_end = _word_grid[# _line_grid[# _i-1, __SCRIBBLE_PARSER_LINE.WORD_END], __SCRIBBLE_PARSER_WORD.GLYPH_END];
            
            var _page_char_start = _glyph_grid[# _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
            ds_grid_add_region(_glyph_grid, _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, -_page_char_start);
            _page_data.__character_count = 1 + _glyph_grid[# _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
            
            _page_data = __new_page();
            _page_data.__glyph_start = _word_grid[# _line_grid[# _i+1, __SCRIBBLE_PARSER_LINE.WORD_START], __SCRIBBLE_PARSER_WORD.GLYPH_START];
            
            _line_y = 0;
            _line_height = 0;
        }
        
        //Create a new page if we've run off the end of the current one
        if ((_line_y + _line_height > _model_max_height) && (_line_y > 0))
        {
            _page_data.__glyph_end = _word_grid[# _line_grid[# _i-1, __SCRIBBLE_PARSER_LINE.WORD_END], __SCRIBBLE_PARSER_WORD.GLYPH_END];
            
            var _page_char_start = _glyph_grid[# _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
            ds_grid_add_region(_glyph_grid, _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, -_page_char_start);
            _page_data.__character_count = 1 + _glyph_grid[# _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
            
            _page_data = __new_page();
            _page_data.__glyph_start = _word_grid[# _line_word_start, __SCRIBBLE_PARSER_WORD.GLYPH_START];
            
            _line_y = 0;
        }
        
        _line_grid[# _i, __SCRIBBLE_PARSER_LINE.Y] = _line_y;
        
        //Only adjust word positions if we actually have words on this line
        if (_line_word_end - _line_word_start >= 0)
        {
            var _line_width  = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WIDTH ];
            var _line_halign = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.HALIGN];
            
            if (SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE) 
            {
                var _line_x_offset = 0;
                
                //Search over all glyphs for the line looking for a valid glyph
                //We use that's glyph's x-offset to adjust the position / width of the line
                //We have to search over the entire line because events and alignment changes are stored as glyphs
                var _line_glyph_start = _word_grid[# _line_word_start, __SCRIBBLE_PARSER_WORD.GLYPH_START];
                var _line_glyph_end   = _word_grid[# _line_word_end,   __SCRIBBLE_PARSER_WORD.GLYPH_END  ];
                
                var _j = _line_glyph_start;
                repeat(1 + _line_glyph_end - _line_glyph_start)
                {
                    var _glyph_data = _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA];
                    if (is_array(_glyph_data))
                    {
                        _line_x_offset = _glyph_data[SCRIBBLE_GLYPH.X_OFFSET];
                        break;
                    }
                    
                    ++_j;
                }
                
                if (_line_x_offset > 0)
                {
                    ds_grid_add_region(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.X, _line_word_end, __SCRIBBLE_PARSER_WORD.X, -_line_x_offset);
                    
                    _line_width -= _line_x_offset;
                    _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WIDTH] = _line_width;
                }
            }
            
            //Move words vertically onto the line
            if (_line_y != 0)
            {
                ds_grid_add_region(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.Y, _line_word_end, __SCRIBBLE_PARSER_WORD.Y, _line_y);
            }
            
            if ((_line_halign != fa_left) && (_line_halign != __SCRIBBLE_PIN_LEFT)) //fa_left and pin_left do nothing
            {
                #region Other (simpler!) types of alignment
                
                var _xoffset = 0;
                switch(_line_halign)
                {
                    case fa_center:             _xoffset = -(_line_width div 2);                   break;
                    case fa_right:              _xoffset = -_line_width;                           break;
                    case __SCRIBBLE_PIN_CENTRE: _xoffset = (_alignment_width - _line_width) div 2; break;
                    case __SCRIBBLE_PIN_RIGHT:  _xoffset = _alignment_width - _line_width;         break;
                }
                
                if (_xoffset != 0)
                {
                    ds_grid_add_region(_word_grid, _line_word_start, __SCRIBBLE_PARSER_WORD.X, _line_word_end, __SCRIBBLE_PARSER_WORD.X, _xoffset);
                }
                
                _line_grid[# _i, __SCRIBBLE_PARSER_LINE.X      ] = _xoffset;
                _line_grid[# _i, __SCRIBBLE_PARSER_LINE.X_RIGHT] = _xoffset + _line_width;
                
                #endregion
            }
            else
            {
                //Either aligned left or justified
                _line_grid[# _i, __SCRIBBLE_PARSER_LINE.X_RIGHT] = _line_width;
                
                if ((_line_halign == __SCRIBBLE_JUSTIFY) && (_i < _line_count - 1)) //Don't try to justify text on the last line
                {
                    #region Justify
                    
                    var _line_word_count = 1 + _line_word_end - _line_word_start;
                    if (_line_word_count > 1) //Prevent div-by-zero
                    {
                        //Distribute spacing over the line, on which there are n-1 spaces
                        var _spacing_incr = (_alignment_width - _line_width) / (_line_word_count - 1);
                        var _spacing = _spacing_incr;
                        
                        var _j = _line_word_start + 1; //Skip the first word
                        repeat(_line_word_count - 1)
                        {
                            _word_grid[# _j, __SCRIBBLE_PARSER_WORD.X] = floor(_word_grid[# _j, __SCRIBBLE_PARSER_WORD.X] + _spacing);
                            _spacing += _spacing_incr;
                            ++_j;
                        }
                    }
                    
                    #endregion
                }
            }
        }
        
        //Vertically centre words
        var _j = _line_word_start;
        repeat(1 + _line_word_end - _line_word_start)
        {
            _word_grid[# _j, __SCRIBBLE_PARSER_WORD.Y] += (_line_height - _word_grid[# _j, __SCRIBBLE_PARSER_WORD.HEIGHT]) div 2;
            ++_j;
        }
        
        _line_y += _line_height;
        
        ++_i;
    }
    
    _page_data.__glyph_end = _word_grid[# _line_grid[# _i-1, __SCRIBBLE_PARSER_LINE.WORD_END], __SCRIBBLE_PARSER_WORD.GLYPH_END];
    
    var _page_char_start = _glyph_grid[# _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
    ds_grid_add_region(_glyph_grid, _page_data.__glyph_start, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX, -_page_char_start);
    _page_data.__character_count = 1 + _glyph_grid[# _page_data.__glyph_end, __SCRIBBLE_PARSER_GLYPH.CHARACTER_INDEX];
    
    height = _line_y;
    
    min_x = ds_grid_get_min(_line_grid, 0, __SCRIBBLE_PARSER_LINE.X,       _line_count - 1, __SCRIBBLE_PARSER_LINE.X      );
    max_x = ds_grid_get_min(_line_grid, 0, __SCRIBBLE_PARSER_LINE.X_RIGHT, _line_count - 1, __SCRIBBLE_PARSER_LINE.X_RIGHT);
    
    #endregion
    
    
    
    #region Move glyphs relative to where their parent word is located
    
    var _i = 0;
    repeat(_word_count)
    {
        var _word_glyph_start = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.GLYPH_START];
        var _word_glyph_end   = _word_grid[# _i, __SCRIBBLE_PARSER_WORD.GLYPH_END  ];
        
        if (_word_glyph_end - _word_glyph_start >= 0)
        {
            ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X, _word_grid[# _i, __SCRIBBLE_PARSER_WORD.X]);
            
            //x-axis is easy, the difficult bit is the y-axis
            //Basically, we want the glyph's top y-coordinate = word.y + (word.height - glyph.height)/2
            //Doing this in bulk using grid functions requires us to do this in four steps:
            //  1) glyph.y  = glyph.height
            //  2) glyph.y -= word.height + 2*word.y
            //  3) glyph.y *= -0.5
            //We have to do some funny stuff with the signs because it's not possible to subtract a region, only to add a region
            //Fortunately we can reverse some signs and get away with it!
            
            //FIXME - This is broken in runtime 23.1.1.385 (2021-09-26)
            //ds_grid_set_grid_region(_glyph_grid, _glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y);
            
            //FIXME - Workaround for the above. This is slower than using the ds_grid functions
            var _j = _word_glyph_start;
            repeat(1 + _word_glyph_end - _word_glyph_start)
            {
                _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.Y] = _glyph_grid[# _j, __SCRIBBLE_PARSER_GLYPH.HEIGHT];
                ++_j;
            }
            
            ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.Y, -_word_grid[# _i, __SCRIBBLE_PARSER_WORD.HEIGHT] - 2*_word_grid[# _i, __SCRIBBLE_PARSER_WORD.Y]);
            ds_grid_multiply_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.Y, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.Y, -0.5);
        }
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Write glyphs to page vertex buffers
    
    if (_bezier_do)
    {
        //Prep for Bezier curve shenanigans if necessary
        var _bezier_search_index = 0;
        var _bezier_search_d0    = 0;
        var _bezier_search_d1    = _bezier_lengths[1];
        var _bezier_prev_cx      = 0;
    }
    
    var _p = 0;
    repeat(pages)
    {
        var _page_data          = pages_array[_p];
        var _page_events_dict   = _page_data.__events;
        var _vbuff              = undefined;
        var _last_glyph_texture = undefined;
        var _glyph_sprite_data  = 0;
        var _character_index    = 0;
        
        buffer_seek(_string_buffer, buffer_seek_start, 0);
        
        var _i = _page_data.__glyph_start;
        repeat(1 + _page_data.__glyph_end - _page_data.__glyph_start)
        {
            var _glyph_ord = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ORD];
            if (_glyph_ord == __SCRIBBLE_PARSER_SPRITE)
            {
                #region Write sprite
                
                __SCRIBBLE_PARSER_READ_GLYPH_DATA;
                
                buffer_write(_string_buffer, buffer_u8, 0x1A); //Unicode/ASCII "substitute character"
                _character_index++;
                
                var _write_scale = _glyph_scale;
                                        
                var _sprite_index = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX];
                var _image_index  = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX];
                var _image_speed  = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED];
                var _glyph_width  = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.WIDTH      ]; //Already multiplied by the glyph scale
                var _glyph_height = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.HEIGHT     ]; //Already multiplied by the glyph scale
                
                if (SCRIBBLE_ADD_SPRITE_ORIGINS)
                {
                    _glyph_x += (_glyph_width  div 2) - _glyph_scale*sprite_get_xoffset(_sprite_index);
                    _glyph_y += (_glyph_height div 2) - _glyph_scale*sprite_get_yoffset(_sprite_index);
                }
                
                var _sprite_number = sprite_get_number(_sprite_index);
                if (_sprite_number >= 64)
                {
                    __scribble_trace("In-line sprites cannot have more than 64 frames (", sprite_get_name(_sprite_index), ")");
                    _sprite_number = 64;
                }
                
                if (_image_speed >= 4)
                {
                    __scribble_trace("Image speed cannot be more than 4.0 (" + string(_image_speed) + ")");
                    _image_speed = 4;
                }
                
                if (_image_speed < 0)
                {
                    __scribble_trace("Image speed cannot be less than 0.0 (" + string(_image_speed) + ")");
                    _image_speed = 0;
                }
                
                var _glyph_sprite_data = 4096*floor(1024*_image_speed) + 64*_sprite_number + _image_index;
                var _j = _image_index;
                repeat((_image_speed > 0)? _sprite_number : 1) //Only draw one image if we have an image speed of 0 since we're not animating
                {
                    var _glyph_texture = sprite_get_texture(_sprite_index, _j);
                    
                    var _uvs = sprite_get_uvs(_sprite_index, _j);
                    var _quad_u0 = _uvs[0];
                    var _quad_v0 = _uvs[1];
                    var _quad_u1 = _uvs[2];
                    var _quad_v1 = _uvs[3];
                    
                    var _quad_l = _glyph_x + _uvs[4]*_glyph_scale;
                    var _quad_t = _glyph_y + _uvs[5]*_glyph_scale;
                    var _quad_r = _quad_l  + _uvs[6]*_glyph_width;
                    var _quad_b = _quad_t  + _uvs[7]*_glyph_height;
                    
                    __SCRIBBLE_PARSER_WRITE_GLYPH;
                    
                    ++_j;
                    ++_glyph_sprite_data;
                }
                
                _glyph_sprite_data = 0; //Reset this because every other tyoe of glyph doesn't use this
                
                #endregion
            }
            else if (_glyph_ord == __SCRIBBLE_PARSER_SURFACE)
            {
                #region Write surface
                
                __SCRIBBLE_PARSER_READ_GLYPH_DATA;
                
                buffer_write(_string_buffer, buffer_u8, 0x1A); //Unicode/ASCII "substitute character"
                _character_index++;
                
                var _write_scale = _glyph_scale;
                                       
                var _surface      = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX];
                var _glyph_width  = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.WIDTH      ]; //Already multiplied by the glyph scale
                var _glyph_height = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.HEIGHT     ]; //Already multiplied by the glyph scale
                
                var _glyph_texture = surface_get_texture(_surface);
                
                var _quad_u0 = 0;
                var _quad_v0 = 0;
                var _quad_u1 = 1;
                var _quad_v1 = 1;
                
                var _quad_l = _glyph_x;
                var _quad_t = _glyph_y;
                var _quad_r = _quad_l + _glyph_width;
                var _quad_b = _quad_t + _glyph_height;
                
                __SCRIBBLE_PARSER_WRITE_GLYPH;
                
                #endregion
            }
            else if (_glyph_ord == __SCRIBBLE_PARSER_EVENT)
            {
                #region Add event to page
                
                var _event_array = _page_events_dict[$ _character_index];
                if (!is_array(_event_array))
                {
                    var _event_array = [];
                    _page_events_dict[$ _character_index] = _event_array;
                }
                
                var _event = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX];
                _event.position = _character_index;
                array_push(_event_array, _event);
                
                #endregion
            }
            else if (_glyph_ord == 9)
            {
                buffer_write(_string_buffer, buffer_u8, 9);
                _character_index++;
            }
            else if (_glyph_ord == 32)
            {
                buffer_write(_string_buffer, buffer_u8, 32);
                _character_index++;
            }
            else if (_glyph_ord > 32)
            {
                #region Write standard glyph
                
                __SCRIBBLE_PARSER_READ_GLYPH_DATA;
                
                __scribble_buffer_write_unicode(_string_buffer, _glyph_ord);
                _character_index++;
                
                var _write_scale = _glyph_scale*_glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.FONT_SCALE_DIST]; //TODO - Optimise this
                
                var _glyph_data = _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA];
                var _glyph_texture = _glyph_data[SCRIBBLE_GLYPH.TEXTURE];
                var _quad_u0 = _glyph_data[SCRIBBLE_GLYPH.U0];
                var _quad_v0 = _glyph_data[SCRIBBLE_GLYPH.V0];
                var _quad_u1 = _glyph_data[SCRIBBLE_GLYPH.U1];
                var _quad_v1 = _glyph_data[SCRIBBLE_GLYPH.V1];
                
                //Add glyph to buffer
                var _quad_l = _glyph_data[SCRIBBLE_GLYPH.X_OFFSET]*_glyph_scale + _glyph_x;
                var _quad_t = _glyph_data[SCRIBBLE_GLYPH.Y_OFFSET]*_glyph_scale + _glyph_y;
                var _quad_r = _glyph_data[SCRIBBLE_GLYPH.WIDTH   ]*_glyph_scale + _quad_l;
                var _quad_b = _glyph_data[SCRIBBLE_GLYPH.HEIGHT  ]*_glyph_scale + _quad_t;
                
                __SCRIBBLE_PARSER_WRITE_GLYPH;
                
                #endregion
            }
            
            ++_i;
        }
        
        buffer_write(_string_buffer, buffer_u8, 0x0);
        buffer_seek(_string_buffer, buffer_seek_start, 0);
        _page_data.__text = buffer_read(_string_buffer, buffer_string);
        
        characters += _page_data.__character_count;
        
        ++_p;
    }
    
    #endregion
    
    
    
    //Ensure we've ended the vertex buffers we created
    __finalize_vertex_buffers(_element.freeze);
    
    
    
    return true;
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