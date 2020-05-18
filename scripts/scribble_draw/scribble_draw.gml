/// Draws text using Scribble's formatting.
/// 
/// Returns: A Scribble text element (which is really a complex array)
/// @param x                    x-position in the room to draw at.
/// @param y                    y-position in the room to draw at.
/// @param string/textElement   Either a string to be drawn, or a previously created text element
/// 
/// Formatting commands:
/// []                                  Reset formatting to defaults
/// [/page]                             Page break
/// [delay]                             Pause the autotype for a fixed amount of time at the tag's position. Only supported when using autotype. DUration is defined by SCRIBBLE_DEFAULT_DELAY_DURATION
/// [delay,<time>]                      Pause the autotype for a fixed amount of time at the tag's position. Only supported when using autotype
/// [pause]                             Pause the autotype at the tag's position. Call scribble_autotype_is_paused() to unpause the autotyper. User scribble_autotype_is_paused() to return if the autotyper is paused
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
/// Scribble has the following animated effects by default:
/// [wave]    [/wave]                   Set/unset text to wave up and down
/// [shake]   [/shake]                  Set/unset text to shake
/// [rainbow] [/rainbow]                Set/unset text to cycle through rainbow colours
/// [wobble]  [/wobble]                 Set/unset text to wobble by rotating back and forth
/// [pulse]   [/pulse]                  Set/unset text to shrink and grow rhythmically
/// [wheel]   [/wheel]                  Set/unset text to circulate around their origin

var _draw_x      = argument0;
var _draw_y      = argument1;
var _draw_string = argument2;

//Check the cache
var _scribble_array = scribble_cache(_draw_string);
if (_scribble_array == undefined) return undefined;

#region Draw this text element
    
var _element_pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
var _page_array = _element_pages_array[_scribble_array[SCRIBBLE.AUTOTYPE_PAGE]];
    
//Figure out the left/top offset
switch(global.scribble_state_box_halign)
{
    case fa_center: var _left = -_scribble_array[SCRIBBLE.WIDTH] div 2; break;
    case fa_right:  var _left = -_scribble_array[SCRIBBLE.WIDTH];       break;
    default:        var _left = 0;                                        break;
}
    
switch(global.scribble_state_box_valign)
{
    case fa_middle: var _top = -_scribble_array[SCRIBBLE.HEIGHT] div 2; break;
    case fa_bottom: var _top = -_scribble_array[SCRIBBLE.HEIGHT];       break;
    default:        var _top = 0;                                         break;
}
    
//Handle the animation timer
var _increment_timers = ((current_time - _scribble_array[SCRIBBLE.TIME]) > __SCRIBBLE_EXPECTED_FRAME_TIME);
var _animation_time   = _scribble_array[SCRIBBLE.ANIMATION_TIME];
    
