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
    
    //Determine the overall bidi direction for the string
    var _overall_bidi = global.__scribble_generator_state.overall_bidi;
    if ((_overall_bidi != __SCRIBBLE_BIDI.L2R) && (_overall_bidi != __SCRIBBLE_BIDI.R2L))
    {
        var _global_glyph_bidi_map = global.__scribble_glyph_data.bidi_map;
        
        // Searching until we find a glyph with a well-defined direction
        repeat(string_byte_length(_element_text))
        {
            var _glyph_ord = __scribble_buffer_read_unicode(_string_buffer)
            if (_glyph_ord == 0) break;
                
            var _bidi = _global_glyph_bidi_map[? _glyph_ord];
            if ((_bidi == __SCRIBBLE_BIDI.L2R) || (_bidi == __SCRIBBLE_BIDI.R2L))
            {
                _overall_bidi = _bidi;
                break;
            }
        }
        
        buffer_seek(_string_buffer, buffer_seek_start, 0);
        
        // We didn't find a glyph with a direction, default to L2R
        if ((_overall_bidi != __SCRIBBLE_BIDI.L2R) && (_overall_bidi != __SCRIBBLE_BIDI.R2L)) _overall_bidi = __SCRIBBLE_BIDI.L2R;
        
        global.__scribble_generator_state.overall_bidi = _overall_bidi;
    }
    
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
        // In-lined __scribble_buffer_read_unicode() for speed
        var _glyph_ord  = buffer_read(_string_buffer, buffer_u8); //Assume 0xxxxxxx
        var _glyph_bidi_raw = undefined;
        
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
                
                switch(global.__scribble_command_tag_lookup_accelerator[? _tag_command_name])
                {
                    #region Reset formatting
                    
                    // []
                    // [/]
                    case 0:
                        //Resets:
                        //    - colour
                        //    - effect flags (inc. cycle)
                        //    - scale
                        //    - slant
                        //    - font
                        //But NOT alignment
                        
                        __SCRIBBLE_PARSER_POP_COLOUR;
                        __SCRIBBLE_PARSER_POP_EFFECT_FLAGS;
                        __SCRIBBLE_PARSER_POP_FONT_SCALE; //Must be *before* __SCRIBBLE_PARSER_POP_SCALE
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
                    
                    // [/font]
                    // [/f]
                    case 1:
                        __SCRIBBLE_PARSER_POP_FONT_SCALE;
                        
                        if (_font_name != _starting_font)
                        {
                            _font_name = _starting_font;
                            __SCRIBBLE_PARSER_SET_FONT;
                        }
                    break;
                    
                    // [/color]
                    // [/colour]
                    // [/c]
                    case 2:
                        _state_colour = _starting_colour;
                        if (!_state_cycle)
                        {
                            __SCRIBBLE_PARSER_POP_COLOUR;
                            _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                        }
                    break;
                    
                    // [/alpha]
                    // [/a]
                    case 3:
                        _state_alpha_255 = 0xFF;
                        if (!_state_cycle)
                        {
                            __SCRIBBLE_PARSER_POP_COLOUR;
                            _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                        }
                    break;
                    
                    // [/scale]
                    // [/s]
                    case 4:
                        __SCRIBBLE_PARSER_POP_SCALE;
                    break;
                    
                    // [/slant]
                    case 5:
                        __SCRIBBLE_PARSER_POP_SLANT;
                        _state_slant = false;
                    break;
                    
                    #endregion
                    
                    // [/page]
                    case 6:
                        __SCRIBBLE_PARSER_WRITE_PAGEBREAK;
                    break;
                    
                    #region Scale
                    
                    // [scale]
                    case 7:
                        if (_tag_parameter_count <= 1)
                        {
                            __scribble_trace("Not enough parameters for [scale] tag!");
                        }
                        else
                        {
                            __SCRIBBLE_PARSER_POP_SCALE;
                            _state_scale       = real(_tag_parameters[1]);
                            _state_scale_final = _font_scale_dist*_state_scale
                        }
                    break;
                    
                    // [scaleStack]
                    case 8:
                        if (_tag_parameter_count <= 1)
                        {
                            __scribble_trace("Not enough parameters for [scaleStack] tag!");
                        }
                        else
                        {
                            __SCRIBBLE_PARSER_POP_SCALE;
                            _state_scale       *= real(_tag_parameters[1]);
                            _state_scale_final  = _font_scale_dist*_state_scale
                        }
                    break;
                    
                    #endregion
                    
                    // [slant]
                    case 9:
                        __SCRIBBLE_PARSER_POP_SLANT;
                        _state_slant = true;
                    break;
                    
                    // [alpha]
                    case 10:
                        _state_alpha_255 = floor(255*clamp(_tag_parameters[1], 0, 1));
                        if (!_state_cycle)
                        {
                            __SCRIBBLE_PARSER_POP_COLOUR;
                            _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                        }
                    break;
                    
                    #region Font Alignment
                    
                    // [fa_left]
                    case 11:
                        _new_halign = fa_left;
                    break;
                    
                    // [fa_center]
                    // [fa_centre]
                    case 12:
                        _new_halign = fa_center;
                    break;
                    
                    // [fa_right]
                    case 13:
                        _new_halign = fa_right;
                    break;
                            
                    // [fa_top]
                    case 14:
                        _new_valign = fa_top;
                    break;
                         
                    // [fa_middle]   
                    case 15:
                        _new_valign = fa_middle;
                    break;
                        
                    // [fa_bottom]    
                    case 16:
                        _new_valign = fa_bottom;
                    break;
                    
                    // [pin_left]   
                    case 17:
                        _new_halign = __SCRIBBLE_PIN_LEFT;
                    break;
                    
                    // [pin_center]
                    // [pin_centre]
                    case 18:
                        _new_halign = __SCRIBBLE_PIN_CENTRE;
                    break;
                    
                    // [pin_right]
                    case 19:
                        _new_halign = __SCRIBBLE_PIN_RIGHT;
                    break;
                    
                    // [fa_justify]
                    case 20:
                        _new_halign = __SCRIBBLE_JUSTIFY;
                    break;
                            
                    #endregion
                            
                    #region Non-breaking space emulation
                    
                    // [nbsp]
                    // [&nbsp]
                    // [nbsp]
                    // [&nbsp;]
                    case 21:
                        repeat((array_length(_tag_parameters) == 2)? real(_tag_parameters[1]) : 1)
                        {
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 0xA0; //Non-breaking space (dec = 160)
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI      ] = __SCRIBBLE_BIDI.SYMBOL;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X         ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y         ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = _font_space_width;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = _font_space_width;
                            
                            ++_glyph_count;
                            _arabic_glyph_prev = 0xA0; //Non-breaking space (dec = 160)
                        }
                    break;
                    
                    #endregion
                            
                    #region Cycle
                    
                    // [cycle]
                    case 22:
                        __SCRIBBLE_PARSER_POP_COLOUR;
                        
                        var _cycle_r = (_tag_parameter_count > 1)? max(1, real(_tag_parameters[1])) : 0;
                        var _cycle_g = (_tag_parameter_count > 2)? max(1, real(_tag_parameters[2])) : 0;
                        var _cycle_b = (_tag_parameter_count > 3)? max(1, real(_tag_parameters[3])) : 0;
                        var _cycle_a = (_tag_parameter_count > 4)? max(1, real(_tag_parameters[4])) : 0;
                                
                        _state_cycle = true;
                        _state_final_colour = (_cycle_a << 24) | (_cycle_b << 16) | (_cycle_g << 8) | _cycle_r;
                                
                        _state_effect_flags = _state_effect_flags | (1 << global.__scribble_effects[? _tag_command_name]);
                    break;
                    
                    // [/cycle]
                    case 23:
                        __SCRIBBLE_PARSER_POP_COLOUR;
                        
                        _state_cycle = false;
                        _state_final_colour = (_state_alpha_255 << 24) | _state_colour;
                        
                        _state_effect_flags = ~((~_state_effect_flags) | (1 << global.__scribble_effects_slash[? _tag_command_name]));
                    break;
                            
                    #endregion
                            
                    #region Style shorthands
                    
                    // [r]
                    // [/b]
                    // [/i]
                    // [/bi]
                    case 24:
                        __SCRIBBLE_PARSER_POP_FONT_SCALE; 
                        
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
                    
                    // [b]
                    case 25:
                        __SCRIBBLE_PARSER_POP_FONT_SCALE;
                        
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
                    
                    // [i]
                    case 26:
                        __SCRIBBLE_PARSER_POP_FONT_SCALE;
                        
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
                    
                    // [bi]
                    case 27:
                        __SCRIBBLE_PARSER_POP_FONT_SCALE;
                        
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
                    
                    // [surface]
                    case 28:
                        var _surface = real(_tag_parameters[1]);
                        
                        var _surface_w = surface_get_width(_surface);
                        var _surface_h = surface_get_height(_surface);
                        
                        //Add this glyph to our grid
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD         ] = __SCRIBBLE_GLYPH_SURFACE;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI        ] = __SCRIBBLE_BIDI.SYMBOL;
                        
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X           ] = 0;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y           ] = 0;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH       ] = _surface_w;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT      ] = _surface_h;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION  ] = _surface_w;
                        
                        //TODO - Add a way to force a regeneration of every text element that contains a given surface
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.TEXTURE     ] = surface_get_texture(_surface);
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.QUAD_U0     ] = 0;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.QUAD_V0     ] = 0;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.QUAD_U1     ] = 1;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.QUAD_V1     ] = 1;
                        
                        _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.MSDF_PXRANGE] = undefined;
                        
                        ++_glyph_count;
                        _glyph_bidi_raw = __SCRIBBLE_BIDI.SYMBOL;
                        _arabic_glyph_prev = __SCRIBBLE_GLYPH_SURFACE;
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
                            __SCRIBBLE_PARSER_POP_FONT_SCALE;
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
                            
                            //Add this glyph to our grid
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD         ] = __SCRIBBLE_GLYPH_SPRITE;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI        ] = __SCRIBBLE_BIDI.SYMBOL;
                            
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X           ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y           ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH       ] = sprite_get_width(_sprite_index);
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT      ] = sprite_get_height(_sprite_index);
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION  ] = sprite_get_width(_sprite_index);
                        
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.MSDF_PXRANGE] = undefined;
                            
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SPRITE_INDEX] = _sprite_index;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_INDEX ] = _image_index;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.IMAGE_SPEED ] = _image_speed;
                            
                            ++_glyph_count;
                            _glyph_bidi_raw = __SCRIBBLE_BIDI.SYMBOL;
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
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI      ] = __SCRIBBLE_BIDI.LINE_BREAK;
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X         ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y         ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = 0;
                
                ++_glyph_count;
                _glyph_bidi_raw = __SCRIBBLE_BIDI.LINE_BREAK;
                _arabic_glyph_prev = 0x0A;
            }
            else if (_glyph_ord == 0x09) //ASCII horizontal tab
            {
                #region Add a tab glyph to our grid
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD         ] = 0x09; //ASCII horizontal tab (dec = 9, obviously)
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI        ] = __SCRIBBLE_BIDI.WHITESPACE;
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X           ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y           ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH       ] = SCRIBBLE_TAB_WIDTH*_font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT      ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION  ] = SCRIBBLE_TAB_WIDTH*_font_space_width;
                
                ++_glyph_count;
                _glyph_bidi_raw = __SCRIBBLE_BIDI.WHITESPACE;
                _arabic_glyph_prev = 0x09;
                
                #endregion
            }
            else if (_glyph_ord == 0x20) //ASCII space
            {
                #region Add a space glyph to our grid
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD       ] = 0x20; //ASCII space (dec = 32)
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.BIDI      ] = __SCRIBBLE_BIDI.WHITESPACE;
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.X         ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.Y         ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.WIDTH     ] = _font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.HEIGHT    ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_PARSER_GLYPH.SEPARATION] = _font_space_width;
                
                ++_glyph_count;
                _glyph_bidi_raw = __SCRIBBLE_BIDI.WHITESPACE;
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
                var _data_index = _font_glyphs_map[? _glyph_write];
                
                //If our glyph is missing, choose the missing character glyph instead!
                if (_data_index == undefined) _data_index = _font_glyphs_map[? ord(SCRIBBLE_MISSING_CHARACTER)];
                
                if (_data_index == undefined)
                {
                    //This should only happen if SCRIBBLE_MISSING_CHARACTER is missing for a font
                    __scribble_trace("Couldn't find glyph data for character code " + string(_glyph_write) + " (" + chr(_glyph_write) + ") in font \"" + string(_font_name) + "\"");
                }
                else
                {
                    //Add this glyph to our grid by copying from the font's own glyph data grid
                    ds_grid_set_grid_region(_glyph_grid, _font_glyph_data_grid, _data_index, SCRIBBLE_GLYPH.ORD, _data_index, SCRIBBLE_GLYPH.MSDF_PXRANGE, _glyph_count, __SCRIBBLE_PARSER_GLYPH.ORD);
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
        
        ////TODO - Move into a macro
        //if (_glyph_bidi_raw != undefined)
        //{
        //    var _glyph_bidi = _glyph_bidi_raw;
        //    
        //    var _new_word = false;
        //    switch(_glyph_bidi)
        //    {
        //        case __SCRIBBLE_BIDI.WHITESPACE:
        //            if ((_word_bidi == undefined) || (_word_bidi == _overall_bidi))
        //            {
        //                _glyph_bidi = _overall_bidi;
        //            }
        //        
        //            _glyph_prev_whitespace = true;
        //        break;
        //        
        //        case __SCRIBBLE_BIDI.SYMBOL:
        //            // If we find a glyph with a neutral direction and the current word isn't whitespace, inherit the word's direction
        //            if ((_word_bidi != __SCRIBBLE_BIDI.WHITESPACE) && (_word_bidi != undefined))
        //            {
        //                _glyph_bidi = _word_bidi;
        //            }
        //        
        //            // If the current word has a neutral direction, try to inherit the direction of the next L2R or R2L glyph
        //            if ((_glyph_bidi == __SCRIBBLE_BIDI.L2R) || (_glyph_bidi == __SCRIBBLE_BIDI.R2L))
        //            {
        //                // When (if) we find an L2R/R2L glyph then copy that glyph state back into the word itself
        //                _word_bidi = _glyph_bidi;
        //                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI_RAW] = _glyph_bidi;
        //                _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI    ] = _glyph_bidi;
        //            }
        //        break;
        //    
        //        case __SCRIBBLE_BIDI.LINE_BREAK:
        //            _new_word = true;
        //        break;
        //    }
        //    
        //    if ((_glyph_bidi != _word_bidi) || (_i == _glyph_count)) _new_word = true;
        //    if ((_glyph_bidi_raw != __SCRIBBLE_BIDI.WHITESPACE) && _glyph_prev_whitespace)
        //    {
        //        _new_word = true;
        //        _glyph_prev_whitespace = false;
        //    }
        //    
        //    // If the glyph we found is a different direction then create a new word for the glyph
        //    if (_new_word)
        //    {
        //        if (_word_index >= 0)
        //        {
        //            _word_glyph_end = _i-1;
        //        
        //            if (_word_bidi == __SCRIBBLE_BIDI.R2L)
        //            {
        //                ds_grid_add_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.X, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.X, abs(_word_width));
        //                ds_grid_set_region(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX, _word_glyph_start);
        //            }
        //            
        //            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_START]
        //            _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_END  ] = _word_glyph_end;
        //            _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.WIDTH      ] = abs(_word_width);
        //            _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.HEIGHT     ] = ds_grid_get_max(_glyph_grid, _word_glyph_start, __SCRIBBLE_PARSER_GLYPH.HEIGHT, _word_glyph_end, __SCRIBBLE_PARSER_GLYPH.HEIGHT);
        //            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI_RAW   ]
        //            //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI       ]
        //            
        //            if (_i == _glyph_count) break;
        //        }
        //        
        //        _word_index++;
        //        
        //        _word_glyph_start = _i;
        //        _word_bidi        = _glyph_bidi;
        //        _word_width       = 0;
        //        
        //        _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_START] = _word_glyph_start;
        //        //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.GLYPH_END  ]
        //        //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.WIDTH      ]
        //        //_word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.HEIGHT     ]
        //        _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI_RAW   ] = _word_bidi;
        //        _word_grid[# _word_index, __SCRIBBLE_PARSER_WORD.BIDI       ] = _word_bidi;
        //    }
        //    
        //    if (_word_bidi != __SCRIBBLE_BIDI.R2L)
        //    {
        //        _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X] += _word_width;
        //        _word_width += _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.SEPARATION];
        //        _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.ANIMATION_INDEX] = _i;
        //    }
        //    else
        //    {
        //        _word_width -= _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.SEPARATION];
        //        _glyph_grid[# _i, __SCRIBBLE_PARSER_GLYPH.X] += _word_width;
        //    }
        //}
    }
    
    __SCRIBBLE_PARSER_POP_COLOUR;
    __SCRIBBLE_PARSER_POP_EFFECT_FLAGS;
    __SCRIBBLE_PARSER_POP_FONT_SCALE; //Must be *before* __SCRIBBLE_PARSER_POP_SCALE
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