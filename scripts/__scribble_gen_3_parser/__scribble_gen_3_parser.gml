function __scribble_gen_3_parser()
{
    //Cache globals locally for a performance boost
    var _string_buffer = global.__scribble_buffer;
    var _glyph_grid    = global.__scribble_glyph_grid;
    var _word_grid     = global.__scribble_word_grid;
    var _control_grid  = global.__scribble_control_grid; //This grid is cleared at the bottom of __scribble_generate_model()
    
    var _arabic_map_join_next = global.__scribble_glyph_data.arabic_join_next_map;
    var _arabic_map_join_prev = global.__scribble_glyph_data.arabic_join_prev_map;
    
    //Cache element properties locally
    var _element         = global.__scribble_generator_state.element;
    var _element_text    = _element.text;
    var _starting_colour = __scribble_process_colour(_element.starting_colour);
    var _starting_halign = _element.starting_halign;
    var _starting_valign = _element.starting_valign;
    var _ignore_commands = _element.__ignore_command_tags;
    
    var _starting_font = _element.starting_font;
    if (_starting_font == undefined) __scribble_error("The default font has not been set\nCheck that you've added fonts to Scribble (scribble_font_add() / scribble_font_add_from_sprite() etc.)");
    
    var _font_name = _starting_font;
    
    //Place our input string into a buffer for quicker reading
    buffer_seek(_string_buffer, buffer_seek_start, 0);
    buffer_write(_string_buffer, buffer_string, _element_text);
    buffer_write(_string_buffer, buffer_u64, 0x0); //Add some extra null characters to avoid errors where we're reading outside the buffer
    buffer_seek(_string_buffer, buffer_seek_start, 0);
    
    //Resize grids if we have to
    var _element_text_length = string_length(_element_text);
    if (ds_grid_width(_glyph_grid) < _element_text_length) ds_grid_resize(_glyph_grid, _element_text_length+1, __SCRIBBLE_PARSER_GLYPH.__SIZE);
    if (ds_grid_width(_word_grid ) < _element_text_length) ds_grid_resize(_word_grid,  _element_text_length+1, __SCRIBBLE_PARSER_GLYPH.__SIZE);
    
    //Start the parser!
    var _tag_start           = undefined;
    var _tag_parameter_count = 0;
    var _tag_parameters      = undefined;
    var _tag_command_name    = "";
    
    var _glyph_count       = 0;
    var _glyph_ord         = 0x0000;
    var _arabic_glyph_prev = _glyph_ord;
    
    var _control_count = 0;
    var _control_page  = 0;
    
    var _state_colour       = _starting_colour;
    var _state_alpha_255    = 0xFF;
    var _state_final_colour = (_state_alpha_255 << 24) | _state_colour; //Uses all four bytes
    var _state_effect_flags = 0;
    var _state_scale        = 1.0;
    var _state_slant        = false;
    var _state_cycle        = false;
    var _state_halign       = _starting_halign;
    var _state_command_tag_flipflop = false;
    
    var _state_colour_start_glyph  = 0;
    var _state_effects_start_glyph = 0;
    var _state_scale_start_glyph   = 0;
    var _state_slant_start_glyph   = 0;
    
    var _font_scale_dist        = 0;
    var _font_scale_start_glyph = 0;
    
    __SCRIBBLE_PARSER_SET_FONT;
    __SCRIBBLE_PARSER_WRITE_HALIGN;
    
    //Repeat a fixed number of times. This prevents infinite loops and generally is more stable...
    //...though we do still check for a null terminator
    repeat(string_byte_length(_element_text))
    {
        //_glyph_ord = __scribble_buffer_read_unicode(_string_buffer);
        
        // In-lined __scribble_buffer_read_unicode() for speed
        var _glyph_ord = buffer_read(_string_buffer, buffer_u8); //Assume 0xxxxxxx
        
        // Break out if we hit a null terminator
        if (_glyph_ord == 0x00) break;
        
        // Only do the following tests if the first byte is large enough (the MSB is 1)
        if ((_glyph_ord & $E0) == $C0) //110xxxxx 10xxxxxx
        {
            _glyph_ord = ((_glyph_ord & $1F) << 6) | (buffer_read(_string_buffer, buffer_u8) & $3F);
        }
        else if ((_glyph_ord & $F0) == $E0) //1110xxxx 10xxxxxx 10xxxxxx
        {
            var _glyph_ord_b = buffer_read(_string_buffer, buffer_u8);
            var _glyph_ord_c = buffer_read(_string_buffer, buffer_u8);
            _glyph_ord = ((_glyph_ord & $0F) << 12) | ((_glyph_ord_b & $3F) <<  6) | (_glyph_ord_c & $3F);
        }
        else if ((_glyph_ord & $F8) == $F0) //11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
        {
            var _glyph_ord_b = buffer_read(_string_buffer, buffer_u8);
            var _glyph_ord_c = buffer_read(_string_buffer, buffer_u8);
            var _glyph_ord_d = buffer_read(_string_buffer, buffer_u8);
            _glyph_ord = ((_glyph_ord & $07) << 18) | ((_glyph_ord_b & $3F) << 12) | ((_glyph_ord_c & $3F) <<  6) | (_glyph_ord_d & $3F);
        }
        else if (SCRIBBLE_FIX_ESCAPED_NEWLINES)
        {
            // If we haven't needed to process 2/3/4-byte UTF8 glyphs then check for \n replacement (if enabled)
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
                        __SCRIBBLE_PARSER_POP_COLOUR;
                        __SCRIBBLE_PARSER_POP_EFFECT_FLAGS;
                        __SCRIBBLE_PARSER_POP_SCALE;
                        __SCRIBBLE_PARSER_POP_SLANT;
                        
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
                        if (!_state_cycle)
                        {
                            __SCRIBBLE_PARSER_POP_COLOUR;
                            _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                        }
                    break;
                    
                    case "/alpha":
                    case "/a":
                        _state_alpha_255 = 0xFF;
                        if (!_state_cycle)
                        {
                            __SCRIBBLE_PARSER_POP_COLOUR;
                            _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                        }
                    break;
                    
                    case "/scale":
                    case "/s":
                        __SCRIBBLE_PARSER_POP_SCALE;
                    break;
                    
                    case "/slant":
                        __SCRIBBLE_PARSER_POP_SLANT;
                        _state_slant = false;
                    break;
                    
                    #endregion
                    
                    case "/page":
                        __SCRIBBLE_PARSER_WRITE_PAGEBREAK;
                    break;
                    
                    #region Scale
                    
                    case "scale":
                        if (_tag_parameter_count <= 1)
                        {
                            __scribble_trace("Not enough parameters for [scale] tag!");
                        }
                        else
                        {
                            __SCRIBBLE_PARSER_POP_SCALE;
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
                            __SCRIBBLE_PARSER_POP_SCALE;
                            _state_scale *= real(_tag_parameters[1]);
                        }
                    break;
                    
                    #endregion
                    
                    case "slant":
                        __SCRIBBLE_PARSER_POP_SLANT;
                        _state_slant = true;
                    break;
                    
                    case "alpha":
                        _state_alpha_255 = floor(255*clamp(_tag_parameters[1], 0, 1));
                        if (!_state_cycle)
                        {
                            __SCRIBBLE_PARSER_POP_COLOUR;
                            _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                        }
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
                        repeat((array_length(_tag_parameters) == 2)? real(_tag_parameters[1]) : 1)
                        {
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 0xA0; //Non-breaking space (dec = 160)
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA ] = _font_data;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA] = _space_glyph_data;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = _font_space_width;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = _font_space_width;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI      ] = __SCRIBBLE_BIDI.SYMBOL;
                            ++_glyph_count;
                            
                            _arabic_glyph_prev = 0xA0; //Non-breaking space (dec = 160)
                        }
                    break;
                    
                    #endregion
                            
                    #region Cycle
                            
                    case "cycle":
                        __SCRIBBLE_PARSER_POP_COLOUR;
                        
                        var _cycle_r = (_tag_parameter_count > 1)? max(1, real(_tag_parameters[1])) : 0;
                        var _cycle_g = (_tag_parameter_count > 2)? max(1, real(_tag_parameters[2])) : 0;
                        var _cycle_b = (_tag_parameter_count > 3)? max(1, real(_tag_parameters[3])) : 0;
                        var _cycle_a = (_tag_parameter_count > 4)? max(1, real(_tag_parameters[4])) : 0;
                                
                        _state_cycle = true;
                        _state_final_colour = (_cycle_a << 24) | (_cycle_b << 16) | (_cycle_g << 8) | _cycle_r;
                                
                        _state_effect_flags = _state_effect_flags | (1 << global.__scribble_effects[? _tag_command_name]);
                    break;
                            
                    case "/cycle":
                        __SCRIBBLE_PARSER_POP_COLOUR;
                        
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
                        
                        //if (!SCRIBBLE_COLORIZE_SPRITES)
                        //{
                        //    var _old_colour       = _state_final_colour;
                        //    var _old_effect_flags = _state_effect_flags;
                        //    
                        //    _state_final_colour = 0xFFFFFFFF;
                        //    
                        //    //Switch off rainbow
                        //    _glyph_effect_flags = ~((~_glyph_effect_flags) | (1 << global.__scribble_effects[? "rainbow"]));
                        //    
                        //    //Switch off colour cycling
                        //    _glyph_effect_flags = ~((~_glyph_effect_flags) | (1 << global.__scribble_effects[? "cycle"]));
                        //}
                        
                        //Add this glyph to our grid
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD        ] = __SCRIBBLE_GLYPH_SURFACE;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH      ] = surface_get_width(_surface);
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT     ] = surface_get_height(_surface);
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION ] = surface_get_width(_surface);
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX] = _surface;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI       ] = __SCRIBBLE_BIDI.SYMBOL;
                        ++_glyph_count;
                        
                        _arabic_glyph_prev = __SCRIBBLE_GLYPH_SURFACE;
                        
                        //if (!SCRIBBLE_COLORIZE_SPRITES)
                        //{
                        //    _state_final_colour = _old_colour;
                        //    _state_effect_flags = _old_effect_flags;
                        //}
                    break;
                    
                    #endregion
                            
                    default:
                        if (ds_map_exists(global.__scribble_effects, _tag_command_name)) //Set an effect
                        {
                            _state_effect_flags = _state_effect_flags | (1 << global.__scribble_effects[? _tag_command_name]);
                        }
                        else if (ds_map_exists(global.__scribble_effects_slash, _tag_command_name)) //Check if this is a effect name, but with a forward slash at the front
                        {
                            _state_effect_flags = ~((~_state_effect_flags) | (1 << global.__scribble_effects_slash[? _tag_command_name]));
                        }
                        else if (ds_map_exists(global.__scribble_colours, _tag_command_name)) //Set a pre-defined colour
                        {
                            _state_colour = global.__scribble_colours[? _tag_command_name] & 0xFFFFFF;
                            if (!_state_cycle)
                            {
                                __SCRIBBLE_PARSER_POP_COLOUR;
                                _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                            }
                        }
                        else if (ds_map_exists(global.__scribble_typewriter_events, _tag_command_name)) //Events
                        {
                            array_delete(_tag_parameters, 0, 1);
                            __SCRIBBLE_PARSER_WRITE_EVENT;
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
                        
                            //if (!SCRIBBLE_COLORIZE_SPRITES)
                            //{
                            //    var _old_colour = _state_final_colour;
                            //    _state_final_colour = 0xFFFFFFFF;
                            //    
                            //    //Switch off rainbow
                            //    _state_effect_flags = ~((~_state_effect_flags) | (1 << global.__scribble_effects[? "rainbow"]));
                            //    
                            //    //Switch off colour cycling
                            //    _state_effect_flags = ~((~_state_effect_flags) | (1 << global.__scribble_effects[? "cycle"]));
                            //}
                            
                            //Add this glyph to our grid
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD        ] = __SCRIBBLE_GLYPH_SPRITE;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH      ] = sprite_get_width(_sprite_index);
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT     ] = sprite_get_height(_sprite_index);
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION ] = sprite_get_width(_sprite_index);
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ASSET_INDEX] = _sprite_index;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX] = _image_index;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED] = _image_speed;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI       ] = __SCRIBBLE_BIDI.SYMBOL;
                            ++_glyph_count;
                            
                            _state_effect_flags = _old_effect_flags;
                            //if (!SCRIBBLE_COLORIZE_SPRITES) _state_final_colour = _old_colour;
                            
                            _arabic_glyph_prev = __SCRIBBLE_GLYPH_SPRITE;
                            
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
                                catch(_error)
                                {
                                    __scribble_trace("Error! \"", string_delete(_tag_command_name, 1, 2), "\" could not be converted into a hexcode");
                                    _state_colour = _starting_colour;
                                }
                                
                                if (!_state_cycle)
                                {
                                    __SCRIBBLE_PARSER_POP_COLOUR;
                                    _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
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
                                    
                                    try
                                    {
                                        _state_colour = real(string_delete(_tag_command_name, 1, 2));
                                    }
                                    catch(_error)
                                    {
                                        __scribble_trace("Error! \"", string_delete(_tag_command_name, 1, 2), "\" could not be converted into a decimal");
                                        _state_colour = _starting_colour;
                                    }
                                    
                                    if (!_state_cycle)
                                    {
                                        __SCRIBBLE_PARSER_POP_COLOUR;
                                        _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                                    }
                                    
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
                
                //If this command set a new horizontal alignment, and this alignment is different to what we had before, store it as a command
                if ((_new_halign != undefined) && (_new_halign != _state_halign))
                {
                    _state_halign = _new_halign;
                    _new_halign = undefined;
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
            if ((_glyph_ord == SCRIBBLE_COMMAND_TAG_OPEN) && !_ignore_commands && (_state_command_tag_flipflop || (__scribble_buffer_peek_unicode(_string_buffer, buffer_tell(_string_buffer)) != SCRIBBLE_COMMAND_TAG_OPEN)))
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
                 || (SCRIBBLE_HASH_NEWLINE && (_glyph_ord == 0x23))) //If we've hit a hash, and hash newlines are on
            {
                //Add a newline glyph to our grid
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 0x0A; //ASCII line break (dec = 10)
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI      ] = __SCRIBBLE_BIDI.LINE_BREAK;
                ++_glyph_count;
                
                _arabic_glyph_prev = 0x0A;
            }
            else if (_glyph_ord == 0x09) //ASCII horizontal tab (dec = 9, obviously)
            {
                #region Add a tab glyph to our grid
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 0x09; //ASCII horizontal tab (dec = 9, obviously)
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA ] = _font_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA] = _space_glyph_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = SCRIBBLE_TAB_WIDTH*_font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = SCRIBBLE_TAB_WIDTH*_font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI      ] = __SCRIBBLE_BIDI.WHITESPACE;
                ++_glyph_count;
                
                _arabic_glyph_prev = 0x09;
                
                #endregion
            }
            else if (_glyph_ord == 0x20) //ASCII space (dec = 32)
            {
                #region Add a space glyph to our grid
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 0x20; //ASCII space (dec = 32)
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA ] = _font_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA] = _space_glyph_data;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = _font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = _font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI      ] = __SCRIBBLE_BIDI.WHITESPACE;
                ++_glyph_count;
                
                _arabic_glyph_prev = 0x20;
                
                #endregion
            }
            else if (_glyph_ord > 0x20) //Only write glyphs that aren't system control characters
            {
                #region Add a standard glyph
                
                var _glyph_write = _glyph_ord;
                
                //TODO - Ligature transform here
                
                #region Arabic handling
                
                if ((_glyph_write >= 0x0600) && (_glyph_write <= 0x06FF)) // Arabic Unicode block
                {
                    has_arabic = true;
                    
                    var _buffer_offset = buffer_tell(_string_buffer);
                    var _glyph_next = __scribble_buffer_peek_unicode(_string_buffer, _buffer_offset);
                    
                    // Lam with Alef ligatures
                    if (_glyph_write == 0x0644)
                    {
                        var _glyph_replacement = undefined;
                        switch(_glyph_next)
                        {
                            case 0x0622: var _glyph_replacement = 0xFEF5; break; //Lam with Alef with madda above
                            case 0x0623: var _glyph_replacement = 0xFEF7; break; //Lam with Alef with hamza above
                            case 0x0625: var _glyph_replacement = 0xFEF9; break; //Lam with Alef with madda below
                            case 0x0627: var _glyph_replacement = 0xFEFB; break; //Lam with Alef with hamza below
                        }
                        
                        if (_glyph_replacement != undefined)
                        {
                            _glyph_write = _glyph_replacement;
                            
                            // Skip over the next glyph entirely
                            // The size of an Alef, no matter what form, is only 2 bytes
                            buffer_seek(_string_buffer, buffer_seek_relative, 2);
                            
                            _glyph_next = __scribble_buffer_peek_unicode(_string_buffer, _buffer_offset);
                        }
                    }
                    
                    // If the next glyph is tashkil, ignore it for the purposes of determining join state
                    while((_glyph_next >= 0x064B) && (_glyph_next <= 0x0652)) // Tashkil range
                    {
                        _buffer_offset += 2;
                        _glyph_next = __scribble_buffer_peek_unicode(_string_buffer, _buffer_offset);
                    }
                    
                    // Figure out what to replace this glyph with, depending on what glyphs around it join in which directions
                    var _new_glyph = undefined;
                    if (_arabic_map_join_next[? _arabic_glyph_prev]) // Does the previous glyph allow joining to us?
                    {
                        if (_arabic_map_join_prev[? _glyph_next]) // Does the next glyph allow joining to us?
                        {
                            var _new_glyph = global.__scribble_glyph_data.arabic_medial_map[? _glyph_write];
                        }
                        else
                        {
                            var _new_glyph = global.__scribble_glyph_data.arabic_final_map[? _glyph_write];
                        }
                    }
                    else
                    {
                        if (_arabic_map_join_prev[? _glyph_next]) // Does the next glyph allow joining to us?
                        {
                            var _new_glyph = global.__scribble_glyph_data.arabic_initial_map[? _glyph_write];
                        }
                        else
                        {
                            var _new_glyph = global.__scribble_glyph_data.arabic_isolated_map[? _glyph_write];
                        }
                    }
                    
                    // Update the glyph we're trying to write if we found a replacement
                    if (_new_glyph != undefined) _glyph_write = _new_glyph;
                    
                    // If this glyph isn't tashkil then update the previous glyph state
                    if ((_glyph_next < 0x064B) || (_glyph_next > 0x0652)) _arabic_glyph_prev = _glyph_ord;
                }
                else
                {
                    _arabic_glyph_prev = _glyph_ord;
                }
                
                #endregion
                
                //Pull info out of the font's data structures
                var _glyph_data = _font_glyphs_map[? _glyph_write];
                
                //If our glyph is missing, choose the missing character glyph instead!
                if (_glyph_data == undefined) _glyph_data = _font_glyphs_map[? ord(SCRIBBLE_MISSING_CHARACTER)];
                
                if (_glyph_data == undefined)
                {
                    //This should only happen if SCRIBBLE_MISSING_CHARACTER is missing for a font
                    __scribble_trace("Couldn't find glyph data for character code " + string(_glyph_write) + " (" + chr(_glyph_write) + ") in font \"" + string(_font_name) + "\"");
                }
                else
                {
                    //Add this glyph to our grid
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = _glyph_write;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.FONT_DATA ] = _font_data;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.GLYPH_DATA] = _glyph_data;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = _glyph_data[SCRIBBLE_GLYPH.WIDTH];
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = _glyph_data[SCRIBBLE_GLYPH.SEPARATION];
                    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI      ] = _glyph_data[SCRIBBLE_GLYPH.BIDI];
                    ++_glyph_count;
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
    
    __SCRIBBLE_PARSER_POP_COLOUR;
    __SCRIBBLE_PARSER_POP_EFFECT_FLAGS;
    __SCRIBBLE_PARSER_POP_SCALE;
    __SCRIBBLE_PARSER_POP_SLANT;
    
    //Set our vertical alignment if it hasn't been overrided
    if (valign == undefined) valign = _starting_valign;
    
    //Create a null terminator so we correctly handle the last character in the string
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 0x00;
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = 0;
    
    //Also create a null terminator for control messages
    _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.TYPE    ] = 0;
    _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.DATA    ] = undefined;
    _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.POSITION] = _glyph_count;
    _control_grid[# _control_count, __SCRIBBLE_PARSER_CONTROL.PAGE    ] = _control_page;
    
    with(global.__scribble_generator_state)
    {
        glyph_count = _glyph_count;
        control_count = _control_count;
    }
}