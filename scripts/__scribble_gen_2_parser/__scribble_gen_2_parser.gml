// Feather disable all
#macro __SCRIBBLE_PARSER_PUSH_SCALE  if (_state_scale != 1)\
                                     {\
                                            ds_grid_multiply_region(_glyph_grid, _state_scale_start_glyph, __SCRIBBLE_GEN_GLYPH.__X, _glyph_count, __SCRIBBLE_GEN_GLYPH.__SCALE, _state_scale);\ //Covers x, y, width, height, and separation
                                     }\
                                     _state_scale_start_glyph = _glyph_count;



#macro __SCRIBBLE_PARSER_NEXT_GLYPH  ++_glyph_count;\
                                     _glyph_prev_prev = _glyph_prev;\
                                     _glyph_prev = _glyph_write;



#macro __SCRIBBLE_PARSER_WRITE_NEWLINE  _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x0A;\ //ASCII line break (dec = 10)
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.ISOLATED;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = 0;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _font_line_height;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _font_line_height;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = 0;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;\
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;\
                                        ;\
                                        ++_glyph_count;\
                                        _glyph_prev_arabic_join_next = false;\
                                        _glyph_prev_prev = _glyph_prev;\
                                        _glyph_prev = 0x0A;



#macro __SCRIBBLE_PARSER_WRITE_GLYPH  ;\//Pull info out of the font's data structures
                                      ;\//We floor this value to work around floating point issues on HTML5
                                      var _data_index = _font_glyphs_map[? floor(_glyph_write)];\
                                      ;\//If our glyph is missing, choose the missing character glyph instead!
                                      if (_data_index == undefined)\
                                      {\
                                          __scribble_trace("Couldn't find glyph data for character code " + string(_glyph_write) + " (" + chr(_glyph_write) + ") in font \"" + string(_font_name) + "\"");\
                                          _data_index = _font_glyphs_map[? ord(SCRIBBLE_MISSING_CHARACTER)];\
                                      }\
                                      if (_data_index == undefined)\
                                      {\
                                          ;\//This should only happen if SCRIBBLE_MISSING_CHARACTER is missing for a font
                                          __scribble_trace("Couldn't find \"missing character\" glyph data, character code " + string(ord(SCRIBBLE_MISSING_CHARACTER)) + " (" + string(SCRIBBLE_MISSING_CHARACTER) + ") in font \"" + string(_font_name) + "\"");\
                                      }\
                                      else\
                                      {\
                                          ;\//Add this glyph to our grid by copying from the font's own glyph data grid
                                          ds_grid_set_grid_region(_glyph_grid, _font_glyph_data_grid, _data_index, SCRIBBLE_GLYPH.UNICODE, _data_index, SCRIBBLE_GLYPH.V1, _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE);\
                                          _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;\
                                          ;\
                                          if (SCRIBBLE_USE_KERNING)\
                                          {\
                                              var _kerning = _font_kerning_map[? ((_glyph_write & 0xFFFF) << 16) | (_glyph_prev & 0xFFFF)];\
                                              if (_kerning != undefined) _glyph_grid[# _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__SEPARATION] += _kerning*_glyph_grid[# _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__SCALE];\
                                          }\
                                          ;\
                                          if (SCRIBBLE_USE_FONT_ALIGNMENT_OFFSETS)\
                                          {\
                                              _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X] += _state_halign_offset;\
                                              _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y] += _state_valign_offset;\
                                          }\
                                          ;\
                                          __SCRIBBLE_PARSER_NEXT_GLYPH\
                                      }