if (_increment_timers)
{
    _animation_time += SCRIBBLE_STEP_SIZE;
    _scribble_array[@ SCRIBBLE.ANIMATION_TIME] = _animation_time;
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
    var _typewriter_adjusted_speed = _scribble_array[SCRIBBLE.AUTOTYPE_SPEED]*SCRIBBLE_STEP_SIZE;
        
    var _typewriter_method = _scribble_array[SCRIBBLE.AUTOTYPE_METHOD];
    if (_typewriter_method == SCRIBBLE_AUTOTYPE_NONE)
    {
        var _typewriter_head_pos = 1;
        var _typewriter_tail_pos = 1;
    }
    else
    {
        var _typewriter_smoothness = _scribble_array[SCRIBBLE.AUTOTYPE_SMOOTHNESS   ];
        var _typewriter_tail_pos   = _scribble_array[SCRIBBLE.AUTOTYPE_TAIL_POSITION];
        var _typewriter_head_pos   = _scribble_array[SCRIBBLE.AUTOTYPE_HEAD_POSITION];
        var _typewriter_fade_in    = _scribble_array[SCRIBBLE.AUTOTYPE_FADE_IN      ];
            
        //Handle pausing
        if (_scribble_array[SCRIBBLE.AUTOTYPE_PAUSED])
        {
            var _typewriter_speed = 0;
        }
        else if (_scribble_array[SCRIBBLE.AUTOTYPE_DELAY_PAUSED])
        {
            if (current_time > _scribble_array[SCRIBBLE.AUTOTYPE_DELAY_END])
            {
                _scribble_array[@ SCRIBBLE.AUTOTYPE_DELAY_PAUSED] = false;
                var _typewriter_speed = _typewriter_adjusted_speed;
            }
            else
            {
                var _typewriter_speed = 0;
            }
        }
        else
        {
            var _typewriter_speed = _typewriter_adjusted_speed;
        }
            
        #region Scan for autotype events
        
        if ((_typewriter_fade_in >= 0) && (_typewriter_speed > 0))
        {
            //Find the last character we need to scan
            switch(_typewriter_method)
            {
                case SCRIBBLE_AUTOTYPE_PER_CHARACTER:
                    var _scan_b = ceil(_typewriter_head_pos + _typewriter_speed);
                    _scan_b = min(_scan_b, _page_array[__SCRIBBLE_PAGE.CHARACTERS]);
                break;
                
                case SCRIBBLE_AUTOTYPE_PER_LINE:
                    var _page_lines_array = _page_array[__SCRIBBLE_PAGE.LINES_ARRAY];
                    var _line   = _page_lines_array[min(ceil(_typewriter_head_pos + _typewriter_speed), _page_array[__SCRIBBLE_PAGE.LINES]-1)];
                    var _scan_b = _line[__SCRIBBLE_LINE.LAST_CHAR];
                break;
            }
            
            var _scan_a = _page_array[__SCRIBBLE_PAGE.EVENT_CHAR_PREVIOUS];
            if (_scan_b > _scan_a)
            {
                var _event                = _page_array[__SCRIBBLE_PAGE.EVENT_PREVIOUS     ];
                var _events_char_array    = _page_array[__SCRIBBLE_PAGE.EVENT_CHAR_ARRAY   ];
                var _events_name_array    = _page_array[__SCRIBBLE_PAGE.EVENT_NAME_ARRAY   ];
                var _events_visited_array = _page_array[__SCRIBBLE_PAGE.EVENT_VISITED_ARRAY];
                var _events_data_array    = _page_array[__SCRIBBLE_PAGE.EVENT_DATA_ARRAY   ];
                var _event_count          = array_length_1d(_events_char_array);
                
                //Always start scanning at the next event
                ++_event;
                if (_event < _event_count)
                {
                    var _event_char = _events_char_array[_event];
                        
                    //Now iterate from our current character position to the next character position
                    var _break = false;
                    var _scan = _scan_a;
                    var _skipping = _scribble_array[SCRIBBLE.AUTOTYPE_SKIP];
                    repeat(_scan_b - _scan_a)
                    {
                        while ((_event < _event_count) && (_event_char == _scan))
                        {
                            var _event_name       = _events_name_array[_event];
                            var _event_data_array = _events_data_array[_event];
                                
                            if (!_events_visited_array[_event])
                            {
                                _events_visited_array[@ _event] = true;
                                    
                                //Process pause and delay events
                                if ((_event_name == "pause") && !_skipping)
                                {
                                    _page_array[@ __SCRIBBLE_PAGE.EVENT_PREVIOUS] = _event;
                                    _scribble_array[@ SCRIBBLE.AUTOTYPE_PAUSED] = true;
                                }
                                else if ((_event_name == "delay") && !_skipping)
                                {
                                    _page_array[@ __SCRIBBLE_PAGE.EVENT_PREVIOUS] = _event;
                                        
                                    if (array_length_1d(_event_data_array) >= 1)
                                    {
                                        var _duration = real(_event_data_array[0]);
                                    }
                                    else
                                    {
                                        var _duration = SCRIBBLE_DEFAULT_DELAY_DURATION;
                                    }
                                        
                                    _scribble_array[@ SCRIBBLE.AUTOTYPE_DELAY_PAUSED] = true;
                                    _scribble_array[@ SCRIBBLE.AUTOTYPE_DELAY_END   ] = current_time + _duration;
                                }
                                else
                                {
                                    //Otherwise try to find a custom event
                                    var _script = global.__scribble_autotype_events[? _event_name];
                                    if (_script != undefined)
                                    {
                                        _page_array[@ __SCRIBBLE_PAGE.EVENT_PREVIOUS] = _event;
                                        script_execute(_script, _scribble_array, _event_data_array, _scan);
                                    }
                                }
                                    
                                if (_scribble_array[SCRIBBLE.AUTOTYPE_PAUSED]
                                ||  _scribble_array[SCRIBBLE.AUTOTYPE_DELAY_PAUSED])
                                {
                                    _typewriter_speed = _scan - _scan_a;
                                    _break = true;
                                    break;
                                }
                            }
                                
                            ++_event;
                            if (_event < _event_count) _event_char = _events_char_array[_event];
                        }
                            
                        if (_break) break;
                        ++_scan;
                    }
                        
                    if (_break && (_typewriter_method == SCRIBBLE_AUTOTYPE_PER_CHARACTER)) _typewriter_head_pos = _scan;
                        
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
        
    #region Move the typewriter head/tail
    
    if (_typewriter_method != SCRIBBLE_AUTOTYPE_NONE)
    {
        switch(_typewriter_method)
        {
            case SCRIBBLE_AUTOTYPE_PER_CHARACTER: var _typewriter_count = _page_array[__SCRIBBLE_PAGE.CHARACTERS]; break;
            case SCRIBBLE_AUTOTYPE_PER_LINE:      var _typewriter_count = _page_array[__SCRIBBLE_PAGE.LINES     ]; break;
        }
            
        //If it's been around-about a frame since we called this script...
        if (_increment_timers)
        {
            _typewriter_head_pos = clamp(_typewriter_head_pos + _typewriter_speed, 0, _typewriter_count);
                
            if (_scribble_array[SCRIBBLE.AUTOTYPE_TAIL_MOVING] || (_typewriter_speed == 0))
            {
                _typewriter_tail_pos += _typewriter_adjusted_speed;
                    
                if (_typewriter_tail_pos >= _typewriter_head_pos)
                {
                    _typewriter_tail_pos = _typewriter_head_pos;
                    _scribble_array[@ SCRIBBLE.AUTOTYPE_TAIL_MOVING] = false;
                }
            }
            else if (_typewriter_tail_pos < _typewriter_head_pos - _typewriter_smoothness)
            {
                _scribble_array[@ SCRIBBLE.AUTOTYPE_TAIL_MOVING] = true;
                _typewriter_tail_pos = max(_typewriter_tail_pos, _typewriter_head_pos - _typewriter_smoothness);
            }
                
            _scribble_array[@ SCRIBBLE.AUTOTYPE_TAIL_POSITION] = _typewriter_tail_pos;
            _scribble_array[@ SCRIBBLE.AUTOTYPE_HEAD_POSITION] = _typewriter_head_pos;
        }
        
        //Use a negative typewriter method to communicate a fade-out state to the shader
        //It's a bit hacky but it reduces the uniform count for the shader
        if (!_typewriter_fade_in) _typewriter_method = -_typewriter_method;
    }
    
    #endregion
        
    if ((_typewriter_speed > 0) && (floor(_scan_b) > floor(_scan_a)))
    {
        #region Play a sound effect as the text is revealed
        
        var _sound_array = _scribble_array[SCRIBBLE.AUTOTYPE_SOUND_ARRAY];
        if (is_array(_sound_array) && (array_length_1d(_sound_array) > 0))
        {
            var _play_sound = false;
            if (_scribble_array[SCRIBBLE.AUTOTYPE_SOUND_PER_CHAR])
            {
                _play_sound = true;
            }
            else if (current_time >= _scribble_array[SCRIBBLE.SOUND_FINISH_TIME]) 
            {
                _play_sound = true;
            }
            
            if (_play_sound)
            {
                global.__scribble_lcg = (48271*global.__scribble_lcg) mod 2147483647; //Lehmer
                var _rand = global.__scribble_lcg / 2147483648;
                var _sound = _sound_array[floor(_rand*array_length_1d(_sound_array))];
                
                var _inst = audio_play_sound(_sound, 0, false);
                
                global.__scribble_lcg = (48271*global.__scribble_lcg) mod 2147483647; //Lehmer
                var _rand = global.__scribble_lcg / 2147483648;
            	audio_sound_pitch(_inst, lerp(_scribble_array[SCRIBBLE.AUTOTYPE_SOUND_MIN_PITCH], _scribble_array[SCRIBBLE.AUTOTYPE_SOUND_MAX_PITCH], _rand));
                
                _scribble_array[@ SCRIBBLE.SOUND_FINISH_TIME] = current_time + 1000*audio_sound_length(_sound) - _scribble_array[SCRIBBLE.AUTOTYPE_SOUND_OVERLAP];
            }
        }
        
        #endregion
        
        var _callback = _scribble_array[SCRIBBLE.AUTOTYPE_FUNCTION];
        if ((_callback != undefined) && script_exists(_callback)) script_execute(_callback, _scribble_array, _scribble_array[SCRIBBLE.AUTOTYPE_TAIL_POSITION]);
    }
    
    //Set the shader and its uniforms
    shader_set(shd_scribble);
    shader_set_uniform_f(global.__scribble_uniform_time        , _animation_time);
        
    shader_set_uniform_f(global.__scribble_uniform_tw_method   , _typewriter_method);
    shader_set_uniform_f(global.__scribble_uniform_tw_tail_pos , _typewriter_tail_pos);
    shader_set_uniform_f(global.__scribble_uniform_tw_head_pos , _typewriter_head_pos);
        
    shader_set_uniform_f(global.__scribble_uniform_colour_blend, colour_get_red(  global.scribble_state_colour)/255,
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
_scribble_array[@ SCRIBBLE.TIME] = current_time;

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
        || (array_length_1d(_cache_array) != SCRIBBLE.__SIZE)
        || (_cache_array[SCRIBBLE.VERSION] != __SCRIBBLE_VERSION)
        || _cache_array[SCRIBBLE.FREED])
        {
            if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: \"" + _cache_string + "\" exists in cache but doesn't exist elsewhere");
            ds_list_delete(global.__scribble_global_cache_list, global.__scribble_cache_test_index);
        }
        else if (_cache_array[SCRIBBLE.TIME] + SCRIBBLE_CACHE_TIMEOUT < current_time)
        {
            if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: Removing \"" + _cache_string + "\" from cache");
            
            var _element_pages_array = _cache_array[SCRIBBLE.PAGES_ARRAY];
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
            
            _cache_array[@ SCRIBBLE.FREED] = true;
            
            //Remove reference from cache
            ds_map_delete(global.__scribble_global_cache_map, _cache_string);
            ds_list_delete(global.__scribble_global_cache_list, global.__scribble_cache_test_index);
            
            //Remove global reference
            ds_map_delete(global.scribble_alive, _cache_array[SCRIBBLE.GLOBAL_INDEX]);
        }
    }
}

#endregion

return _scribble_array;