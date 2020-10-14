/// @param element
/// @param modelCacheName

function __scribble_class_model(_element, _model_cache_name) constructor
{
	//Record the start time so we can get a duration later
	if (SCRIBBLE_VERBOSE) var _timer_total = get_timer();
	if (__SCRIBBLE_DEBUG) __scribble_trace("Caching \"" + _model_cache_name + "\"");
    
	//Add this text element to the global cache lookup
	global.__scribble_global_cache_map[? _model_cache_name] = self;
	ds_list_add(global.__scribble_global_cache_list, self);
    
    
    
    last_drawn = current_time;
    cache_name = _model_cache_name;
    flushed    = false;
    
    characters = 0;
    lines      = 0;
    pages      = 0;
    width      = 0;
    height     = 0;
    min_x      = 0;
    max_x      = 0;
    valign     = undefined; //If this is still <undefined> after the main string parsing then we set the valign to fa_top
    
	pages_array      = []; //Stores each page of text
	character_array  = SCRIBBLE_CREATE_CHARACTER_ARRAY? [] : undefined;
    glyph_ltrb_array = undefined;
    
	events_char_array = []; //Stores each event's triggering character
	events_name_array = []; //Stores each event's name
	events_data_array = []; //Stores each event's parameters
    
    
    
    #region Public Methods
    
    draw = function(_x, _y, _element)
    {
        if (flushed) return undefined;
        if (_element == undefined) _element = global.__scribble_default_element;
        
        last_drawn = current_time;
        
        var _page_data = pages_array[_element.__page];
        if (SCRIBBLE_BOX_ALIGN_TO_PAGE)
        {
            var _model_w = _page_data.width;
            var _model_h = _page_data.height;
        }
        else
        {
            var _model_w = width;
            var _model_h = height;
        }
        
        with(_element)
        {
            var _x_offset = -origin_x;
            var _y_offset = -origin_y;
            var _xscale   = xscale;
            var _yscale   = yscale;
            var _angle    = angle;
        }
        
        var _left = _x_offset;
        var _top  = _y_offset;
        if (valign == fa_middle) _top -= _model_h div 2;
        if (valign == fa_bottom) _top -= _model_h div 2;
        
	    //Build a matrix to transform the text...
	    if ((_xscale == 1) && (_yscale == 1) && (_angle  == 0))
	    {
	        var _matrix = matrix_build(_left + _x, _top + _y, 0,   0,0,0,   1,1,1);
	    }
	    else
	    {
	        var _matrix = matrix_build(_left, _top, 0,   0,0,0,   1,1,1);
	            _matrix = matrix_multiply(_matrix, matrix_build(_x, _y, 0,
	                                                            0, 0, _angle,
	                                                            _xscale, _yscale, 1));
	    }
        
	    //...aaaand set the matrix
	    var _old_matrix = matrix_get(matrix_world);
	    _matrix = matrix_multiply(_matrix, _old_matrix);
	    matrix_set(matrix_world, _matrix);
        
        var _tw_method = 0;
        if (_element.tw_do) _tw_method = _element.tw_in? 1 : -1;
        
	    //Set the shader and its uniforms
	    shader_set(__shd_scribble);
	    shader_set_uniform_f(global.__scribble_uniform_time, _element.animation_time);
        
	    shader_set_uniform_f(global.__scribble_uniform_tw_method, _tw_method);
	    shader_set_uniform_f(global.__scribble_uniform_tw_smoothness, _element.tw_smoothness);
	    shader_set_uniform_f_array(global.__scribble_uniform_tw_window_array, _element.tw_do? _element.tw_window_array : global.__scribble_window_array_null);
        
	    shader_set_uniform_f(global.__scribble_uniform_colour_blend, colour_get_red(  _element.blend_colour)/255,
	                                                                 colour_get_green(_element.blend_colour)/255,
	                                                                 colour_get_blue( _element.blend_colour)/255,
	                                                                 _element.blend_alpha);
        
	    shader_set_uniform_f(global.__scribble_uniform_fog, colour_get_red(  _element.fog_colour)/255,
	                                                        colour_get_green(_element.fog_colour)/255,
	                                                        colour_get_blue( _element.fog_colour)/255,
	                                                        _element.fog_alpha);
        
	    shader_set_uniform_f_array(global.__scribble_uniform_data_fields,  _element.animation_array);
        shader_set_uniform_f_array(global.__scribble_uniform_bezier_array, _element.bezier_array);
        
	    //Now iterate over the text element's vertex buffers and submit them
        _page_data.__submit();
        
	    shader_reset();
        
	    //Make sure we reset the world matrix
	    matrix_set(matrix_world, _old_matrix);
    }
    
    flush = function()
    {
        if (flushed) return undefined;
	    if (__SCRIBBLE_DEBUG) __scribble_trace("Clearing \"" + string(cache_name) + "\"");
        
	    //Destroy vertex buffers
	    var _i = 0;
	    repeat(array_length(pages_array))
	    {
	        pages_array[_i].__flush();
	        ++_i;
	    }
        
	    //Remove reference from cache
	    ds_map_delete(global.__scribble_global_cache_map, cache_name);
	    var _index = ds_list_find_index(global.__scribble_global_cache_list, self);
	    if (_index >= 0) ds_list_delete(global.__scribble_global_cache_list, _index);
    
	    //Set as flushed
	    flushed = true;
    }
    
    /// @param page
    get_bbox = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            var _page_data = pages_array[_page];
            return { left:   _page_data.min_x,
                     top:    0,
                     right:  _page_data.max_x,
                     bottom: _page_data.height,
                     width:  _page_data.width,
                     height: _page_data.height };
        }
        else
        {
            return { left:   min_x,
                     top:    0,
                     right:  max_x,
                     bottom: height,
                     width:  width,
                     height: height };
        }
    }
    
    /// @page
    get_width = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            return pages_array(_page).width;
        }
        else
        {
            return width;
        }
    }
    
    /// @page
    get_height = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            return pages_array(_page).height;
        }
        else
        {
            return height;
        }
    }
    
    get_pages = function()
    {
        return pages;
    }
    
    #endregion
    
    #region Private Methods
    
    __new_page = function()
    {
        var _page_data = new __scribble_class_page();
        
    	pages_array[@ pages] = _page_data;
    	pages++;
        
        __scribble_trace("pages = ", pages);
        
        return _page_data;
    }
    
    __new_event = function(_character, _event_name, _data)
    {
        var _count = array_length(events_char_array);
        events_char_array[@ _count] = _character;
        events_name_array[@ _count] = _event_name;
        events_data_array[@ _count] = _data;
    }
    
    #endregion
    
    
    
    #region Process input parameters

	var _max_width         = _element.max_width;
	var _max_height        = _element.max_height;
	var _line_min_height   = _element.line_height_min;
	var _line_max_height   = _element.line_height_max;
	var _line_fixed_height = false;
	var _def_colour        = __scribble_process_colour(_element.starting_colour);
	var _def_font          = _element.starting_font;
	var _def_halign        = _element.starting_halign;
    var _character_wrap    = _element.character_wrap;
    var _freeze            = _element.freeze;
    var _ignore_commands   = _element.__ignore_command_tags;
       
	var _font_data         = __scribble_get_font_data(_def_font);
	var _font_glyphs_map   = _font_data.glyphs_map;
	var _font_glyphs_array = _font_data.glyphs_array;
	var _font_glyphs_min   = _font_data.glyph_min;
	var _font_glyphs_max   = _font_data.glyph_max;
        
	var _glyph_texture = undefined;
	var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
	if (_glyph_array == undefined)
	{
	    show_error("Scribble:\nThe space character is missing from font definition for \"" + _def_font + "\"\n ", true);
	    return undefined;
	}
        
	var _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
	var _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
        
	if (_line_min_height < 0) _line_min_height = 0;
        
	if ((_line_max_height >= 0) && (_line_max_height <= _line_min_height))
	{
	    _line_fixed_height = true;
	    var _half_fixed_height = _line_min_height div 2;
	}
    
    var _parameters = [];
    
    #endregion
    
    #region Build Bezier curve segment lengths
            
    //Make a copy of the Bezier array
    var _bezier_array = array_create(6);
    array_copy(_bezier_array, 0, _element.bezier_array, 0, 6);
    
    var _bezier_do = ((_bezier_array[0] != _bezier_array[4]) || (_bezier_array[1] != _bezier_array[5]));
    if (_bezier_do)
    {
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
                
        var _bezier_inc = 1 / (SCRIBBLE_BEZIER_ACCURACY-1);
        var _t = _bezier_inc;
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
                    
            _t += _bezier_inc;
            ++_i;
        }
                
        if (_max_width >= 0) __scribble_trace("Warning! Maximum width set by scribble_set_wrap() (" + string(_max_width) + ") has been replaced with Bezier curve length (" + string(_dist) + "). Use -1 as the maximum width to turn off this warning");
        _max_width = _dist;
    }
                
    #endregion
    
    #region Add the first page to the text element
    
	var _word_start_char = 0;
    var _word_height     = 0;
    
    var _page_data         = __new_page();
	var _page_lines_array  = _page_data.lines_array;         //Stores each line of text (per page)
	var _page_vbuffs_array = _page_data.vertex_buffer_array; //Stores all the vertex buffers needed to render the text and sprites (per page)
    
    #endregion
    
    #region Add the first line to the page
    
	var _line_has_space = false;
	var _line_width     = 0;
	var _line_height    = _line_min_height;
    
    var _line_data    = _page_data.__new_line();
    _line_data.width  = _line_width;
    _line_data.height = _line_height;
    _line_data.halign = _def_halign;
    
    #endregion
    
    #region Set the initial parser state
        
	var _text_x            = 0;
	var _text_y            = _line_fixed_height? _half_fixed_height : 0; //Use a y-offset if we've got a fixed line height
	var _line_y            = 0;
	var _text_font         = _def_font;
	var _text_colour       = _def_colour;
	var _text_halign       = _def_halign;
	var _text_effect_flags = 0;
	var _text_scale        = 1;
	var _text_slant        = false;
    var _text_cycle        = false;
    var _text_cycle_colour = 0x00000000;
            
    var _new_halign = undefined;
    var _new_valign = undefined;
            
    #endregion
    
    #region Parse the string
        
	var _command_tag_start      = -1;
	var _command_tag_parameters =  0;
	var _command_name           = "";
	var _force_newline          =  false;
	var _force_newpage          =  false;
	var _char_width             =  0;
	var _add_character          =  true;

	//Write the string into a buffer for faster reading
	var _string_buffer = global.__scribble_buffer;
	buffer_seek(_string_buffer, buffer_seek_start, 0);
	buffer_write(_string_buffer, buffer_string, _element.text);
	buffer_seek(_string_buffer, buffer_seek_start, 0);

	//Iterate over the entire string...
	repeat(string_byte_length(_element.text) + 1)
	{
	    var _character_code = buffer_read(_string_buffer, buffer_u8);
	    if (_character_code == 0) break;
	    _add_character = true;
                
        if (SCRIBBLE_FIX_ESCAPED_NEWLINES)
        {
            if ((_character_code == 92) && (buffer_peek(_string_buffer, buffer_tell(_string_buffer), buffer_u8) == 110)) //Backslash followed by "n"
            {
                buffer_seek(_string_buffer, buffer_seek_relative, 1);
                _character_code = 10;
            }
        }
                
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
	            repeat(_command_tag_parameters) _parameters[@ array_length(_parameters)] = buffer_read(_string_buffer, buffer_string);
                        
	            //Reset command tag state
	            _command_tag_start = -1;
                        
                #region Command tag handling
                        
	            _command_name = _parameters[0];
	            switch(_command_name)
	            {
                    #region Reset formatting
	                case "":
	                case "/":
	                    _text_font         = _def_font;
	                    _text_colour       = _def_colour;
	                    _text_effect_flags = 0;
	                    _text_scale        = 1;
	                    _text_slant        = false;
                                
	                    _font_data         = __scribble_get_font_data(_text_font);
                    	_font_glyphs_map   = _font_data.glyphs_map;
                    	_font_glyphs_array = _font_data.glyphs_array;
                    	_font_glyphs_min   = _font_data.glyph_min;
                    	_font_glyphs_max   = _font_data.glyph_max;
                                
	                    var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
	                    _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
	                    _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
                                
	                    continue; //Skip the rest of the parser step
	                break;
                            
	                case "/font":
	                case "/f":
	                    _text_font = _def_font;
                                
	                    _font_data         = __scribble_get_font_data(_text_font);
                    	_font_glyphs_map   = _font_data.glyphs_map;
                    	_font_glyphs_array = _font_data.glyphs_array;
                    	_font_glyphs_min   = _font_data.glyph_min;
                    	_font_glyphs_max   = _font_data.glyph_max;
                                
	                    var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
	                    _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
	                    _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
                                
	                    continue; //Skip the rest of the parser step
	                break;
                            
	                case "/colour":
	                case "/color":
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
                                
	                    _line_width = max(_line_width, _text_x);
	                    if (!_line_fixed_height) _line_height = max(_line_height, _font_line_height*_text_scale); //Change our line height if it's not fixed
                        //Note that forcing a newline will reset the word height to 0
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
	                        var _text_scale = real(_parameters[1]);
	                    }
                                
	                    continue; //Skip the rest of the parser step
	                break;
                            
	                case "scaleStack":
	                    if (_command_tag_parameters <= 1)
	                    {
	                        show_error("Scribble:\nNot enough parameters for scaleStack tag!", false);
	                    }
	                    else
	                    {
	                        _text_scale *= real(_parameters[1]);
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
	                    show_error("Scribble:\n[js_*] tags have been deprecated. Please use [pin_*]\n ", false);
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
                        //Grab this characer's width/height
                        _char_width = _font_space_width*_text_scale;
                        _line_width = max(_line_width, _text_x);
                        if (!_line_fixed_height) _line_height = max(_line_height, _font_line_height*_text_scale); //Change our line height if it's not fixed
                        _word_height = max(_word_height, _font_line_height*_text_scale); //Update the word height
                                
                        if (SCRIBBLE_CREATE_CHARACTER_ARRAY) character_array[@ characters] = 32; //Space
                        ++characters;
                                
                        if (global.__scribble_character_delay)
                        {
                            var _delay = global.__scribble_character_delay_map[? 32]; //Use delay for a space
                            if ((_delay != undefined) && (_delay > 0)) __new_event(characters, "delay", [_delay]);
                        }
                                
                        _add_character = false;
                    break;
                            
                    #endregion
                            
                    #region Cycle
                            
                    case "cycle":
                        var _cycle_r = (_command_tag_parameters > 1)? max(1, real(_parameters[1])) : 0;
                        var _cycle_g = (_command_tag_parameters > 2)? max(1, real(_parameters[2])) : 0;
                        var _cycle_b = (_command_tag_parameters > 3)? max(1, real(_parameters[3])) : 0;
                        var _cycle_a = (_command_tag_parameters > 4)? max(1, real(_parameters[4])) : 0;
                                
                        _text_cycle = true;
                        _text_cycle_colour = (_cycle_a << 24) | (_cycle_b << 16) | (_cycle_g << 8) | _cycle_r;
                                
                        _text_effect_flags = _text_effect_flags | (1 << global.__scribble_effects[? _command_name]);
                                
                        continue;
                    break;
                            
                    case "/cycle":
                        _text_cycle = false;
                        _text_effect_flags = ~((~_text_effect_flags) | (1 << global.__scribble_effects_slash[? _command_name]));
                            
                        continue;
                    break;
                            
                    #endregion
                            
                    #region Style shorthands
                            
                    case "r":
                    case "/b":
                    case "/i":
                    case "/bi":
                        //Get the required font from the font family
                        var _family_name = _font_data.family_name;
                        if (_family_name == undefined)
                        {
                            __scribble_trace("Font family not found for font \"" + string(_text_font) + " (check it's not a spritefont or a procedurally generated font)");
                        }
                        else
                        {
                            var _family_map = global.__scribble_font_family_map[? _family_name];
                            var _new_font = _family_map[? "Regular"];
                                    
                            //Check to see if this font even exists
                            if ((_new_font == undefined) || !ds_map_exists(global.__scribble_font_data, _new_font))
                            {
                                __scribble_trace("\"Regular\" style not found for font family \"" + string(_family_name) + "\"");
                            }
                            else
                            {
                                //If the font we found exists, set it
                                _text_font = _new_font;
                                        
                                _font_data         = __scribble_get_font_data(_new_font);
                            	_font_glyphs_map   = _font_data.glyphs_map;
                            	_font_glyphs_array = _font_data.glyphs_array;
                            	_font_glyphs_min   = _font_data.glyph_min;
                            	_font_glyphs_max   = _font_data.glyph_max;
                                        
                                var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
                                _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
                                _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
                            }
                        }
                                
                        continue; //Skip the rest of the parser step
                    break;
                            
                    case "b":
                        //Get the required font from the font family
                        var _family_name = _font_data.family_name;
                        if (_family_name == undefined)
                        {
                            __scribble_trace("Font family not found for font \"" + string(_text_font) + " (check it's not a spritefont or a procedurally generated font)");
                        }
                        else
                        {
                            var _family_map = global.__scribble_font_family_map[? _family_name];
                            var _new_font = _family_map[? "Bold"];
                                    
                            //Check to see if this font even exists
                            if ((_new_font == undefined) || !ds_map_exists(global.__scribble_font_data, _new_font))
                            {
                                __scribble_trace("\"Bold\" style not found for font family \"" + string(_family_name) + "\"");
                            }
                            else
                            {
                                //If the font we found exists, set it
                                _text_font = _new_font;
                                        
                                _font_data         = __scribble_get_font_data(_new_font);
                            	_font_glyphs_map   = _font_data.glyphs_map;
                            	_font_glyphs_array = _font_data.glyphs_array;
                            	_font_glyphs_min   = _font_data.glyph_min;
                            	_font_glyphs_max   = _font_data.glyph_max;
                                        
                                var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
                                _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
                                _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
                            }
                        }
                                
                        continue; //Skip the rest of the parser step
                    break;
                            
                    case "i":
                        //Get the required font from the font family
                        var _family_name = _font_data.family_name;
                        if (_family_name == undefined)
                        {
                            __scribble_trace("Font family not found for font \"" + string(_text_font) + " (check it's not a spritefont or a procedurally generated font)");
                        }
                        else
                        {
                            var _family_map = global.__scribble_font_family_map[? _family_name];
                            var _new_font = _family_map[? "Italic"];
                                    
                            //Check to see if this font even exists
                            if ((_new_font == undefined) || !ds_map_exists(global.__scribble_font_data, _new_font))
                            {
                                __scribble_trace("\"Italic\" style not found for font family \"" + string(_family_name) + "\"");
                            }
                            else
                            {
                                //If the font we found exists, set it
                                _text_font = _new_font;
                                        
                                _font_data         = __scribble_get_font_data(_new_font);
                            	_font_glyphs_map   = _font_data.glyphs_map;
                            	_font_glyphs_array = _font_data.glyphs_array;
                            	_font_glyphs_min   = _font_data.glyph_min;
                            	_font_glyphs_max   = _font_data.glyph_max;
                                        
                                var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
                                _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
                                _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
                            }
                        }
                                
                        continue; //Skip the rest of the parser step
                    break;
                            
                    case "bi":
                        //Get the required font from the font family
                        var _family_name = _font_data.family_name;
                        if (_family_name == undefined)
                        {
                            __scribble_trace("Font family not found for font \"" + string(_text_font) + " (check it's not a spritefont or a procedurally generated font)");
                        }
                        else
                        {
                            var _family_map = global.__scribble_font_family_map[? _family_name];
                            var _new_font = _family_map[? "Bold Italic"];
                                    
                            //Check to see if this font even exists
                            if ((_new_font == undefined) || !ds_map_exists(global.__scribble_font_data, _new_font))
                            {
                                __scribble_trace("\"Bold Italic\" style not found for font family \"" + string(_family_name) + "\"");
                            }
                            else
                            {
                                //If the font we found exists, set it
                                _text_font = _new_font;
                                        
                                _font_data         = __scribble_get_font_data(_new_font);
                            	_font_glyphs_map   = _font_data.glyphs_map;
                            	_font_glyphs_array = _font_data.glyphs_array;
                            	_font_glyphs_min   = _font_data.glyph_min;
                            	_font_glyphs_max   = _font_data.glyph_max;
                                        
                                var _glyph_array = (_font_glyphs_array == undefined)? _font_glyphs_map[? 32] : _font_glyphs_array[32 - _font_glyphs_min];
                                _font_space_width = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
                                _font_line_height = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
                            }
                        }
                                
                        continue; //Skip the rest of the parser step
                    break;
                            
                    #endregion
                            
                    case "surface":
                        #region Write surfaces
                                
                        var _surface = real(_parameters[1]);
                                
	                    _line_width = max(_line_width, _text_x);
                                
                        var _surface_width  = _text_scale*surface_get_width( _surface);
                        var _surface_height = _text_scale*surface_get_height(_surface);
                                
	                    var _surface_x = _text_x;
	                    var _surface_y = _text_y - (_surface_height div 2);
                                                        
	                    var _packed_indexes = characters*__SCRIBBLE_MAX_LINES + _page_data.lines; //TODO - Optimise
	                    _char_width  = _surface_width;
	                    if (!_line_fixed_height) _line_height = max(_line_height, _sprite_height); //Change our line height if it's not fixed
                        _word_height = max(_word_height, _sprite_height); //Update the word height
                                 
                        if (SCRIBBLE_COLORIZE_SPRITES)
                        {
                            var _colour = _text_cycle? _text_cycle_colour : ($FF000000 | _text_colour);
                            var _reset_rainbow = false;
                            var _reset_cycle = false;
                        }
                        else
                        {
                            var _colour = $FFFFFFFF;
                                    
                            //Switch off rainbow
                            var _reset_rainbow = ((_text_effect_flags & (1 << global.__scribble_effects[? "rainbow"])) > 0);
                            _text_effect_flags = ~((~_text_effect_flags) | (1 << global.__scribble_effects[? "rainbow"]));
                                    
                            //Switch off colour cycling
                            var _reset_cycle = ((_text_effect_flags & (1 << global.__scribble_effects[? "cycle"])) > 0);
                            _text_effect_flags = ~((~_text_effect_flags) | (1 << global.__scribble_effects[? "cycle"]));
                        }
                                
                        #region Pre-create vertex buffer arrays for this surface and update WORD_START_TELL at the same time
                                
	                    var _surface_texture = surface_get_texture(_surface);
                        
                        var _vbuff_data            = _page_data.__find_vertex_buffer(_surface_texture);
	                    var _buffer                = _vbuff_data.buffer;
	                    var _vbuff_line_start_list = _vbuff_data.line_start_list;
                                
	                    //Fill line break list
	                    var _tell = buffer_tell(_buffer);
	                    repeat(array_length(_page_lines_array) - ds_list_size(_vbuff_line_start_list)) ds_list_add(_vbuff_line_start_list, _tell);
                        
                        //Update CHAR_START_TELL, and WORD_START_TELL if needed
                        _vbuff_data.char_start_tell = buffer_tell(_buffer);
                        if (_character_wrap)
                        {
                            _vbuff_data.word_start_tell = buffer_tell(_buffer);
                            _vbuff_data.word_x_offset   = undefined;
                            _line_width = max(_line_width, _text_x);
                            
                            //Record the first character in this word
                            _word_start_char = characters;
                        }
                                
                        #endregion
                                            
                        #region Add surface to buffers
                                
	                    //Swap texture and buffer if needed
	                    if (_surface_texture != _glyph_texture)
	                    {
	                        _glyph_texture = _surface_texture;
	                        var _glyph_buffer = _vbuff_data.buffer;
	                    }
                                
	                    //Find the UVs and position of the sprite quad
	                    var _quad_l = _surface_x;
	                    var _quad_t = _surface_y;
	                    var _quad_r = _quad_l + _sprite_width;
	                    var _quad_b = _quad_t + _sprite_height;
                                
	                    var _slant_offset = SCRIBBLE_SLANT_AMOUNT*_text_scale*_text_slant*(_quad_b - _quad_t);
                                
	                    var _quad_cx = 0.5*(_quad_l + _quad_r);
	                    var _quad_cy = 0.5*(_quad_t + _quad_b);
                                
                        var _delta_l  = _quad_cx - _quad_l;
                        var _delta_t  = _quad_cy - _quad_t;
                        var _delta_r  = _quad_cx - _quad_r;
                        var _delta_b  = _quad_cy - _quad_b;
                        var _delta_ls = _delta_l - _slant_offset;
                        var _delta_rs = _delta_r - _slant_offset;
                                
                        //Pack the glyph centre. This assumes our glyph is maximum 200px wide and gives us 1 decimal place
                        //This must match what's in __shd_scribble!
                        var _packed_delta_lb  = floor(1000 + 10*_delta_l ) + 2000*floor(1000 + 10*_delta_b);
                        var _packed_delta_rb  = floor(1000 + 10*_delta_r ) + 2000*floor(1000 + 10*_delta_b);
                        var _packed_delta_lst = floor(1000 + 10*_delta_ls) + 2000*floor(1000 + 10*_delta_t);
                        var _packed_delta_rst = floor(1000 + 10*_delta_rs) + 2000*floor(1000 + 10*_delta_t);
                                
                        //                                                X                                                          Y                                            Character/Line Index                                               Centre dXdY                               Sprite Data (unused for surfaces)                               Flags                                                      Colour                                              U                                           V
                        buffer_write(_glyph_buffer, buffer_f32, _quad_l + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_lst); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, 0);
                        buffer_write(_glyph_buffer, buffer_f32, _quad_r                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_rb ); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, 1); buffer_write(_glyph_buffer, buffer_f32, 1);
                        buffer_write(_glyph_buffer, buffer_f32, _quad_l                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_lb ); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, 1);
                        buffer_write(_glyph_buffer, buffer_f32, _quad_r                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_rb ); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, 1); buffer_write(_glyph_buffer, buffer_f32, 1);
                        buffer_write(_glyph_buffer, buffer_f32, _quad_l + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_lst); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, 0);
                        buffer_write(_glyph_buffer, buffer_f32, _quad_r + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_rst); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, 1); buffer_write(_glyph_buffer, buffer_f32, 0);
                                
                        #endregion
                                
                        if (_reset_rainbow) _text_effect_flags |= (1 << global.__scribble_effects[? "rainbow"]);
                        if (_reset_cycle  ) _text_effect_flags |= (1 << global.__scribble_effects[? "cycle"  ]);
                                                        
	                    if (SCRIBBLE_CREATE_CHARACTER_ARRAY) character_array[@ characters] = _command_name;
	                    ++characters;
                                
                        #endregion
                    break;
                            
	                default:
	                    if (ds_map_exists(global.__scribble_typewriter_events, _command_name))
	                    {
                            #region Custom Events
                                
	                        var _data = array_create(_command_tag_parameters-1);
	                        var _j = 1;
	                        repeat(_command_tag_parameters-1)
	                        {
	                            _data[@ _j-1] = _parameters[_j];
	                            ++_j;
	                        }
                            
                            __new_event(characters, _command_name, _data);
                                
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
                                            
	                                    _font_data         = __scribble_get_font_data(_command_name);
                                    	_font_glyphs_map   = _font_data.glyphs_map;
                                    	_font_glyphs_array = _font_data.glyphs_array;
                                    	_font_glyphs_min   = _font_data.glyph_min;
                                    	_font_glyphs_max   = _font_data.glyph_max;
                                            
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
                                                    
	        	                            var _sprite_index = asset_get_index(_command_name);
	                                        var _sprite_width  = _text_scale*sprite_get_width(_sprite_index);
	                                        var _sprite_height = _text_scale*sprite_get_height(_sprite_index);
	                                        var _sprite_number = sprite_get_number(_sprite_index);
                                                    
	                                        if (SCRIBBLE_ADD_SPRITE_ORIGINS)
	                                        {
	                                            var _sprite_x = _text_x - _text_scale*sprite_get_xoffset(_sprite_index) + (_sprite_width div 2);
	                                            var _sprite_y = _text_y - _text_scale*sprite_get_yoffset(_sprite_index);
	                                        }
	                                        else
	                                        {
	                                            var _sprite_x = _text_x;
	                                            var _sprite_y = _text_y - (_sprite_height div 2);
	                                        }
                                                    
	                                        var _packed_indexes = characters*__SCRIBBLE_MAX_LINES + _page_data.lines; //TODO - Optimise
	                                        _char_width  = _sprite_width;
	                                        if (!_line_fixed_height) _line_height = max(_line_height, _sprite_height); //Change our line height if it's not fixed
                                            _word_height = max(_word_height, _sprite_height); //Update the word height
                                                    
                                            if (_sprite_number >= 64)
                                            {
                                                __scribble_trace("In-line sprites cannot have more than 64 frames (" + string(_command_name) + ")");
                                                _sprite_number = 64;
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
	                                                _image_index = real(_parameters[1]);
	                                                _image_speed = 0;
	                                            break;
                                                            
	                                            default:
	                                                _image_index = real(_parameters[1]);
	                                                _image_speed = real(_parameters[2]);
	                                            break;
	                                        }
                                                        
                                            if (_image_speed >= 4)
                                            {
                                                __scribble_trace("Image speed cannot be more than 4.0 (" + string(_image_speed) + ")");
                                                _image_speed = 4;
                                            }
                                                        
                                            if (SCRIBBLE_COLORIZE_SPRITES)
                                            {
                                                var _colour = _text_cycle? _text_cycle_colour : ($FF000000 | _text_colour);
                                                var _reset_rainbow = false;
                                                var _reset_cycle = false;
                                            }
                                            else
                                            {
                                                var _colour = $FFFFFFFF;
                                                            
                                                //Switch off rainbow
                                                var _reset_rainbow = ((_text_effect_flags & (1 << global.__scribble_effects[? "rainbow"])) > 0);
                                                _text_effect_flags = ~((~_text_effect_flags) | (1 << global.__scribble_effects[? "rainbow"]));
                                                            
                                                //Switch off colour cycling
                                                var _reset_cycle = ((_text_effect_flags & (1 << global.__scribble_effects[? "cycle"])) > 0);
                                                _text_effect_flags = ~((~_text_effect_flags) | (1 << global.__scribble_effects[? "cycle"]));
                                            }
                                                        
	                                        if (_image_speed <= 0)
	                                        {
	                                            _image_speed = 0;
	                                            _sprite_number = 1;
	                                        }
	                                        else
	                                        {
	                                            //Set the "is sprite" effect flag only if we're animating the sprite
	                                            _text_effect_flags = _text_effect_flags | 1;
	                                        }
                                                
                                            #endregion
                                                    
                                            #region Pre-create vertex buffer arrays for images for this sprite and update WORD_START_TELL at the same time
                                                
	                                        var _image = (_image_speed <= 0)? _image_index : 0;
	                                        repeat(_sprite_number)
	                                        {
	                                            var _sprite_texture = sprite_get_texture(_sprite_index, _image);
                                                
                                                var _vbuff_data            = _page_data.__find_vertex_buffer(_sprite_texture, false);
                        	                    var _buffer                = _vbuff_data.buffer;
                        	                    var _vbuff_line_start_list = _vbuff_data.line_start_list;
                                                
	                                            //Fill line break list
	                                            var _tell = buffer_tell(_buffer);
	                                            repeat(array_length(_page_lines_array) - ds_list_size(_vbuff_line_start_list)) ds_list_add(_vbuff_line_start_list, _tell);
                                                
                                                //Update CHAR_START_TELL, and WORD_START_TELL if needed
                                                _vbuff_data.char_start_tell = buffer_tell(_buffer);
                                                if (_character_wrap)
                                                {
                                                    _vbuff_data.word_start_tell = buffer_tell(_buffer);
                                                    _vbuff_data.word_x_offset   = undefined;
                                                    _line_width = max(_line_width, _text_x);
                                                    
                                                    //Record the first character in this word
                                                    _word_start_char = characters;
                                                }
                                                
	                                            _image++;
	                                        }
                                                
                                            #endregion
                                                    
                                            #region Add sprite to buffers
                                                
	                                        var _image = _image_index;
                                            var _image_count = 0;
	                                        repeat(_sprite_number)
	                                        {
	                                            //Swap texture and buffer if needed
	                                            var _sprite_texture = sprite_get_texture(_sprite_index, _image);
	                                            if (_sprite_texture != _glyph_texture)
	                                            {
	                                                _glyph_texture = _sprite_texture;
                                                    _vbuff_data = _page_data.__find_vertex_buffer(_sprite_texture, false);
                                                    var _glyph_buffer = _vbuff_data.buffer;
	                                            }
                                                            
	                                            //Find the UVs and position of the sprite quad
	                                            var _uvs = sprite_get_uvs(_sprite_index, _image);
	                                            var _quad_l = _sprite_x + _uvs[4]*_text_scale;
	                                            var _quad_t = _sprite_y + _uvs[5]*_text_scale;
	                                            var _quad_r = _quad_l   + _uvs[6]*_sprite_width;
	                                            var _quad_b = _quad_t   + _uvs[7]*_sprite_height;
                                                            
	                                            var _slant_offset = SCRIBBLE_SLANT_AMOUNT*_text_scale*_text_slant*(_quad_b - _quad_t);
                                                var _sprite_data = 4096*floor(1024*_image_speed) + 64*_sprite_number + _image_count;
                                                            
	                                            var _quad_cx = 0.5*(_quad_l + _quad_r);
	                                            var _quad_cy = 0.5*(_quad_t + _quad_b);
                                                            
                                                var _delta_l  = _quad_cx - _quad_l;
                                                var _delta_t  = _quad_cy - _quad_t;
                                                var _delta_r  = _quad_cx - _quad_r;
                                                var _delta_b  = _quad_cy - _quad_b;
                                                var _delta_ls = _delta_l - _slant_offset;
                                                var _delta_rs = _delta_r - _slant_offset;
                                                            
                                                //Pack the glyph centre. This assumes our glyph is maximum 200px wide and gives us 1 decimal place
                                                //This must match what's in __shd_scribble!
                                                var _packed_delta_lb  = floor(1000 + 10*_delta_l ) + 2000*floor(1000 + 10*_delta_b);
                                                var _packed_delta_rb  = floor(1000 + 10*_delta_r ) + 2000*floor(1000 + 10*_delta_b);
                                                var _packed_delta_lst = floor(1000 + 10*_delta_ls) + 2000*floor(1000 + 10*_delta_t);
                                                var _packed_delta_rst = floor(1000 + 10*_delta_rs) + 2000*floor(1000 + 10*_delta_t);
                                                            
                                                //                                                X                                                          Y                                            Character/Line Index                                               Centre dXdY                                              Sprite Data                                                 Flags                                                      Colour                                                 U                                                V
                                                buffer_write(_glyph_buffer, buffer_f32, _quad_l + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_lst); buffer_write(_glyph_buffer, buffer_f32, _sprite_data); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[0]); buffer_write(_glyph_buffer, buffer_f32, _uvs[1]);
                                                buffer_write(_glyph_buffer, buffer_f32, _quad_r                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_rb ); buffer_write(_glyph_buffer, buffer_f32, _sprite_data); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[2]); buffer_write(_glyph_buffer, buffer_f32, _uvs[3]);
                                                buffer_write(_glyph_buffer, buffer_f32, _quad_l                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_lb ); buffer_write(_glyph_buffer, buffer_f32, _sprite_data); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[0]); buffer_write(_glyph_buffer, buffer_f32, _uvs[3]);
                                                buffer_write(_glyph_buffer, buffer_f32, _quad_r                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_rb ); buffer_write(_glyph_buffer, buffer_f32, _sprite_data); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[2]); buffer_write(_glyph_buffer, buffer_f32, _uvs[3]);
                                                buffer_write(_glyph_buffer, buffer_f32, _quad_l + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_lst); buffer_write(_glyph_buffer, buffer_f32, _sprite_data); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[0]); buffer_write(_glyph_buffer, buffer_f32, _uvs[1]);
                                                buffer_write(_glyph_buffer, buffer_f32, _quad_r + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_rst); buffer_write(_glyph_buffer, buffer_f32, _sprite_data); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _uvs[2]); buffer_write(_glyph_buffer, buffer_f32, _uvs[1]);
                                                            
                                                _image = (_image + 1) mod _sprite_number;
                                                _image_count++;
	                                        }
                                                
                                            #endregion
                                                    
	                                        _text_effect_flags = ~((~_text_effect_flags) | 1); //Reset animated sprite effect flag specifically
                                            if (_reset_rainbow) _text_effect_flags |= (1 << global.__scribble_effects[? "rainbow"]);
                                            if (_reset_cycle  ) _text_effect_flags |= (1 << global.__scribble_effects[? "cycle"  ]);
                                                        
	                                        if (SCRIBBLE_CREATE_CHARACTER_ARRAY) character_array[@ characters] = _command_name;
	                                        ++characters;
                                                    
                                            #endregion
	                                    }
	                                    else
                                        {
                                            if (asset_get_type(_command_name) == asset_sound)
    	                                    {
                                                #region Audio Playback Event
                                                
                                                __new_event(characters, "__scribble_audio_playback__", [asset_get_index(_command_name)]);
                                                
                    	                        continue; //Skip the rest of the parser step
                                                        
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
                                                        
    	                                                if (SCRIBBLE_BGR_COLOR_HEX_CODES)
    	                                                {
    	                                                    _text_colour = make_colour_rgb(_blue, _green, _red);
    	                                                }
    	                                                else
    	                                                {
    	                                                    _text_colour = make_colour_rgb(_red, _green, _blue);
    	                                                }
                                                        
    	                                                continue; //Skip the rest of the parser step
                                                        
                                                        #endregion
    	                                            }
    	                                            else
    	                                            {
    	                                                var _second_char = string_copy(_command_name, 2, 1);
    	                                                if (((_first_char  == "d") || (_first_char  == "D"))
    	                                                &&  ((_second_char == "$") || (_second_char == "#")))
    	                                                {
                                                            #region Decimal colour decoding
                                                            
    	                                                    //Check if this number is a real
    	                                                    var _is_real = true;
    	                                                    var _c = 3;
    	                                                    repeat(string_length(_command_name) - 2)
    	                                                    {
    	                                                        var _ord = ord(string_char_at(_command_name, _c));
    	                                                        if ((_ord < 48) || (_ord > 57))
    	                                                        {
    	                                                            _is_real = false;
    	                                                            break;
    	                                                        }
                                                                
    	                                                        ++_c;
    	                                                    }
                                                            
    	                                                    if (_is_real)
    	                                                    {
    	                                                        _text_colour = real(string_delete(_command_name, 1, 2));
    	                                                    }
    	                                                    else
    	                                                    {
    	                                                        __scribble_trace("WARNING! Could not decode [" + _command_name + "], ensure it is a positive integer" );
    	                                                    }
                                                            
    	                                                    continue; //Skip the rest of the parser step
                                                            
                                                            #endregion
    	                                                }
    	                                                else
    	                                                {
    	                                                    var _command_string = string(_command_name);
    	                                                    var _j = 1;
    	                                                    repeat(_command_tag_parameters-1) _command_string += "," + string(_parameters[_j++]);
    	                                                    __scribble_trace("WARNING! Unrecognised command tag [" + _command_string + "]" );
                                                        
    	                                                    continue; //Skip the rest of the parser step
    	                                                }
    	                                            }
    	                                        }
    	                                    }
                                        }
	                                }
	                            }
	                        }
	                    }
	                break;
	            }
                        
	            if ((_new_halign != undefined) && (_new_halign != _text_halign))
	            {
	                _text_halign = _new_halign;
                    _new_halign = undefined;
                            
	                if (_text_x > 0)
	                {
	                    _force_newline = true;
	                    _char_width    = 0;
	                    _line_width    = max(_line_width, _text_x);
	                    if (!_line_fixed_height) _line_height = max(_line_height, _font_line_height*_text_scale); //Change our line height if it's not fixed
                        //Note that forcing a newline will reset the word height to 0
	                }
	                else
	                {
                        _line_data.halign = _text_halign;
	                    continue; //Skip the rest of the parser step
	                }
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
                        show_error("Scribble:\nIn-line vertical alignment cannot be changed more than once in a string\n ", false);
                    }
                            
                    _new_valign = undefined;
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
	    else if ((_character_code == SCRIBBLE_COMMAND_TAG_OPEN) && !_ignore_commands) //If we've hit a command tag argument delimiter character (usually [)
	    {
	        //Record the start of the command tag in the string buffer
	        _command_tag_start = buffer_tell(_string_buffer);
	        _command_tag_parameters = 0;
            _parameters = [];
	        continue;
	    }
	    else if ((_character_code == 10) //If we've hit a newline (\n)
	            || (SCRIBBLE_HASH_NEWLINE && (_character_code == 35)) //If we've hit a hash, and hash newlines are on
	            || ((_character_code == 13) && (buffer_peek(_string_buffer, buffer_tell(_string_buffer)+1, buffer_u8) != 10))) //If this is a line feed but not followed by a newline... this fixes goofy Windows Notepad isses
	    {
	        _force_newline = true;
	        _char_width    = 0;
	        _line_width    = max(_line_width, _text_x);
	        if (!_line_fixed_height) _line_height = max(_line_height, _font_line_height*_text_scale); //Change our line height if it's not fixed
            //Note that forcing a newline will reset the word height to 0
                
	        if (global.__scribble_character_delay)
	        {
	            var _delay = global.__scribble_character_delay_map[? _character_code];
	            if ((_delay != undefined) && (_delay > 0)) __new_event(characters, "delay", [_delay]);
	        }
                
	        _add_character = false;
	    }
	    else if (_character_code == 32) //If we've hit a space
	    {
	        //Grab this characer's width/height
	        _char_width     = _font_space_width*_text_scale;
	        _line_has_space = true;
	        _line_width     = max(_line_width, _text_x);
	        if (!_line_fixed_height) _line_height = max(_line_height, _font_line_height*_text_scale); //Change our line height if it's not fixed
            _word_height = 0; //Reset the word height since we hit a space
            
            _page_data.__reset_word_start();
            
	        //Record the first character in this word
	        _word_start_char = characters;
        
	        if (SCRIBBLE_CREATE_CHARACTER_ARRAY) character_array[@ characters] = _character_code;
	        ++characters;
                
	        if (global.__scribble_character_delay)
	        {
	            var _delay = global.__scribble_character_delay_map[? _character_code];
	            if ((_delay != undefined) && (_delay > 0)) __new_event(characters, "delay", [_delay]);
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
        
            #region Find glyph data
        
	        if (_font_glyphs_array == undefined)
	        {
	        	var _glyph_array = _font_glyphs_map[? _character_code];
	        	if (_glyph_array == undefined) _glyph_array = _font_glyphs_map[? ord(SCRIBBLE_MISSING_CHARACTER)];
	        }
	        else
	        {
	        	if ((_character_code < _font_glyphs_min) || (_character_code > _font_glyphs_max))
	        	{
	        	    _character_code = ord(SCRIBBLE_MISSING_CHARACTER);
	        	    if ((_character_code < _font_glyphs_min) || (_character_code > _font_glyphs_max))
	        	    {
	        	        _glyph_array = undefined;
	        	    }
	        	    else
	        	    {
	        		    var _glyph_array = _font_glyphs_array[_character_code - _font_glyphs_min];
	        	    }
	        	}
	        	else
	        	{
	        		var _glyph_array = _font_glyphs_array[_character_code - _font_glyphs_min];
	        	}
	        }
        
            #endregion
        
	        if (_glyph_array == undefined)
	        {
	            if (SCRIBBLE_VERBOSE) __scribble_trace("scribble_cache() couldn't find glyph data for character code " + string(_character_code) + " (" + chr(_character_code) + ") in font \"" + string(_text_font) + "\"");
	        }
	        else
	        {
                #region Swap texture and buffer if needed
        
	            if (_glyph_array[SCRIBBLE_GLYPH.TEXTURE] != _glyph_texture)
	            {
	            	_glyph_texture = _glyph_array[SCRIBBLE_GLYPH.TEXTURE];
                    
                    var _vbuff_data            = _page_data.__new_vertex_buffer(_glyph_texture, true);
	                var _glyph_buffer          = _vbuff_data.buffer;
	                var _vbuff_line_start_list = _vbuff_data.line_start_list;
                    
	                //Fill line break list
	                var _tell = buffer_tell(_glyph_buffer);
	                repeat(array_length(_page_lines_array) - ds_list_size(_vbuff_line_start_list)) ds_list_add(_vbuff_line_start_list, _tell);
	            }
                
                //Update CHAR_START_TELL, and WORD_START_TELL if needed
                _vbuff_data.char_start_tell = buffer_tell(_glyph_buffer);
                if (_character_wrap)
                {
                    _vbuff_data.word_start_tell = buffer_tell(_glyph_buffer);
                    _vbuff_data.word_x_offset   = undefined;
                    _line_width = max(_line_width, _text_x);
                    
                    //Record the first character in this word
                    _word_start_char = characters;
                }
            
                #endregion
            
                #region Add glyph to buffer
            
	            var _quad_l = _glyph_array[SCRIBBLE_GLYPH.X_OFFSET]*_text_scale;
	            if (SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE && (_vbuff_data.word_x_offset == undefined))
                {
                    _vbuff_data.word_x_offset = _quad_l;
                }
            
	                _quad_l += _text_x;
	            var _quad_t  = _text_y + _glyph_array[SCRIBBLE_GLYPH.Y_OFFSET]*_text_scale - ((_font_line_height*_text_scale) div 2); //TODO - Cache scaled font line height
	            var _quad_r  = _quad_l + _glyph_array[SCRIBBLE_GLYPH.WIDTH   ]*_text_scale;
	            var _quad_b  = _quad_t + _glyph_array[SCRIBBLE_GLYPH.HEIGHT  ]*_text_scale;
                        
                var _quad_cx = 0.5*(_quad_l + _quad_r);
                var _quad_cy = 0.5*(_quad_t + _quad_b);
                        
                var _slant_offset = SCRIBBLE_SLANT_AMOUNT*_text_scale*_text_slant*(_quad_b - _quad_t);
                        
                var _delta_l  = _quad_cx - _quad_l;
                var _delta_t  = _quad_cy - _quad_t;
                var _delta_r  = _quad_cx - _quad_r;
                var _delta_b  = _quad_cy - _quad_b;
                var _delta_ls = _delta_l - _slant_offset;
                var _delta_rs = _delta_r - _slant_offset;
                        
                //Pack the glyph centre. This assumes our glyph is maximum 200px wide and gives us 1 decimal place
                //This must match what's in __shd_scribble!
                var _packed_delta_lb  = floor(1000 + 10*_delta_l ) + 2000*floor(1000 + 10*_delta_b);
                var _packed_delta_rb  = floor(1000 + 10*_delta_r ) + 2000*floor(1000 + 10*_delta_b);
                var _packed_delta_lst = floor(1000 + 10*_delta_ls) + 2000*floor(1000 + 10*_delta_t);
                var _packed_delta_rst = floor(1000 + 10*_delta_rs) + 2000*floor(1000 + 10*_delta_t);
                        
                var _packed_indexes = characters*__SCRIBBLE_MAX_LINES + _page_data.lines; //TODO - Optimise
                        
                if (_text_cycle)
                {
                    var _colour = _text_cycle_colour;
                }
                else
                {
                    var _colour = $FF000000 | _text_colour;
                }
                
                var _quad_u0 = _glyph_array[SCRIBBLE_GLYPH.U0];
                var _quad_v0 = _glyph_array[SCRIBBLE_GLYPH.V0];
                var _quad_u1 = _glyph_array[SCRIBBLE_GLYPH.U1];
                var _quad_v1 = _glyph_array[SCRIBBLE_GLYPH.V1];
                        
                //                                                X                                                           Y                                           Character/Line Index                                              Centre dXdY                                  Sprite Data (unusued for text)                                Flags                                                      Colour                                                  U                                                  V
                buffer_write(_glyph_buffer, buffer_f32, _quad_l + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_lst); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u0); buffer_write(_glyph_buffer, buffer_f32, _quad_v0);
                buffer_write(_glyph_buffer, buffer_f32, _quad_r                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_rb ); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u1); buffer_write(_glyph_buffer, buffer_f32, _quad_v1);
                buffer_write(_glyph_buffer, buffer_f32, _quad_l                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_lb ); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u0); buffer_write(_glyph_buffer, buffer_f32, _quad_v1);
                buffer_write(_glyph_buffer, buffer_f32, _quad_r                ); buffer_write(_glyph_buffer, buffer_f32, _quad_b); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_rb ); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u1); buffer_write(_glyph_buffer, buffer_f32, _quad_v1);
                buffer_write(_glyph_buffer, buffer_f32, _quad_l + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_lst); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u0); buffer_write(_glyph_buffer, buffer_f32, _quad_v0);
                buffer_write(_glyph_buffer, buffer_f32, _quad_r + _slant_offset); buffer_write(_glyph_buffer, buffer_f32, _quad_t); buffer_write(_glyph_buffer, buffer_f32, _packed_indexes);    buffer_write(_glyph_buffer, buffer_f32, _packed_delta_rst); buffer_write(_glyph_buffer, buffer_f32, 0); buffer_write(_glyph_buffer, buffer_f32, _text_effect_flags);    buffer_write(_glyph_buffer, buffer_u32, _colour);    buffer_write(_glyph_buffer, buffer_f32, _quad_u1); buffer_write(_glyph_buffer, buffer_f32, _quad_v0);
                        
                #endregion
                        
	            if (SCRIBBLE_CREATE_CHARACTER_ARRAY) character_array[@ characters] = _character_code;
	            ++characters;
                        
	            _char_width = _glyph_array[SCRIBBLE_GLYPH.SEPARATION]*_text_scale;
	        }
        
	        //Choose the height of a space for the character's height
	        if (!_line_fixed_height) _line_height = max(_line_height, _font_line_height*_text_scale); //Change our line height if it's not fixed
            _word_height = max(_word_height, _font_line_height*_text_scale); //Update the word height
                
	        if (global.__scribble_character_delay)
	        {
	            var _delay = global.__scribble_character_delay_map[? _character_code];
	            if ((_delay != undefined) && (_delay > 0)) __new_event(characters, "delay", [_delay]);
	        }
	    }
    
    
    
        #region Handle new line creation
            
	    if (_force_newline
	    || ((_char_width + _text_x > _max_width) && (_max_width >= 0) && (_character_code > 32)))
	    {
	        var _line_offset_x = -_text_x;
            
            //If we're forcing a newline then we want to reset the word height too
            if (_force_newline) _word_height = 0;
            
            if (!_force_newline)
            {
    	        var _v = 0;
    	        repeat(array_length(_page_vbuffs_array))
    	        {
    	            var _data = _page_vbuffs_array[_v];
                    
    	            //If the line has no space character on it then we know that entire word is longer than the textbox max width
    	            //We fall back to use the character start position for this vertex buffer instead
    	            var _tell = _line_has_space? _data.word_start_tell : _data.char_start_tell;
                    
    	            //If we've added anything to this buffer then we need to figure out how far we need to offset it on the x-axis
    	            var _buffer = _data.buffer;
    	            if (_tell < buffer_tell(_buffer))
    	            {
                        _line_offset_x = max(_line_offset_x, -buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.X, buffer_f32));
                    }
                    
                    ++_v;
                }
            }
            
	        var _v = 0;
	        repeat(array_length(_page_vbuffs_array))
	        {
	            var _data = _page_vbuffs_array[_v];
                
	            var _vbuff_line_start_list = _data.line_start_list;
	            var _buffer                = _data.buffer;
                
	            if (_force_newline)
	            {
	                ds_list_add(_vbuff_line_start_list, buffer_tell(_buffer));
	            }
	            else
	            {
	                //If the line has no space character on it then we know that entire word is longer than the textbox max width
	                //We fall back to use the character start position for this vertex buffer instead
                    var _tell_a = _line_has_space? _data.word_start_tell : _data.char_start_tell;
                    
	                var _tell_b = buffer_tell(_buffer);
	                ds_list_add(_vbuff_line_start_list, _tell_a);
                    
	                //If we've added anything to this buffer
	                if (_tell_a < _tell_b)
	                {
	                    //If the line has no space character on it then we know that entire word is longer than the textbox max width
	                    //We fall back to use the character start position for this vertex buffer instead
	                    if (_line_has_space)
	                    {
	                        //Set our word start tell position to be the same as the character start tell
	                        //This allows us to handle single words that exceed the maximum textbox width multiple times (!)
	                        _data.word_start_tell = _tell_a;
	                    }
	                    else
	                    {
	                        //If our line didn't have a space then set our word/character start position to be the current tell for this buffer
	                        _data.char_start_tell = _tell_b;
	                        _data.word_start_tell = _tell_b;
                            
                            //Update the width of the line based on the right-most edge of the last character
                            _line_width = max(_line_width, buffer_peek(_buffer, _tell_b - __SCRIBBLE_GLYPH_BYTE_SIZE + __SCRIBBLE_VERTEX.X, buffer_f32));
	                    }
                        
	                    //Note the negative sign!
	                    var _offset_x = _data.word_x_offset;
	                    if (_offset_x == undefined) _offset_x = 0;
                        _offset_x += _line_offset_x;
                        
	                    if (_offset_x < 0)
	                    {
	                        //Retroactively move the last word to a new line
	                        var _tell = _tell_a;
	                        repeat((_tell_b - _tell_a) / __SCRIBBLE_VERTEX.__SIZE)
	                        {
	                            //Increment the line index by 1
	                            buffer_poke(_buffer, _tell + __SCRIBBLE_VERTEX.PACKED_INDEXES, buffer_f32, buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.PACKED_INDEXES, buffer_f32) + 1);
                                
	                            //Adjust glyph position
                                buffer_poke(_buffer, _tell + __SCRIBBLE_VERTEX.X, buffer_f32, buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.X, buffer_f32) + _offset_x);
                                
	                            //If we're using a fixed line height, ensure that the glyph y-position is updated too
	                            if (_line_fixed_height)
	                            {
	                                buffer_poke(_buffer, _tell + __SCRIBBLE_VERTEX.Y, buffer_f32, buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.Y, buffer_f32) + _line_height);
	                            }
                                
	                            _tell += __SCRIBBLE_VERTEX.__SIZE;
	                        }
	                    }
                        
	                    _data.word_x_offset = undefined;
	                }
	            }
                
	            ++_v;
	        }
            
	        //Limit the height of the line
	        if (_line_max_height >= 0) _line_height = min(_line_height, _line_max_height);
            
	        //Update the last line
            _line_data.last_char = _force_newline? (characters-1) : _word_start_char;
            _line_data.y         = _line_y + (_line_height div 2);
            _line_data.width     = _line_width;
            _line_data.height    = _line_height;
            
            //Update the page's height
            _page_data.height = _line_y + _line_height;
            
	        //Reset state
	        _text_x        += _line_offset_x;
	        _line_y        += _line_height;
	        _line_has_space = false;
	        _line_width     = 0;
	        _line_height    = _line_fixed_height? _line_height : max(_line_min_height, _word_height);
	        if (_line_fixed_height) _text_y += _line_height;
            
	        //Create a new line
            _line_data            = _page_data.__new_line();
            _line_data.start_char = _force_newline? characters : (_word_start_char+1);
            _line_data.last_char  = characters;
            _line_data.y          = _line_y;
            _line_data.width      = 0;
            _line_data.height     = _line_height;
            _line_data.halign     = _text_halign;
            
	        _force_newline = false;
	    }
                
        #endregion
                
                
                
        #region Handle new page creation
            
	    if (_force_newpage
	    || ((_line_height + _line_y > _max_height) && (_max_height >= 0)))
	    {
	        //Create a new page
            var _new_page_data = __new_page();
            var _new_page_lines_array  = _new_page_data.lines_array; //Stores each line of text (per page)
            var _new_page_vbuffs_array = _new_page_data.vertex_buffer_array; //Stores all the vertex buffers needed to render the text and sprites (per page)
            
            _new_page_data.lines       = 1;
            _new_page_data.start_char  = characters; //We'll update this later to a more accurate value
            _new_page_data.last_char   = characters;
            _new_page_data.start_event = array_length(events_name_array);
            _new_page_data.height      = _line_height;
            
	        //Steal the last line from the previous page
	        _page_data.lines--;
	        _page_lines_array[@ array_length(_page_lines_array)-1] = undefined;
            
	        //Figure out last/start chars for pages
	        _page_data.last_char      = _line_data.start_char - 1;
	        _new_page_data.start_char = _line_data.start_char;
            
	        if (_force_newpage)
	        {
                //Update the previous page's height
                _page_data.height = _line_y + _line_height;
                        
	            //Reset state
	            _text_x      = 0;
	            _line_width  = 0;
	            _line_height = _line_min_height;
	        }
	        else
	        {
	            //Iterate over every vertex buffer on the previous page and steal vertices where we need to
	            var _v = 0;
	            repeat(array_length(_page_vbuffs_array))
	            {
	                var _vbuff_data = _page_vbuffs_array[_v];
                    
	                var _buffer                = _vbuff_data.buffer;
	                var _vbuff_line_start_list = _vbuff_data.line_start_list;
	                var _line_tell_prev        = _vbuff_line_start_list[| _page_data.lines];
	                var _line_tell             = buffer_tell(_buffer);
                    
	                if (_line_tell_prev < _line_tell) //If we've added anything to this buffer on the previous line
	                {
	                    var _bytes = _line_tell - _line_tell_prev;
                        
	                    //Make a new vertex buffer for the new page
                        var _new_vbuff_data            = _new_page_data.__new_vertex_buffer(_vbuff_data.texture, true);
                        var _new_buffer                = _new_vbuff_data.buffer;
                        var _new_vbuff_line_start_list = _new_vbuff_data.line_start_list;
                        
	                    ds_list_add(_new_vbuff_line_start_list, 0);
                        
	                    //Fill in vertex buffer data
	                    _new_vbuff_data.char_start_tell = _vbuff_data.char_start_tell - _line_tell_prev;
	                    _new_vbuff_data.word_start_tell = _vbuff_data.word_start_tell - _line_tell_prev;
	                    _new_vbuff_data.word_x_offset   = _vbuff_data.word_x_offset;
                                
	                    //Copy the relevant vertices of the old buffer to the new buffer
	                    buffer_copy(_buffer, _line_tell_prev, _bytes, _new_buffer, 0);
	                    buffer_seek(_new_buffer, buffer_seek_start, _bytes);
                                
	                    //Resize the old buffer to clip off the vertices we've stolen
	                    buffer_resize(_buffer, _line_tell_prev);
	                    buffer_seek(_buffer, buffer_seek_start, _line_tell_prev); //Resizing a buffer resets its tell
	                    ds_list_delete(_vbuff_line_start_list, ds_list_size(_vbuff_line_start_list)-1);
                                
	                    //If we're using a fixed line height, reset this glyph's y-position
	                    if (!_line_fixed_height)
                        {
    	                    var _tell = __SCRIBBLE_VERTEX.PACKED_INDEXES;
    	                    repeat(_bytes / __SCRIBBLE_VERTEX.__SIZE)
    	                    {
    	                        //Go through every vertex and set its line index to 0
    	                        buffer_poke(_new_buffer, _tell, buffer_f32, __SCRIBBLE_MAX_LINES*(buffer_peek(_new_buffer, _tell, buffer_f32) div __SCRIBBLE_MAX_LINES));
    	                        _tell += __SCRIBBLE_VERTEX.__SIZE;
    	                    }
                        }
                        else
                        {
    	                    var _tell = 0;
    	                    repeat(_bytes / __SCRIBBLE_VERTEX.__SIZE)
    	                    {
                                var _packed_indexes = buffer_peek(_new_buffer, _tell + __SCRIBBLE_VERTEX.PACKED_INDEXES, buffer_f32);
                                var _character = __SCRIBBLE_MAX_LINES*(_packed_indexes div __SCRIBBLE_MAX_LINES);
                                var _line = _packed_indexes - _character;
                                        
    	                        //Go through every vertex and set its line index to 0
    	                        buffer_poke(_new_buffer, _tell + __SCRIBBLE_VERTEX.PACKED_INDEXES, buffer_f32, _character);
                                        
    	                        //If we're using a fixed line height, reset this glyph's y-position
                                buffer_poke(_new_buffer, _tell + __SCRIBBLE_VERTEX.Y, buffer_f32, buffer_peek(_new_buffer, _tell + __SCRIBBLE_VERTEX.Y, buffer_f32) - _line*_line_height);
                                        
    	                        _tell += __SCRIBBLE_VERTEX.__SIZE;
    	                    }
                        }
	                }
                        
	                ++_v;
	            }
	        }
            
	        //Add the line array to this page
	        _new_page_lines_array[@ array_length(_new_page_lines_array)] = _line_data;
            
	        //Transfer new page variables into current page variables
	        _page_data         = _new_page_data;
	        _page_lines_array  = _new_page_lines_array;
	        _page_vbuffs_array = _new_page_vbuffs_array;
            
	        //Reset some state variables
	        height                 = max(height, _line_y);
	        _line_y                =  0;
	        _glyph_texture         = -1;
	        _vbuff_line_start_list = -1;
            
	        if (_line_fixed_height) _text_y = _half_fixed_height;
            
	        _force_newpage = false;
	    }
                
        #endregion
                
                
                
	    _text_x += _char_width;
	}
            
	_line_width = max(_line_width, _text_x);
	if (_line_max_height >= 0) _line_height = min(_line_height, _line_max_height);
          
	_line_data.last_char = characters - 1;
	_line_data.y         = _line_y + (_line_height div 2);
	_line_data.width     = _line_width;
	_line_data.height    = _line_height;
    
	height = max(height, _line_y + _line_height);
            
	//Update metadata
	_page_data.last_char = characters - 1;
    _page_data.height    = _line_y + _line_height;
    
    if (valign == undefined) valign = fa_top;
            
    #endregion
    
    #region Find the actual width of the text element

	//Iterate over every page
    var _model_min_x             = 0;
    var _model_max_x             = 0;
    var _model_justify_max_width = 0;

	var _p = 0;
	repeat(array_length(pages_array))
	{
	    var _page_data = pages_array[_p];
	    _page_lines_array = _page_data.lines_array;
                
        var _page_min_x             = 0;
        var _page_max_x             = 0;
        var _page_justify_max_width = 0;
                
	    //Iterate over every line on the page
	    var _l = 0;
	    repeat(array_length(_page_lines_array))
	    {
	        var _line_data = _page_lines_array[_l];
	        if (is_struct(_line_data)) //Someimtes the array can contain <undefined> if a line is moved from one page to another
	        {
	            var _line_width = _line_data.width;
	            switch(_line_data.halign)
	            {
	                case fa_left:
	                    _model_max_x = max(_model_max_x, _line_width);
                        _page_max_x  = max(_page_max_x , _line_width);
	                break;
                
	                case fa_center:
	                    _model_min_x = min(_model_min_x, -(_line_width div 2));
	                    _model_max_x = max(_model_max_x,   _line_width div 2 );
                        _page_min_x  = min(_page_min_x , -(_line_width div 2));
                        _page_max_x  = max(_page_max_x ,   _line_width div 2 );
	                break;
                
	                case fa_right:
	                    _model_min_x = min(_model_min_x, -_line_width);
                        _page_min_x  = min(_page_min_x , -_line_width);
	                break;
                
	                case __SCRIBBLE_PIN_LEFT:
	                case __SCRIBBLE_PIN_CENTRE:
	                case __SCRIBBLE_PIN_RIGHT:
                        _model_justify_max_width = max(_model_justify_max_width, _line_width);
                        _page_justify_max_width  = max(_page_justify_max_width , _line_width);
	                break;
	            }
	        }
        
	        ++_l;
	    }
                
        var _fixed_width = _page_max_x - _page_min_x;
        if (_page_justify_max_width > _fixed_width)
        {
            var _delta = _page_justify_max_width - _fixed_width;
            if (_page_min_x >= 0)
            {
                _page_max_x += _delta;
            }
            else if (_page_max_x <= 0)
            {
                _page_min_x -= _delta;
            }
            else
            {
                _page_min_x -= _delta div 2;
                _page_max_x += _delta div 2;
            }
        }
                
        _page_data.min_x = _page_min_x;
        _page_data.max_x = _page_max_x;
        _page_data.width = _page_max_x - _page_min_x;
    
	    ++_p;
	}

	var _fixed_width = _model_max_x - _model_min_x;
    if (_model_justify_max_width > _fixed_width)
	{
        var _delta = _model_justify_max_width - _fixed_width;
	    if (_model_min_x >= 0)
	    {
	        _model_max_x += _delta;
	    }
	    else if (_model_max_x <= 0)
	    {
	        _model_min_x -= _delta;
	    }
	    else
	    {
	        _model_min_x -= _delta div 2;
	        _model_max_x += _delta div 2;
	    }
	}

	min_x = _model_min_x;
	max_x = _model_max_x;
	width = _model_max_x - _model_min_x;

    #endregion
    
    #region Final glyph transforms - horizontal alignment and Bezier curves
            
    //Find the min/max x-bounds for the textbox
    if (_max_width < 0)
    {
        //If no max width has been set, use the element's calculated size
        var _pin_min_x = min_x;
        var _pin_max_x = max_x;
    }
    else
    {
        //Otherwise use a fixed range
        var _pin_min_x = 0;
        var _pin_max_x = _max_width;
    }
            
	//Iterate over every page
	var _p = 0;
	repeat(array_length(pages_array))
	{
	    var _page_data = pages_array[_p];
	    _page_lines_array  = _page_data.lines_array;
	    _page_vbuffs_array = _page_data.vertex_buffer_array;
            
	    //Iterate over every vertex buffer for that page
	    var _v = 0;
	    repeat(array_length(_page_vbuffs_array))
	    {
	        var _data = _page_vbuffs_array[_v];
                    
	        var _vbuff_line_start_list = _data.line_start_list;
	        var _buffer                = _data.buffer;
                    
            #region Move glyphs around on a line to finalise alignment
                    
	        var _buffer_tell = buffer_tell(_buffer);
	        ds_list_add(_vbuff_line_start_list, _buffer_tell);
                    
	        //Iterate over every line on the page
	        var _l = 0;
	        repeat(ds_list_size(_vbuff_line_start_list)-1)
	        {
	            var _line_data = _page_lines_array[_l];
	            if (is_struct(_line_data)) //Someimtes the array can contain <undefined> if a line is moved from one page to another
	            {
	                var _tell_a = _vbuff_line_start_list[| _l  ];
	                var _tell_b = _vbuff_line_start_list[| _l+1];
                            
	                if (_tell_b - _tell_a > 0)
	                {    
	                    var _offset = 0;
	                    switch(_line_data.halign)
	                    {
	                        case fa_center:
	                            _offset = -(_line_data.width div 2);
	                        break;
                                        
	                        case fa_right:
	                            _offset = -_line_data.width;
	                        break;
                                        
	                        case __SCRIBBLE_PIN_LEFT:
	                            _offset = _pin_min_x;
	                        break;
                                        
	                        case __SCRIBBLE_PIN_CENTRE:
	                            _offset = ((_pin_min_x + _pin_max_x) div 2) - (_line_data.width div 2);
	                        break;
                                        
	                        case __SCRIBBLE_PIN_RIGHT:
	                            _offset = _pin_max_x - _line_data.width;
	                        break;
	                    }
                        
	                    if (_offset != 0)
	                    {
	                        //We want to write to the CENTRE_X property of every vertex for horizontal alignment
	                        var _tell = _tell_a + __SCRIBBLE_VERTEX.X;
	                        repeat((_tell_b - _tell_a) / __SCRIBBLE_VERTEX.__SIZE)
	                        {
	                            //Poke the new value by adding the offset to the old value
	                            buffer_poke(_buffer, _tell, buffer_f32, _offset + buffer_peek(_buffer, _tell, buffer_f32));
                                            
	                            //Now jump ahead to the next vertex. This means we're always writing to CENTRE_X!
	                            _tell += __SCRIBBLE_VERTEX.__SIZE;
	                        }
	                    }
                        
	                    //Only update glyph y-positions if we're not using fixed line heights
	                    if (!_line_fixed_height)
	                    {
	                        //Now let's do vertical alignment by writing to CENTRE_Y
	                        var _line_y = _line_data.y;
	                        var _tell   = _tell_a + __SCRIBBLE_VERTEX.Y;
	                        repeat((_tell_b - _tell_a) / __SCRIBBLE_VERTEX.__SIZE)
	                        {
	                            //Poke the new value by adding the offset to the old value
	                            buffer_poke(_buffer, _tell, buffer_f32, _line_y + buffer_peek(_buffer, _tell, buffer_f32));
                                        
	                            //Now jump ahead to the next vertex. This means we're always writing to CENTRE_Y!
	                            _tell += __SCRIBBLE_VERTEX.__SIZE;
	                        }
	                    }
	                }
	            }
                        
	            ++_l;
	        }
                    
            #endregion
                    
	        if (_bezier_do && (_buffer != undefined))
	        {
                #region Apply Bezier curve
                        
                var _bezier_index = 0;
                var _bezier_d0    = 0;
                var _bezier_d1    = _bezier_lengths[1];
                        
                var _cx = 0;
                var _cy = 0;
                var _old_cx = 0;
                            
	            //Start at the start...
	            var _tell = 0;
	            repeat(buffer_get_size(_buffer) div __SCRIBBLE_GLYPH_BYTE_SIZE)
	            {
                    //Top-left corner
                    var _l = buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.X, buffer_f32);
                    var _t = buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.Y, buffer_f32);
                            
                    //Bottom-right corner
                    var _r = buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.X + __SCRIBBLE_VERTEX.__SIZE, buffer_f32);
                    var _b = buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.Y + __SCRIBBLE_VERTEX.__SIZE, buffer_f32);
                                
	                //Ignore null data in the vertex buffer
	                if ((_l != 0) || (_r != 0))
	                {
                        //Find the middle
                        var _cx = 0.5*(_l + _r);
                        var _cy = 0.5*(_t + _b);
                                
                        if (_cx < _old_cx)
                        {
                            _bezier_index = 0;
                            _bezier_d0 = 0;
                            _bezier_d1 = _bezier_lengths[1];
                        }
                                
                        _old_cx = _cx;
                                    
                        //Iterate forwards until we find a Bezier segment we can fit into
                        while (true)
                        {
                            if (_cx <= _bezier_d1)
                            {
                                //Parameterise this glyph
                                var _t = _bezier_inc*((_cx - _bezier_d0)/ (_bezier_d1 - _bezier_d0) + _bezier_index);
                                break;
                            }
                                    
                            _bezier_index++;
                                    
                            if (_bezier_index >= SCRIBBLE_BEZIER_ACCURACY-1)
                            {
                                //We've hit the end of the Bezier curve, force all the remaining glyphs to stack up at the end of the line
                                var _t = 1.0;
                                break;
                            }
                                    
                            _bezier_d0 = _bezier_d1;
                            _bezier_d1 = _bezier_lengths[_bezier_index+1];
                        }
                                
                        //Write the parameter to each triangle for this quad
                        repeat(6)
                        {
                            buffer_poke(_buffer, _tell + __SCRIBBLE_VERTEX.X, buffer_f32, _t );
                            buffer_poke(_buffer, _tell + __SCRIBBLE_VERTEX.Y, buffer_f32, _cy);
                            _tell += __SCRIBBLE_VERTEX.__SIZE;
                        }
	                }
                    else
                    {
    	                //Move to the next quad
    	                _tell += __SCRIBBLE_GLYPH_BYTE_SIZE;
                    }
	            }
                        
                #endregion
            }
                    
            _data.__build_vertex_buffer(_freeze);
            _data.__clean_up(!SCRIBBLE_CREATE_GLYPH_LTRB_ARRAY || _bezier_do);
                    
	        ++_v;
	    }
            
	    ++_p;
	}
        
    #endregion
           
	if (SCRIBBLE_CREATE_GLYPH_LTRB_ARRAY)
	{
        if (_bezier_do) show_error("Scribble:\nSCRIBBLE_CREATE_GLYPH_LTRB_ARRAY is not compatible with Bezier curves\n ", true);
                
        #region Generate glyph LTRB array if requested
            
	    glyph_ltrb_array = array_create(characters, undefined);
                
	    //Iterate over every page
	    var _p = 0;
	    repeat(array_length(pages_array))
	    {
	        _page_vbuffs_array = pages_array[_p].vertex_buffer_array;
                    
	        //Iterate over every vertex buffer for that page
	        var _v = 0;
	        repeat(array_length(_page_vbuffs_array))
	        {
	            //Grab the vertex buffer
	            var _data = _page_vbuffs_array[_v];
	            var _buffer = _data.buffer;
                    
	            if (_buffer != undefined)
	            {
	                //Start at the start...
	                var _tell = 0;
	                repeat(buffer_get_size(_buffer) div __SCRIBBLE_GLYPH_BYTE_SIZE)
	                {
	                    //Get which character we're reading
	                    var _packed_indexes = buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.PACKED_INDEXES, buffer_f32);
                            
	                    //Read the top-left corner
                        var _l = buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.X, buffer_f32);
                        var _t = buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.Y, buffer_f32);
                            
	                    //Read out the bottom-right corner
	                    _tell += __SCRIBBLE_VERTEX.__SIZE;
                        var _r = buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.X, buffer_f32);
                        var _b = buffer_peek(_buffer, _tell + __SCRIBBLE_VERTEX.Y, buffer_f32);
                            
	                    //Move to the next quad
	                    _tell += __SCRIBBLE_GLYPH_BYTE_SIZE - __SCRIBBLE_VERTEX.__SIZE;
                            
	                    //Ignore null data in the vertex buffer
	                    if ((_packed_indexes != 0) || (_l != 0) || (_t != 0) || (_r != 0) || (_b != 0))
	                    {
	                        //Unpack the character and line indexes
	                        var _char = _packed_indexes div __SCRIBBLE_MAX_LINES;
	                        var _line = _packed_indexes - __SCRIBBLE_MAX_LINES*_char;
                                
	                        //Find out if an LTRB definition exists for this character already
	                        var _old_ltrb = glyph_ltrb_array[_char];
	                        if (!is_array(_old_ltrb))
	                        {
	                            //If we don't have any pre-existing data, use the current glyph's LTRB
	                            glyph_ltrb_array[@ _char] = [_l, _t, _r, _b, _line];
	                        }
	                        else
	                        {
	                            //If we found some previous data, we need to add info to the multi array to figure out later
	                            glyph_ltrb_array[@ _char] = [min(_old_ltrb[0], _l   ),
	                                                         min(_old_ltrb[1], _t   ),
	                                                         max(_old_ltrb[2], _r   ),
	                                                         max(_old_ltrb[3], _b   ),
	                                                         max(_old_ltrb[4], _line),
	                                                         _p];
	                        }
	                    }
	                }
                    
                    _data.__clean_up(true);
	            }
                
	            ++_v;
	        }
            
	        ++_p;
	    }
        
	    glyph_ltrb_array[@ array_length(glyph_ltrb_array)] = glyph_ltrb_array[array_length(glyph_ltrb_array)-1];
            
        #endregion
	}
    
	if (SCRIBBLE_VERBOSE)
    {
        var _elapsed = (get_timer() - _timer_total)/1000;
        __scribble_trace("scribble_cache() took ", _elapsed, "ms for ", characters, " characters (ratio=", string_format(_elapsed/characters, 0, 6), ")");
    }
}