#macro __SCRIBBLE_PARSER_SET_FONT   var _font_data            = __scribble_get_font_data(_font_name);\
                                    if (_font_data.__is_krutidev) __has_devanagari = true;\
                                    ;\
                                    var _font_glyph_data_grid     = _font_data.__glyph_data_grid;\
                                    var _font_glyphs_map          = _font_data.__glyphs_map;\
                                    var _font_kerning_map         = _font_data.__kerning_map;\
                                    var _font_halign_offset_array = _font_data.__halign_offset_array;\
                                    var _font_valign_offset_array = _font_data.__valign_offset_array;\
                                    ;\
                                    var _state_halign_offset = _font_halign_offset_array[_state_halign];\
                                    var _state_valign_offset = _font_valign_offset_array[__valign ?? _starting_valign];\
                                    ;\
                                    var _space_data_index = _font_glyphs_map[? 32];\
                                    if (_space_data_index == undefined)\
                                    {\
                                        __scribble_error("The space character is missing from font definition for \"", _font_name, "\"");\
                                        return false;\
                                    }\
                                    ;\
                                    var _font_space_width = _font_glyph_data_grid[# _space_data_index, SCRIBBLE_GLYPH.SEPARATION ];\
                                    var _font_line_height = _font_glyph_data_grid[# _space_data_index, SCRIBBLE_GLYPH.FONT_HEIGHT];\
                                    _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__FONT;\
                                    _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _font_name;\
                                    ++_control_count;



function __scribble_gen_2_parser()
{
    #region Hashtable to accelerate command tag lookup
    
    static _command_tag_lookup_accelerator_map = undefined;
    if (_command_tag_lookup_accelerator_map == undefined)
    {
        _command_tag_lookup_accelerator_map = ds_map_create();
        _command_tag_lookup_accelerator_map[? ""                  ] =  0;
        _command_tag_lookup_accelerator_map[? "/"                 ] =  0;
        _command_tag_lookup_accelerator_map[? "/font"             ] =  1;
        _command_tag_lookup_accelerator_map[? "/f"                ] =  1;
        _command_tag_lookup_accelerator_map[? "/colour"           ] =  2;
        _command_tag_lookup_accelerator_map[? "/color"            ] =  2;
        _command_tag_lookup_accelerator_map[? "/c"                ] =  2;
        _command_tag_lookup_accelerator_map[? "/alpha"            ] =  3;
        _command_tag_lookup_accelerator_map[? "/a"                ] =  3;
        _command_tag_lookup_accelerator_map[? "/scale"            ] =  4;
        _command_tag_lookup_accelerator_map[? "/s"                ] =  4;
        //5 is unused
        _command_tag_lookup_accelerator_map[? "/page"             ] =  6;
        _command_tag_lookup_accelerator_map[? "scale"             ] =  7;
        _command_tag_lookup_accelerator_map[? "scaleStack"        ] =  8;
        //9 is unused
        _command_tag_lookup_accelerator_map[? "alpha"             ] = 10;
        _command_tag_lookup_accelerator_map[? "fa_left"           ] = 11;
        _command_tag_lookup_accelerator_map[? "fa_center"         ] = 12;
        _command_tag_lookup_accelerator_map[? "fa_centre"         ] = 12;
        _command_tag_lookup_accelerator_map[? "fa_right"          ] = 13;
        _command_tag_lookup_accelerator_map[? "fa_top"            ] = 14;
        _command_tag_lookup_accelerator_map[? "fa_middle"         ] = 15;
        _command_tag_lookup_accelerator_map[? "fa_bottom"         ] = 16;
        _command_tag_lookup_accelerator_map[? "pin_left"          ] = 17;
        _command_tag_lookup_accelerator_map[? "pin_center"        ] = 18;
        _command_tag_lookup_accelerator_map[? "pin_centre"        ] = 18;
        _command_tag_lookup_accelerator_map[? "pin_right"         ] = 19;
        _command_tag_lookup_accelerator_map[? "fa_justify"        ] = 20;
        _command_tag_lookup_accelerator_map[? "nbsp"              ] = 21;
        _command_tag_lookup_accelerator_map[? "&nbsp"             ] = 21;
        _command_tag_lookup_accelerator_map[? "nbsp;"             ] = 21;
        _command_tag_lookup_accelerator_map[? "&nbsp;"            ] = 21;
        _command_tag_lookup_accelerator_map[? "cycle"             ] = 22;
        _command_tag_lookup_accelerator_map[? "/cycle"            ] = 23;
        _command_tag_lookup_accelerator_map[? "r"                 ] = 24;
        _command_tag_lookup_accelerator_map[? "/b"                ] = 24;
        _command_tag_lookup_accelerator_map[? "/i"                ] = 24;
        _command_tag_lookup_accelerator_map[? "/bi"               ] = 24;
        _command_tag_lookup_accelerator_map[? "b"                 ] = 25;
        _command_tag_lookup_accelerator_map[? "i"                 ] = 26;
        _command_tag_lookup_accelerator_map[? "bi"                ] = 27;
        _command_tag_lookup_accelerator_map[? "surface"           ] = 28;
        _command_tag_lookup_accelerator_map[? "region"            ] = 29;
        _command_tag_lookup_accelerator_map[? "/region"           ] = 30;
        _command_tag_lookup_accelerator_map[? "zwsp"              ] = 31;
        _command_tag_lookup_accelerator_map[? "typistSound"       ] = 32;
        _command_tag_lookup_accelerator_map[? "typistSoundPerChar"] = 33;
        _command_tag_lookup_accelerator_map[? "r2l"               ] = 34;
        _command_tag_lookup_accelerator_map[? "l2r"               ] = 35;
        _command_tag_lookup_accelerator_map[? "indent"            ] = 36;
        _command_tag_lookup_accelerator_map[? "/indent"           ] = 37;
        _command_tag_lookup_accelerator_map[? "offset"            ] = 38;
        _command_tag_lookup_accelerator_map[? "offsetPop"         ] = 39;
        _command_tag_lookup_accelerator_map[? "texture"           ] = 40;
    }
    
    #endregion
    
    static _system                = __scribble_initialize();
    static _useHandleParse        = _system.__useHandleParse;
    static _effects_map           = _system.__effects_map;
    static _effects_slash_map     = _system.__effects_slash_map;
    static _typewriter_events_map = _system.__typewriter_events_map;
    static _external_sprite_map   = _system.__external_sprite_map;
    static _external_sound_map    = _system.__external_sound_map;
    static _macros_map            = _system.__macros_map;
    static _string_buffer         = _system.__buffer_a;
    static _other_string_buffer   = _system.__buffer_b;
    static _colors_struct         = __scribble_config_colours();
    static _font_data_map         = _system.__font_data_map;
    static _generator_state       = _system.__generator_state;
    static _sprite_whitelist_map  = _system.__state.__sprite_whitelist_map;
    
    with(_generator_state)
    {
        var _glyph_grid     = __glyph_grid;
        var _word_grid      = __word_grid;
        var _control_grid   = __control_grid; //This grid is cleared at the bottom of __scribble_generate_model()
        var _vbuff_pos_grid = __vbuff_pos_grid;
        var _element        = __element;
    }
    
    static _glyph_data_struct = __scribble_initialize().__glyph_data;
    static _global_glyph_bidi_map = _glyph_data_struct.__bidi_map;
    
    //Arabic look-up tables
    static _arabic_join_next_map = _glyph_data_struct.__arabic_join_next_map;
    static _arabic_join_prev_map = _glyph_data_struct.__arabic_join_prev_map;
    static _arabic_isolated_map  = _glyph_data_struct.__arabic_isolated_map;
    static _arabic_initial_map   = _glyph_data_struct.__arabic_initial_map;
    static _arabic_medial_map    = _glyph_data_struct.__arabic_medial_map;
    static _arabic_final_map     = _glyph_data_struct.__arabic_final_map;
    
    //Thai look-up tables
    static _thai_base_map           = _glyph_data_struct.__thai_base_map;
    static _thai_base_descender_map = _glyph_data_struct.__thai_base_descender_map;
    static _thai_base_ascender_map  = _glyph_data_struct.__thai_base_ascender_map;
    static _thai_top_map            = _glyph_data_struct.__thai_top_map;
    static _thai_lower_map          = _glyph_data_struct.__thai_lower_map;
    static _thai_upper_map          = _glyph_data_struct.__thai_upper_map;
    
    //Cache element properties locally
    var _element_text    = _element.__text;
    var _starting_colour = _element.__starting_colour;
    var _starting_halign = _element.__starting_halign;
    var _starting_valign = _element.__starting_valign;
    var _ignore_commands = _element.__ignore_command_tags;
    var _pre_scale       = _element.__pre_scale;
    
    var _starting_font = _element.__starting_font;
    if (_starting_font == undefined) __scribble_error("The default font has not been set\nCheck that you've added fonts to Scribble (scribble_font_add() / scribble_font_add_from_sprite() etc.)");
    
    var _font_name = _starting_font;
    
    //Run the pre-processor
    _element_text = ((_element.__preprocessorFunc ?? _system.__defaultPreprocessorFunc)(_element_text)) ?? _element_text;
    
    //Place our input string into a buffer for quicker reading
    buffer_seek(_string_buffer, buffer_seek_start, 0);
    buffer_write(_string_buffer, buffer_string, _element_text);
    buffer_write(_string_buffer, buffer_u64, 0x0); //Add some extra null characters to avoid errors where we're reading outside the buffer
    var _buffer_length = buffer_tell(_string_buffer);
    buffer_seek(_string_buffer, buffer_seek_start, 0);
    
    #region Determine the overall bidi direction for the string
    
    //TODO - Is it faster to scan for the overall bidi post-hoc?
    
    var _overall_bidi = _generator_state.__overall_bidi;
    if ((_overall_bidi != __SCRIBBLE_BIDI.L2R) && (_overall_bidi != __SCRIBBLE_BIDI.R2L))
    {
        // Searching until we find a glyph with a well-defined direction
        var _in_tag = false;
        var _state_command_tag_flipflop = false;
        repeat(string_byte_length(_element_text))
        {
            var _glyph_ord = __scribble_buffer_read_unicode(_string_buffer)
            if (_glyph_ord == 0) break;
            
            if (_in_tag)
            {
                if (_glyph_ord == SCRIBBLE_COMMAND_TAG_CLOSE) _in_tag = false;
                continue;
            }
            
            if ((_glyph_ord == SCRIBBLE_COMMAND_TAG_OPEN) && !_ignore_commands)
            {
                if (__scribble_buffer_peek_unicode(_string_buffer, buffer_tell(_string_buffer)) == SCRIBBLE_COMMAND_TAG_OPEN)
                {
                    _state_command_tag_flipflop = true;
                }
                else if (_state_command_tag_flipflop)
                {
                    _state_command_tag_flipflop = false;
                }
                else
                {
                    _in_tag = true;
                    continue;
                }
            }
            
            var _bidi = _global_glyph_bidi_map[? _glyph_ord];
            if (_bidi == undefined) _bidi = __SCRIBBLE_BIDI.L2R;
            
            if (_bidi == __SCRIBBLE_BIDI.L2R)
            {
                _overall_bidi = _bidi;
                break;
            }
            
            //Group R2L and R2L_ARABIC under the same overall bidi direction
            if (_bidi >= __SCRIBBLE_BIDI.R2L)
            {
                _overall_bidi = __SCRIBBLE_BIDI.R2L;
                break;
            }
        }
        
        buffer_seek(_string_buffer, buffer_seek_start, 0);
        
        // We didn't find a glyph with a direction, default to L2R
        if ((_overall_bidi != __SCRIBBLE_BIDI.L2R) && (_overall_bidi != __SCRIBBLE_BIDI.R2L)) _overall_bidi = __SCRIBBLE_BIDI.L2R;
        
        _generator_state.__overall_bidi = _overall_bidi;
    }
    
    #endregion
    
    //Resize grids if we have to
    var _element_expected_text_length = string_length(_element_text) + 2;
    if (ds_grid_width(_glyph_grid    ) < _element_expected_text_length) ds_grid_resize(_glyph_grid,     _element_expected_text_length, __SCRIBBLE_GEN_GLYPH.__SIZE);
    if (ds_grid_width(_word_grid     ) < _element_expected_text_length) ds_grid_resize(_word_grid,      _element_expected_text_length, __SCRIBBLE_GEN_GLYPH.__SIZE);
    if (ds_grid_width(_vbuff_pos_grid) < _element_expected_text_length) ds_grid_resize(_vbuff_pos_grid, _element_expected_text_length, __SCRIBBLE_GEN_GLYPH.__SIZE);
    
    //Start the parser!
    var _tag_start           = undefined;
    var _tag_parameter_count = 0;
    var _tag_parameters      = [];
    var _tag_command_name    = "";
    var _tag_open_count      = 0;
    
    var _glyph_count                 = 0;
    var _glyph_ord                   = 0x0000;
    var _glyph_prev                  = 0x0000;
    var _glyph_prev_prev             = 0x0000;
    var _glyph_prev_arabic_join_next = false;
    
    var _control_count = 0;
    var _skip_write    = false;
    
    var _state_effect_flags         = 0;
    var _state_colour               = 0xFF000000 | _starting_colour; //Uses all four bytes
    var _state_halign               = _starting_halign;
    var _state_command_tag_flipflop = false;
    
    var _state_scale             = _pre_scale;
    var _state_scale_start_glyph = 0;
    
    var _state_halign_offset = 0;
    var _state_valign_offset = 0;
    
    var _offset_data_array = []; // start glyph, dX, dY
    
    _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__HALIGN;
    _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_halign;
    ++_control_count;
    
    _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__COLOUR;
    _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_colour;
    ++_control_count;
    
    __SCRIBBLE_PARSER_SET_FONT;
    
    //Keep going until we hit a null
    while(true)
    {
        // In-lined __scribble_buffer_read_unicode() for speed
        var _glyph_ord  = buffer_read(_string_buffer, buffer_u8); //Assume 0xxxxxxx
        
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
                _tag_open_count--;
                
                if (_tag_open_count <= 0)
                {
                    //Increment the parameter count and place a null byte for string reading
                    ++_tag_parameter_count;
                    buffer_poke(_string_buffer, buffer_tell(_string_buffer)-1, buffer_u8, 0);
                    
                    //Jump back to the start of the command tag and read out strings for the command parameters
                    buffer_seek(_string_buffer, buffer_seek_start, _tag_start);
                    repeat(_tag_parameter_count)
                    {
                        array_push(_tag_parameters, buffer_read(_string_buffer, buffer_string));
                    }
                    
                    //Reset command tag state
                    _tag_start = undefined;
                    
                    _tag_command_name = _tag_parameters[0];
                    var _new_halign = undefined;
                    var _new_valign = undefined;
                    
                    switch(_command_tag_lookup_accelerator_map[? _tag_command_name])
                    {
                        #region Reset formatting
                    
                        // []
                        // [/]
                        case 0:
                            //Resets:
                            //    - colour
                            //    - effect flags (inc. cycle)
                            //    - scale
                            //    - font
                            //But NOT alignment
                        
                            __SCRIBBLE_PARSER_PUSH_SCALE;
                        
                            if (_font_name != _starting_font)
                            {
                                _font_name = _starting_font;
                                __SCRIBBLE_PARSER_SET_FONT;
                            }
                        
                            _state_effect_flags = 0;
                            _state_scale        = _pre_scale;
                            _state_colour       = 0xFF000000 | _starting_colour;
                        
                            //Add an effect flag control
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__EFFECT;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = 0;
                            ++_control_count;
                        
                            //Add a colour control
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__COLOUR;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_colour;
                            ++_control_count;
                        break;
                    
                        // [/font]
                        // [/f]
                        case 1:
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
                            _state_colour = (_state_colour & 0xFF000000) | _starting_colour;
                        
                            //Add a colour control
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__COLOUR;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_colour;
                            ++_control_count;
                        break;
                    
                        // [/alpha]
                        // [/a]
                        case 3:
                            _state_colour = 0xFF000000 | _state_colour;
                        
                            //Add a colour control
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__COLOUR;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_colour;
                            ++_control_count;
                        break;
                    
                        // [/scale]
                        // [/s]
                        case 4:
                            __SCRIBBLE_PARSER_PUSH_SCALE;
                            _state_scale = _pre_scale;
                        break;
                    
                        #endregion
                        
                        // [/page]
                        case 6:
                            //Add a null glyph to our grid
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x00;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.ISOLATED;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _font_line_height;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _font_line_height;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                            
                            ++_glyph_count;
                            _glyph_prev_arabic_join_next = false;
                            _glyph_prev_prev = _glyph_prev;
                            _glyph_prev = 0x00;
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
                                __SCRIBBLE_PARSER_PUSH_SCALE;
                                _state_scale = _pre_scale*real(_tag_parameters[1]);
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
                                __SCRIBBLE_PARSER_PUSH_SCALE;
                                _state_scale *= real(_tag_parameters[1]);
                            }
                        break;
                    
                        #endregion
                    
                        #region Offset
                    
                        // [offset,dX,dY]
                        case 38:
                            var _offset_dx = (_tag_parameter_count > 1)? real(_tag_parameters[1]) : 0;
                            var _offset_dy = (_tag_parameter_count > 2)? real(_tag_parameters[2]) : 0;
                        
                            array_push(_offset_data_array, _glyph_count, _offset_dx, _offset_dy);
                        break;
                    
                        // [offsetPop]
                        case 39:
                            if ((_glyph_count > 0) && (array_length(_offset_data_array) >= 3))
                            {
                                var _offset_dy    = array_pop(_offset_data_array);
                                var _offset_dx    = array_pop(_offset_data_array);
                                var _offset_start = array_pop(_offset_data_array);
                            
                                ds_grid_add_region(_glyph_grid, _offset_start, __SCRIBBLE_GEN_GLYPH.__X, _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__X, _offset_dx);
                                ds_grid_add_region(_glyph_grid, _offset_start, __SCRIBBLE_GEN_GLYPH.__Y, _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__Y, _offset_dy);
                            }
                        break;
                    
                        #endregion
                    
                        // [alpha]
                        case 10:
                            _state_colour = (floor(255*clamp(real(_tag_parameters[1]), 0, 1)) << 24) | (_state_colour & 0x00FFFFFF);
                        
                            //Add a colour control
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__COLOUR;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_colour;
                            ++_control_count;
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
                            _new_halign = __SCRIBBLE_FA_JUSTIFY;
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
                                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0xA0; //Non-breaking space (dec = 160)
                                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.SYMBOL;
                                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
                                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
                                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = _font_space_width;
                                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _font_line_height;
                                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _font_line_height;
                                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = _font_space_width;
                                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                            
                                ++_glyph_count;
                                _glyph_prev_arabic_join_next = false;
                                _glyph_prev_prev = _glyph_prev;
                                _glyph_prev = 0xA0;
                            }
                        break;
                    
                        #endregion
                    
                        #region Zero-width space emulation
                    
                        // [zwsp]
                        case 31:
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x200B;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.WHITESPACE;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _font_line_height;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _font_line_height;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                        
                            ++_glyph_count;
                            _glyph_prev_arabic_join_next = false;
                            _glyph_prev_prev = _glyph_prev;
                            _glyph_prev = 0x200B;
                        break;
                    
                        #endregion
                    
                        // [r2l]
                        case 34:
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x200F;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.R2L;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _font_line_height;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _font_line_height;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                        
                            ++_glyph_count;
                            _glyph_prev_arabic_join_next = false;
                            _glyph_prev_prev = _glyph_prev;
                            _glyph_prev = 0x200F;
                        break;
                    
                        // [l2r]
                        case 35:
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x200E;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.L2R;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _font_line_height;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _font_line_height;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                        
                            ++_glyph_count;
                            _glyph_prev_arabic_join_next = false;
                            _glyph_prev_prev = _glyph_prev;
                            _glyph_prev = 0x200E;
                        break;
                    
                        #region Cycle
                    
                        // [cycle]
                        case 22:
                            var _cycle_r = (_tag_parameter_count > 1)? max(1, real(_tag_parameters[1])) : 0;
                            var _cycle_g = (_tag_parameter_count > 2)? max(1, real(_tag_parameters[2])) : 0;
                            var _cycle_b = (_tag_parameter_count > 3)? max(1, real(_tag_parameters[3])) : 0;
                            var _cycle_a = (_tag_parameter_count > 4)? max(1, real(_tag_parameters[4])) : 0;
                        
                            _state_effect_flags = _state_effect_flags | (1 << _effects_map[? "cycle"]);
                        
                            //Add an effect flag control
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__EFFECT;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_effect_flags;
                            ++_control_count;
                        
                            //Add a cycle control
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__CYCLE;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = (_cycle_a << 24) | (_cycle_b << 16) | (_cycle_g << 8) | _cycle_r;
                            ++_control_count;
                        
                            __has_animation = true;
                        break;
                    
                        // [/cycle]
                        case 23:
                            _state_effect_flags = ~((~_state_effect_flags) | (1 << _effects_slash_map[? "/cycle"]));
                        
                            //Add an effect flag control
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__EFFECT;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_effect_flags;
                            ++_control_count;
                        
                            //Add a cycle control
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__CYCLE;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = undefined;
                            ++_control_count;
                        break;
                            
                        #endregion
                            
                        #region Style shorthands
                    
                        // [r]
                        // [/b]
                        // [/i]
                        // [/bi]
                        case 24:
                            //Get the required font from the font family
                            var _new_font = _font_data.__style_regular;
                            if (_new_font == undefined)
                            {
                                __scribble_trace("Regular style not set for font \"", _font_name, "\"");
                            }
                            else if (!ds_map_exists(_font_data_map, _new_font))
                            {
                                __scribble_trace("Font \"", _font_name, "\" not found (regular style for \"", _font_name, "\")");
                            }
                            else
                            {
                                _font_name = _new_font;
                                __SCRIBBLE_PARSER_SET_FONT;
                                __SCRIBBLE_PARSER_PUSH_SCALE;
                            }
                        break;
                    
                        // [b]
                        case 25:
                            //Get the required font from the font family
                            var _new_font = _font_data.__style_bold;
                            if (_new_font == undefined)
                            {
                                __scribble_trace("Bold style not set for font \"", _font_name, "\"");
                            }
                            else if (!ds_map_exists(_font_data_map, _new_font))
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
                            //Get the required font from the font family
                            var _new_font = _font_data.__style_italic;
                            if (_new_font == undefined)
                            {
                                __scribble_trace("Italic style not set for font \"", _font_name, "\"");
                            }
                            else if (!ds_map_exists(_font_data_map, _new_font))
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
                            //Get the required font from the font family
                            var _new_font = _font_data.__style_bold_italic;
                            if (_new_font == undefined)
                            {
                                __scribble_trace("Bold-Italic style not set for font \"", _font_name, "\"");
                            }
                            else if (!ds_map_exists(_font_data_map, _new_font))
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
                            if (_useHandleParse)
                            {
                                var _surface = handle_parse(_tag_parameters[1]);
                            }
                            else
                            {
                                var _surface = real(_tag_parameters[1]);
                            }
                        
                            var _surface_w = surface_get_width(_surface);
                            var _surface_h = surface_get_height(_surface);
                        
                            if (SCRIBBLE_AUTOFIT_INLINE_SURFACES)
                            {
                                var _scale = min(1, (_font_line_height+2)/_surface_h);
                                _surface_w *= _scale;
                                _surface_h *= _scale;
                            }
                        
                            //Add this glyph to our grid
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = __SCRIBBLE_GLYPH_SURFACE;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.SYMBOL;
                        
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = _state_halign_offset;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = _state_valign_offset;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = _surface_w;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _surface_h;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _surface_h;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = _surface_w;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SCALE        ] = 1;
                        
                            //TODO - Add a way to force a regeneration of every text element that contains a given surface
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__MATERIAL     ] = __scribble_surface_get_material(_surface);
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_U0      ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_V0      ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_U1      ] = 1;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_V1      ] = 1;
                        
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                        
                            ++_glyph_count;
                            _glyph_prev_arabic_join_next = false;
                            _glyph_prev_prev = _glyph_prev;
                            _glyph_prev = __SCRIBBLE_GLYPH_SURFACE;
                        break;
                    
                        #endregion
                    
                        #region Regions
                    
                        // [region,]
                        case 29:
                            if (array_length(_tag_parameters) != 2) __scribble_error("[region] tags must contain a name e.g. [region,This is a region]");
                        
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__REGION;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _tag_parameters[1];
                            ++_control_count;
                        break;
                    
                        // [/region]
                        case 30:
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__REGION;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = undefined;
                            ++_control_count;
                        break;
                    
                        #endregion
                    
                        #region Typist .sound() and .sound_per_char() equivalents
                    
                        case 32:
                            if (array_length(_tag_parameters) != 5)
                            {
                                __scribble_error("[typistSound] tags must use the same number of arguments as .sound()");
                            }
                            else
                            {
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__EVENT;
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = new __scribble_class_event(__SCRIBBLE_TYPIST_SOUND_COMMAND_TAG, _tag_parameters);
                                ++_control_count;
                            }
                        break;
                    
                        case 33:
                            if ((array_length(_tag_parameters) != 4) && (array_length(_tag_parameters) != 5))
                            {
                                __scribble_error("[typistSoundPerChar] tags must use the same number of arguments as .sound_per_char()");
                            }
                            else
                            {
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__EVENT;
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = new __scribble_class_event(__SCRIBBLE_TYPIST_SOUND_PER_CHAR_COMMAND_TAG, _tag_parameters);
                                ++_control_count;
                            }
                        break;
                    
                        #endregion
                    
                        #region Indent
                    
                        case 36: // [indent]
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__INDENT_START;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = undefined;
                            ++_control_count;
                        break;
                    
                        case 37: // [/indent]
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__INDENT_STOP;
                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = undefined;
                            ++_control_count;
                        break;
                    
                        #endregion
                        
                        case 40: // [texture,<index>,<x>,<y>,<w>,<h>]
                            var _tex_index = real(_tag_parameters[1]);
                            var _tex_x     = real(_tag_parameters[2]);
                            var _tex_y     = real(_tag_parameters[3]);
                            var _tex_w     = real(_tag_parameters[4]);
                            var _tex_h     = real(_tag_parameters[5]);
                            
                            var _texture_tw = texture_get_texel_width(_tex_index);
                            var _texture_th = texture_get_texel_height(_tex_index);
                            
                            var _u0 = _tex_x*_texture_tw;
                            var _v0 = _tex_y*_texture_th;
                            var _u1 = (_tex_x+_tex_w)*_texture_tw;
                            var _v1 = (_tex_y+_tex_h)*_texture_th;
                            
                            if (SCRIBBLE_AUTOFIT_INLINE_TEXTURES)
                            {
                                var _scale = min(1, (_font_line_height+2)/_tex_h);
                                _tex_w *= _scale;
                                _tex_h *= _scale;
                            }
                            
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = __SCRIBBLE_GLYPH_TEXTURE;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.SYMBOL;
                            
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = _state_halign_offset;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = _state_valign_offset;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = _tex_w;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _tex_h;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _tex_h;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = _tex_w;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SCALE        ] = 1;
                            
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__MATERIAL     ] = __scribble_texture_get_material(_tex_index);
                            //_glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_U0      ] = 0;
                            //_glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_V0      ] = 0;
                            //_glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_U1      ] = 1;
                            //_glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_V1      ] = 1;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_U0      ] = _u0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_U1      ] = _u1;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_V0      ] = _v0;
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__QUAD_V1      ] = _v1;
                            
                            _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                        
                            ++_glyph_count;
                            _glyph_prev_arabic_join_next = false;
                            _glyph_prev_prev = _glyph_prev;
                            _glyph_prev = __SCRIBBLE_GLYPH_TEXTURE;
                        break;
                        
                        default: //TODO - Optimize
                            if (ds_map_exists(_effects_map, _tag_command_name)) //Set an effect
                            {
                                _state_effect_flags = _state_effect_flags | (1 << _effects_map[? _tag_command_name]);
                            
                                //Add an effect flag control
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__EFFECT;
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_effect_flags;
                                ++_control_count;
                            
                                __has_animation = true;
                            }
                            else if (ds_map_exists(_effects_slash_map, _tag_command_name)) //Check if this is a effect name, but with a forward slash at the front
                            {
                                _state_effect_flags = ~((~_state_effect_flags) | (1 << _effects_slash_map[? _tag_command_name]));
                            
                                //Add an effect flag control
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__EFFECT;
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_effect_flags;
                                ++_control_count;
                            }
                            else if (variable_struct_exists(_colors_struct, _tag_command_name)) //Set a pre-defined colour
                            {
                                _state_colour = (_state_colour & 0xFF000000) | (_colors_struct[$ _tag_command_name] & 0x00FFFFFF);
                            
                                //Add a colour control
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__COLOUR;
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_colour;
                                ++_control_count;
                            }
                            else if (ds_map_exists(_typewriter_events_map, _tag_command_name)) //Events
                            {
                                array_delete(_tag_parameters, 0, 1);
                            
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__EVENT;
                                _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = new __scribble_class_event(_tag_command_name, _tag_parameters);
                                ++_control_count;
                            }
                            else if (ds_map_exists(_macros_map, _tag_command_name)) //Macros
                            {
                                var _function = _macros_map[? _tag_command_name];
                            
                                var _macro_result = "";
                                switch(_tag_parameter_count)
                                {
                                    case 1: _macro_result = _function(); break;
                                    case 2: _macro_result = _function(_tag_parameters[1]); break;
                                    case 3: _macro_result = _function(_tag_parameters[1], _tag_parameters[2]); break;
                                    case 4: _macro_result = _function(_tag_parameters[1], _tag_parameters[2], _tag_parameters[3]); break;
                                    case 5: _macro_result = _function(_tag_parameters[1], _tag_parameters[2], _tag_parameters[3], _tag_parameters[4]); break;
                                    case 6: _macro_result = _function(_tag_parameters[1], _tag_parameters[2], _tag_parameters[3], _tag_parameters[4], _tag_parameters[5]); break;
                                    case 7: _macro_result = _function(_tag_parameters[1], _tag_parameters[2], _tag_parameters[3], _tag_parameters[4], _tag_parameters[5], _tag_parameters[6]); break;
                                    case 8: _macro_result = _function(_tag_parameters[1], _tag_parameters[2], _tag_parameters[3], _tag_parameters[4], _tag_parameters[5], _tag_parameters[6], _tag_parameters[7]); break;
                                    case 9: _macro_result = _function(_tag_parameters[1], _tag_parameters[2], _tag_parameters[3], _tag_parameters[4], _tag_parameters[5], _tag_parameters[6], _tag_parameters[7], _tag_parameters[8]); break;
                                
                                    default:
                                        __scribble_error("Macro argument count ", _tag_parameter_count, " unsupported");
                                    break;
                                }
                            
                                _macro_result = string(_macro_result);
                            
                                //Figure out how much we need to copy and if we need to resize the target buffer
                                var _copy_size = _buffer_length - buffer_tell(_string_buffer);
                            
                                _buffer_length = string_byte_length(_macro_result) + _copy_size;
                                if (_buffer_length > buffer_get_size(_other_string_buffer)) buffer_resize(_other_string_buffer, _buffer_length);
                            
                                //Write the new string to the other buffer, and then copy the remainder of the data in the old buffer
                                buffer_seek(_other_string_buffer, buffer_seek_start, 0);
                                buffer_write(_other_string_buffer, buffer_text, _macro_result);
                                buffer_copy(_string_buffer, buffer_tell(_string_buffer), _copy_size, _other_string_buffer, buffer_tell(_other_string_buffer));
                                buffer_seek(_other_string_buffer, buffer_seek_start, 0);
                            
                                //Swap the two buffers over
                                var _temp = _string_buffer;
                                _string_buffer = _other_string_buffer;
                                _other_string_buffer = _temp;
                            
                            }                        
                            else if (ds_map_exists(_font_data_map, _tag_command_name)) //Change font
                            {
                                _font_name = _tag_command_name;
                                __SCRIBBLE_PARSER_SET_FONT;
                            }
                            else
                            {
                                var _sprite_index = _external_sprite_map[? _tag_command_name] ?? asset_get_index(_tag_command_name); 
                                if (sprite_exists(_sprite_index))
                                {
                                    #region Sprite
                                    
                                    if (sprite_exists(_sprite_index) && ((not SCRIBBLE_USE_SPRITE_WHITELIST) || (_sprite_whitelist_map[? _sprite_index] ?? false)))
                                    {
                                        var _sprite_w = sprite_get_width( _sprite_index);
                                        var _sprite_h = sprite_get_height(_sprite_index);
                                
                                        if (SCRIBBLE_AUTOFIT_INLINE_SPRITES)
                                        {
                                            var _scale = min(1, (_font_line_height+2)/_sprite_h);
                                            _sprite_w *= _scale;
                                            _sprite_h *= _scale;
                                        }
                                
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
                                
                                        //Apply IDE sprite speed
                                        if (!SCRIBBLE_LEGACY_ANIMATION_SPEED) _image_speed *= __scribble_image_speed_get(_sprite_index);
                                
                                        //Only report the model as animated if we're actually able to animate this sprite
                                        if ((_image_speed != 0) && (sprite_get_number(_sprite_index) > 1)) __has_animation = true;
                                
                                        //Add this glyph to our grid
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = __SCRIBBLE_GLYPH_SPRITE;
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.SYMBOL;
                                
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = _state_halign_offset;
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = _state_valign_offset;
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = _sprite_w;
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _sprite_h;
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _sprite_h;
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = _sprite_w;
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SCALE        ] = 1;
                                
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                                
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SPRITE_INDEX ] = _sprite_index;
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__IMAGE_INDEX  ] = _image_index;
                                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__IMAGE_SPEED  ] = _image_speed;
                                
                                        ++_glyph_count;
                                        _glyph_prev_arabic_join_next = false;
                                        _glyph_prev_prev = _glyph_prev;
                                        _glyph_prev = __SCRIBBLE_GLYPH_SPRITE;
                                    }
                            
                                    #endregion
                                }
                                else if (asset_get_type(_tag_command_name) == asset_sound)
                                {
                                    _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__EVENT;
                                    _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = new __scribble_class_event(__SCRIBBLE_AUDIO_COMMAND_TAG, _tag_parameters);
                                    ++_control_count;
                                }
                                else if (ds_map_exists(_external_sound_map, _tag_command_name))
                                {
                                    //External audio added via scribble_external_sound_add()
                                    _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__EVENT;
                                    _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = new __scribble_class_event(__SCRIBBLE_AUDIO_COMMAND_TAG, [_external_sound_map[? _tag_command_name]]);
                                    ++_control_count;
                                }
                                else
                                {
                                    var _first_char = string_copy(_tag_command_name, 1, 1);
                                    if ((string_length(_tag_command_name) <= 7) && ((_first_char == "$") || (_first_char == "#")))
                                    {
                                        #region Hex colour decoding
                                
                                        if (!__SCRIBBLE_ON_WEB)
                                        {
                                            //Crafty trick to quickly convert a hex string into a number
                                            try
                                            {
                                                var _decoded_colour = real("0x" + string_delete(_tag_command_name, 1, 1));
                                                if (!SCRIBBLE_BGR_COLOR_HEX_CODES) _decoded_colour = scribble_rgb_to_bgr(_decoded_colour);
                                            }
                                            catch(_error)
                                            {
                                                __scribble_trace(_error);
                                                __scribble_trace("Error! \"", string_delete(_tag_command_name, 1, 2), "\" could not be converted into a hexcode");
                                                _decoded_colour = _starting_colour;
                                            }
                                        }
                                        else
                                        {
                                            //Boring hex decoder because HTML5 hates the cool trick
                                            var _decoded_colour = 0;
                                    
                                            var _i = 2;
                                            repeat(string_length(_tag_command_name) - 1)
                                            {
                                                _decoded_colour = _decoded_colour << 4;
                                        
                                                switch(ord(string_char_at(_tag_command_name, _i)))
                                                {
                                                    case ord("1"):                _decoded_colour |=  1; break;
                                                    case ord("2"):                _decoded_colour |=  2; break;
                                                    case ord("3"):                _decoded_colour |=  3; break;
                                                    case ord("4"):                _decoded_colour |=  4; break;
                                                    case ord("5"):                _decoded_colour |=  5; break;
                                                    case ord("6"):                _decoded_colour |=  6; break;
                                                    case ord("7"):                _decoded_colour |=  7; break;
                                                    case ord("8"):                _decoded_colour |=  8; break;
                                                    case ord("9"):                _decoded_colour |=  9; break;
                                                    case ord("a"): case ord("A"): _decoded_colour |= 10; break;
                                                    case ord("b"): case ord("B"): _decoded_colour |= 11; break;
                                                    case ord("c"): case ord("C"): _decoded_colour |= 12; break;
                                                    case ord("d"): case ord("D"): _decoded_colour |= 13; break;
                                                    case ord("e"): case ord("E"): _decoded_colour |= 14; break;
                                                    case ord("f"): case ord("F"): _decoded_colour |= 15; break;
                                                }
                                        
                                                ++_i;
                                            }
                                    
                                            if (!SCRIBBLE_BGR_COLOR_HEX_CODES) _decoded_colour = scribble_rgb_to_bgr(_decoded_colour);
                                        }
                                
                                        _state_colour = (_state_colour & 0xFF000000) | (_decoded_colour & 0x00FFFFFF);
                                
                                        //Add a colour control
                                        _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__COLOUR;
                                        _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_colour;
                                        ++_control_count;
                                
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
                                                var _decoded_colour = real(string_delete(_tag_command_name, 1, 2));
                                            }
                                            catch(_error)
                                            {
                                                __scribble_trace(_error);
                                                __scribble_trace("Error! \"", string_delete(_tag_command_name, 1, 2), "\" could not be converted into a decimal");
                                                _decoded_colour = _starting_colour;
                                            }
                                    
                                            _state_colour = (_state_colour & 0xFF000000) | (_decoded_colour & 0x00FFFFFF);
                                    
                                            //Add a colour control
                                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__COLOUR;
                                            _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_colour;
                                            ++_control_count;
                                    
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
                            }
                        break;
                    }
                
                    //If this command set a new horizontal alignment, and this alignment is different to what we had before, store it as a command
                    if ((_new_halign != undefined) && (_new_halign != _state_halign))
                    {
                        _state_halign = _new_halign;
                        _new_halign = undefined;
                        _state_halign_offset = _font_halign_offset_array[_state_halign];
                    
                        _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__TYPE] = __SCRIBBLE_GEN_CONTROL_TYPE.__HALIGN;
                        _control_grid[# _control_count, __SCRIBBLE_GEN_CONTROL.__DATA] = _state_halign;
                        ++_control_count;
                    
                        if (_glyph_count > 0)
                        {
                            //Add a newline character if the previous character wasn't also a newline
                            if ((_glyph_prev != 0x00) && (_glyph_prev != 0x0A))
                            {
                                __SCRIBBLE_PARSER_WRITE_NEWLINE;
                            }
                            else
                            {
                                _glyph_grid[# _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT]++;
                            }
                        }
                    }
                        
                    //Handle vertical alignment changes
                    if (_new_valign != undefined)
                    {
                        if (__valign == undefined)
                        {
                            __valign = _new_valign;
                        }
                        else if (__valign != _new_valign)
                        {
                            __scribble_error("In-line vertical alignment cannot be set more than once");
                        }
                    
                        _new_valign = undefined;
                        _state_valign_offset = _font_valign_offset_array[__valign];
                    }
                }
            }
            else if (_glyph_ord == SCRIBBLE_COMMAND_TAG_ARGUMENT) //If we've hit a command tag argument delimiter character (usually ,)
            {
                if (_tag_open_count == 1)
                {
                    //Increment the parameter count and place a null byte for string reading later
                    ++_tag_parameter_count;
                    buffer_poke(_string_buffer, buffer_tell(_string_buffer)-1, buffer_u8, 0);
                }
            }
            else if (_glyph_ord == SCRIBBLE_COMMAND_TAG_OPEN)
            {
                _tag_open_count++;
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
                    _tag_open_count      = 1;
                    _tag_parameter_count = 0;
                    _tag_parameters      = [];
                }
            }
            else if ((_glyph_ord == 0x0A) //If we've hit a newline (\n)
                 || (SCRIBBLE_HASH_NEWLINE && (_glyph_ord == 0x23))) //If we've hit a hash, and hash newlines are on
            {
                __SCRIBBLE_PARSER_WRITE_NEWLINE;
            }
            else if (_glyph_ord == 0x09) //ASCII horizontal tab
            {
                #region Add a tab glyph to our grid
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x09; //ASCII horizontal tab (dec = 9, obviously)
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.WHITESPACE;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = SCRIBBLE_TAB_WIDTH*_font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = SCRIBBLE_TAB_WIDTH*_font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                
                ++_glyph_count;
                _glyph_prev_arabic_join_next = false;
                _glyph_prev_prev = _glyph_prev;
                _glyph_prev = 0x09;
                
                #endregion
            }
            else if (_glyph_ord == 0x20) //ASCII space
            {
                #region Add a space glyph to our grid
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x20; //ASCII space (dec = 32)
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.WHITESPACE;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = _font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = _font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                
                ++_glyph_count;
                _glyph_prev_arabic_join_next = false;
                _glyph_prev_prev = _glyph_prev;
                _glyph_prev = 0x20;
                
                #endregion
            }
            else if (_glyph_ord == 0xA0)
            {
                #region Add a non-breaking space glyph to our grid
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0xA0; //Non-breaking space (dec = 160)
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.SYMBOL;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = _font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = _font_space_width;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                
                ++_glyph_count;
                _glyph_prev_arabic_join_next = false;
                _glyph_prev_prev = _glyph_prev;
                _glyph_prev = 0xA0;
                
                #endregion
            }
            else if ((_glyph_ord == 0x200B) || (SCRIBBLE_THAI_GRAVE_ACCENTS_ARE_ZWSP && __has_thai && (_glyph_ord == 0x60))) //Zero-width space, or a Thai grave accent
            {
                #region Add a zero-width space glyph to our grid
                
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x200B;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.WHITESPACE;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = _font_line_height;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
                _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                
                ++_glyph_count;
                _glyph_prev_arabic_join_next = false;
                _glyph_prev_prev = _glyph_prev;
                _glyph_prev = 0x200B;
                
                #endregion
            }
            else if (SCRIBBLE_UNDO_UNICODE_SUBSTITUTIONS && (_glyph_ord == 0x2026)) //Replace ellipsis … with three full stops (periods)
            {
                //Figure out how much we need to copy and if we need to resize the target buffer
                var _copy_size = _buffer_length - buffer_tell(_string_buffer);
                
                _buffer_length = 3 + _copy_size;
                if (_buffer_length > buffer_get_size(_other_string_buffer)) buffer_resize(_other_string_buffer, _buffer_length);
                
                //Write the new string to the other buffer, and then copy the remainder of the data in the old buffer
                buffer_seek(_other_string_buffer, buffer_seek_start, 0);
                buffer_write(_other_string_buffer, buffer_text, "...");
                buffer_copy(_string_buffer, buffer_tell(_string_buffer), _copy_size, _other_string_buffer, 3);
                buffer_seek(_other_string_buffer, buffer_seek_start, 0);
                
                //Swap the two buffers over
                var _temp = _string_buffer;
                _string_buffer = _other_string_buffer;
                _other_string_buffer = _temp;
            }
            else if (_glyph_ord > 0x20) //Only write glyphs that aren't system control characters
            {
                if (SCRIBBLE_UNDO_UNICODE_SUBSTITUTIONS)
                { 
                    if ((_glyph_ord == 0x2013)  //En dash –
                    ||  (_glyph_ord == 0x2014)  //Em dash —
                    ||  (_glyph_ord == 0x2015)) //Horizontal bar ―
                    {
                        //Replace with hyphen -
                        _glyph_ord = 0x002D;
                    }
                    else if ((_glyph_ord == 0x2018)  //Start single quote ‘
                         ||  (_glyph_ord == 0x2019)) //End single quote ’
                    {
                        //Replace with single quote '
                        _glyph_ord = 0x0027;
                    }
                    else if ((_glyph_ord == 0x201C)  //Start double quote “
                         ||  (_glyph_ord == 0x201D)  //End double quote ”
                         ||  (_glyph_ord == 0x201E)  //Low double quote „
                         ||  (_glyph_ord == 0x201F)) //High double quote ‟
                    {
                        //Replace with double quote "
                        _glyph_ord = 0x0022;
                    }
                    else if (_glyph_ord == 0x037E) //Greek question mark ;
                    {
                        //Replace with semicolon
                        _glyph_ord = 0x003B;
                    }
                }
                
                #region Add a standard glyph
                
                var _glyph_write  = _glyph_ord;
                var _glyph_joiner = _glyph_ord;
                
                if ((_glyph_write >= 0x0600) && (_glyph_write <= 0x06FF)) // Arabic Unicode block
                {
                    #region Arabic handling
                    
                    __has_arabic = true;
                    
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
                            _glyph_write  = _glyph_replacement;
                            _glyph_joiner = _glyph_replacement;
                            
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
                    if (_glyph_prev_arabic_join_next) // Does the previous glyph allow joining to us?
                    {
                        if (_arabic_join_prev_map[? _glyph_next]) // Does the next glyph allow joining to us?
                        {
                            var _new_glyph = _arabic_medial_map[? _glyph_write];
                        }
                        else
                        {
                            var _new_glyph = _arabic_final_map[? _glyph_write];
                        }
                    }
                    else
                    {
                        if (_arabic_join_prev_map[? _glyph_next]) // Does the next glyph allow joining to us?
                        {
                            var _new_glyph = _arabic_initial_map[? _glyph_write];
                        }
                        else
                        {
                            var _new_glyph = _arabic_isolated_map[? _glyph_write];
                        }
                    }
                    
                    // Update the glyph we're trying to write if we found a replacement
                    if (_new_glyph != undefined) _glyph_write = _new_glyph;
                    
                    // If this glyph isn't tashkil then update the previous glyph state
                    if ((_glyph_ord < 0x064B) || (_glyph_ord > 0x0652))
                    {
                        _glyph_prev_arabic_join_next = _arabic_join_next_map[? _glyph_joiner];
                    }
                    
                    #endregion
                    
                    __SCRIBBLE_PARSER_WRITE_GLYPH
                    
                    //Adjust height of shadda after lam
                    if ((_glyph_prev == 0x0651)
                    &&  ((_glyph_prev_prev == 0x0644)
                      || (_glyph_prev_prev == 0xFEDD)
                      || (_glyph_prev_prev == 0xFEDE)
                      || (_glyph_prev_prev == 0xFEE0)
                      || (_glyph_prev_prev == 0xFEDF)))
                    {
                        _glyph_grid[# _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__Y] -= 0.17*_glyph_grid[# _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT];
                    }
                }
                else
                {
                    //Not an Arabic colour, this glyph definitely doesn't join backwards...
                    _glyph_prev_arabic_join_next = false;
                    
                    if ((_glyph_write >= 0x0900) && (_glyph_write <= 0x097F))
                    {
                        //Devanagari is so complex it gets its own function
                        __has_devanagari = true;
                        
                        //Create a placeholder glyph entry
                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = _glyph_write;
                        _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count;
                        
                        __SCRIBBLE_PARSER_NEXT_GLYPH
                    }
                    else
                    {
                        if ((_glyph_write >= 0x0E00) && (_glyph_write <= 0x0E7F))
                        {
                            #region C90 Thai handling
                        
                            __has_thai = true;
                        
                            if (_thai_top_map[? _glyph_write] && (_glyph_count >= 1))
                            {
                                var _base = _glyph_prev;
                                if (_thai_lower_map[? _base] && (_glyph_count >= 2)) _base = _glyph_prev_prev;
                            
                                if (_thai_base_map[? _base])
                                {
                                    _glyph_next = __scribble_buffer_peek_unicode(_string_buffer, buffer_tell(_string_buffer));
                                
                                    var _followingNikhahit = ((_glyph_next == 0x0e33) || (_glyph_next == 0x0e4d));
                                    if (_thai_base_ascender_map[? _base])
                                    {
                                        if (_followingNikhahit)
                                        {
                                            _glyph_write += 0xf713 - 0x0e48;
                                            __SCRIBBLE_PARSER_WRITE_GLYPH;
                                        
                                            _glyph_write = 0xf711;
                                        
                                            if (_glyph_next == 0x0e33)
                                            {
                                                __SCRIBBLE_PARSER_WRITE_GLYPH;
                                                _glyph_write = 0x0e32;
                                            }
                                        
                                            //Skip over the next glyph
                                            buffer_seek(_string_buffer, buffer_seek_relative, 2);
                                        
                                            //Fall through remaining code
                                            _skip_write = true;
                                        }
                                        else
                                        {
                                            _glyph_write += 0xf705 - 0x0e48;
                                        
                                            if ((_glyph_count >= 2) && _thai_upper_map[? _glyph_prev] && _thai_base_ascender_map[? _glyph_prev])
                                            {
                                                _glyph_write += 0xf713 - 0x0e48;
                                            }
                                        }
                                    }
                                    else if (!_followingNikhahit)
                                    {
                                        _glyph_write += 0xf70a - 0x0e48;
                                    
                                        if ((_glyph_count >= 2) && _thai_upper_map[? _glyph_prev] && _thai_base_ascender_map[? _glyph_prev])
                                        {
                                            _glyph_write += 0xf713 - 0x0e48;
                                        }
                                    }
                                }
                            }
                            else if (_thai_upper_map[? _glyph_write] && (_glyph_count > 0) && _thai_base_ascender_map[? _glyph_prev])
                            {
                                switch(_glyph_write)
                                {
                                    case 0x0e31: _glyph_write = 0xf710; break;
                                    case 0x0e34: _glyph_write = 0xf701; break;
                                    case 0x0e35: _glyph_write = 0xf702; break;
                                    case 0x0e36: _glyph_write = 0xf703; break;
                                    case 0x0e37: _glyph_write = 0xf704; break;
                                    case 0x0e4d: _glyph_write = 0xf711; break;
                                    case 0x0e47: _glyph_write = 0xf712; break;
                                }
                            }
                            else if (_thai_lower_map[? _glyph_write] && (_glyph_count > 0) && _thai_base_descender_map[? _glyph_prev])
                            {
                                _glyph_write += 0xf718 - 0x0e38;
                            }
                            else
                            {
                                _glyph_next = __scribble_buffer_peek_unicode(_string_buffer, buffer_tell(_string_buffer));
                            
                                if ((_glyph_write == 0x0e0d) && _thai_lower_map[? _glyph_next])
                                {
                                    _glyph_write = 0xf70f;
                                }
                                else if ((_glyph_write == 0x0e10) && _thai_lower_map[? _glyph_next])
                                {
                                    _glyph_write = 0xf700;
                                }
                            }
                        
                            #endregion
                        }
                        else if ((_glyph_write >= 0x0590) && (_glyph_write <= 0x05FF))
                        {
                            //Hebrew handling is, mercifully, straight-forward beyond R2L directionality
                            __has_hebrew = true;
                        }
                        
                        //TODO - Ligature transform here
                        
                        __SCRIBBLE_PARSER_WRITE_GLYPH
                    }
                }
                
                if (_glyph_ord == SCRIBBLE_COMMAND_TAG_OPEN) _state_command_tag_flipflop = true;
                
                #endregion
            }
        }
    }
    
    __SCRIBBLE_PARSER_PUSH_SCALE;
    
    //Resolve hanging offsets
    if (_glyph_count > 0)
    {
        while(array_length(_offset_data_array) >= 3)
        {
            var _offset_dy    = array_pop(_offset_data_array);
            var _offset_dx    = array_pop(_offset_data_array);
            var _offset_start = array_pop(_offset_data_array);
            
            ds_grid_add_region(_glyph_grid, _offset_start, __SCRIBBLE_GEN_GLYPH.__X, _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__X, _offset_dx);
            ds_grid_add_region(_glyph_grid, _offset_start, __SCRIBBLE_GEN_GLYPH.__Y, _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__Y, _offset_dy);
        }
    }
    
    if (__has_arabic || __has_hebrew) __has_r2l = true;
    
    //Set our vertical alignment if it hasn't been overrided
    if (__valign == undefined) __valign = _starting_valign;
    
    //Create a null terminator so we correctly handle the last character in the string
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x00; //ASCII line break (dec = 10)
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = _overall_bidi;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__LEFT_OFFSET  ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _control_count; //Make sure we collect controls at the end of a string
    
    with(_generator_state)
    {
        __glyph_count   = _glyph_count+1;
        __control_count = _control_count;
    }
}
