/// @param x        The x position in the room to draw at
/// @param y        The y position in the room to draw at
/// @param string   The string to be drawn. See scribble_create()

var _x      = argument0;
var _y      = argument1;
var _string = argument2;



if (is_array(_string))
{
    if (scribble_exists(_string))
    {
        //If the input string is actually a Scribble data structure, let's just use that
        var _scribble_array = _string;
        _scribble_array[@ __SCRIBBLE.TIME] = current_time;
    }
    else
    {
        show_error("Scribble:\nData structure does not exist.\n ", false);
        return undefined;
    }
}
else
{
    //Check the cache
    var _cache_string = string(_string) + ":" + string(global.__scribble_state_line_min_height) + ":" + string(global.__scribble_state_max_width);
    if (ds_map_exists(global.__scribble_global_cache_map, _cache_string))
    {
        //Grab the Scribble data structure, and update the TIME property
        var _scribble_array = global.__scribble_global_cache_map[? _cache_string];
        _scribble_array[@ __SCRIBBLE.TIME] = current_time;
    }
    else
    {
        //Cache a new data structure if we don't have a relevant one for this string
        var _scribble_array = scribble_cache(_string);
    }
}



#region Handle triggering typewriter

//If needed, trigger the fade out typewriter behaviour
if (_scribble_array[__SCRIBBLE.TW_DIRECTION] == 0)
{
    //If directed to, start a fade in
    if (global.__scribble_state_tw_fade_in)
    {
        _scribble_array[@ __SCRIBBLE.TW_DIRECTION] = 1;
        _scribble_array[@ __SCRIBBLE.TW_POSITION ] = 0;
        _scribble_array[@ __SCRIBBLE.CHAR_FADE_T ] = (global.__scribble_state_tw_method != SCRIBBLE_TYPEWRITER_PER_CHARACTER);
        _scribble_array[@ __SCRIBBLE.LINE_FADE_T ] = (global.__scribble_state_tw_method != SCRIBBLE_TYPEWRITER_PER_LINE);
    }
}
else
{
    //If we're actively running the typewriter...
    if (global.__scribble_state_tw_fade_in)
    {
        //If directed to, try to start a fade in
        if (scribble_get_typewriter_state(_scribble_array) == 2.0)
        {
            _scribble_array[@ __SCRIBBLE.TW_DIRECTION] = 1;
            _scribble_array[@ __SCRIBBLE.TW_POSITION ] = 0;
            _scribble_array[@ __SCRIBBLE.CHAR_FADE_T ] = (global.__scribble_state_tw_method != SCRIBBLE_TYPEWRITER_PER_CHARACTER);
            _scribble_array[@ __SCRIBBLE.LINE_FADE_T ] = (global.__scribble_state_tw_method != SCRIBBLE_TYPEWRITER_PER_LINE);
        }
    }
    else
    {
        //Otherwise wait until the typewriter 
        if (scribble_get_typewriter_state(_scribble_array) == 1.0)
        {
            _scribble_array[@ __SCRIBBLE.TW_DIRECTION] = -1;
            _scribble_array[@ __SCRIBBLE.TW_POSITION ] =  0;
            _scribble_array[@ __SCRIBBLE.CHAR_FADE_T ] =  1;
            _scribble_array[@ __SCRIBBLE.LINE_FADE_T ] =  1;
        }
    }
}

#endregion



#region If we're actively running the typewriter, step through

if (_scribble_array[__SCRIBBLE.TW_DIRECTION] != 0)
{
    var _tw_speed     = global.__scribble_state_tw_speed*SCRIBBLE_STEP_SIZE;
    var _tw_direction = _scribble_array[__SCRIBBLE.TW_DIRECTION];
    if ((_tw_direction != 0) && (_tw_speed > 0))
    {
        #region Advance typewriter
        
        var _tw_method = global.__scribble_state_tw_method;
        var _tw_pos    = _scribble_array[__SCRIBBLE.TW_POSITION];
        var _pos_max   = 1.0;
        var _scan_a    = -1;
        var _scan_b    = -1;
        
        switch(_tw_method)
        {
            case SCRIBBLE_TYPEWRITER_WHOLE:
                if ((_tw_direction > 0) && (floor(_tw_pos) < floor(_tw_pos + _tw_speed)))
                {
                    _scan_b = _scribble_array[__SCRIBBLE.CHARACTERS];
                }
            break;
            
            case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
                _pos_max = _scribble_array[__SCRIBBLE.CHARACTERS];
            
                if ((_tw_direction > 0) && (ceil(_tw_pos) < ceil(_tw_pos + _tw_speed)))
                {
                    _scan_b = ceil(_tw_pos + _tw_speed);
                }
            break;
            
            case SCRIBBLE_TYPEWRITER_PER_LINE:
                _pos_max = _scribble_array[__SCRIBBLE.LINES];
            
                if ((_tw_direction > 0) && (ceil(_tw_pos) < ceil(_tw_pos + _tw_speed)))
                {
                    var _list = _scribble_array[__SCRIBBLE.LINE_LIST];
                    var _line = _list[| min(ceil(_tw_pos + _tw_speed), _pos_max-1)];
                    _scan_b = _line[__SCRIBBLE_LINE.LAST_CHAR];
                }
            break;
            
            default:
                show_error("Scribble:\nTypewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_PER_CHARACTER or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false);
            break;
        }
        
        _tw_pos = clamp(_tw_pos + _tw_speed, 0, _pos_max);
        
        #endregion
        
        if (_scan_b >= 0)
        {
            var _scan_a = _scribble_array[__SCRIBBLE.EVENT_CHAR_PREVIOUS];
            if (_scan_b > _scan_a)
            {
                #region Scan for new events
                
                var _event             = _scribble_array[__SCRIBBLE.EVENT_PREVIOUS  ];
                var _events_char_array = _scribble_array[__SCRIBBLE.EVENT_CHAR_ARRAY];
                var _events_name_array = _scribble_array[__SCRIBBLE.EVENT_NAME_ARRAY];
                var _events_data_array = _scribble_array[__SCRIBBLE.EVENT_DATA_ARRAY];
                var _event_count       = array_length_1d(_events_char_array);
                
                //Always start scanning at the next event
                ++_event;
                
                //Now iterate from our current character position to the next character position
                var _break = false;
                var _scan_char = _scan_a;
                repeat(_scan_b - _scan_a)
                {
                    while ((_event < _event_count) && (_events_char_array[_event] == _scan_char + 1))
                    {
                        var _script = global.__scribble_events[? _events_name_array[_event]];
                        if (_script != undefined)
                        {
                            _scribble_array[@ __SCRIBBLE.EVENT_PREVIOUS] = _event;
                            script_execute(_script, _scribble_array, _events_data_array[_event], _scan_char);
                        }
                        
                        if (_scribble_array[__SCRIBBLE.TW_SPEED] <= 0.0)
                        {
                            _break = true;
                            break;
                        }
                        
                        ++_event;
                    }
                    
                    if (_break) break;
                    ++_scan_char;
                }
                
                if (_break)
                {
                    if (_tw_method == SCRIBBLE_TYPEWRITER_PER_CHARACTER) _tw_pos = _scan_char + 1;
                }
                
                _scribble_array[@ __SCRIBBLE.EVENT_CHAR_PREVIOUS] = _scan_char;
                
                #endregion
            }
        }
        
        _scribble_array[@ __SCRIBBLE.TW_POSITION] = _tw_pos;
        
        //Update parameter values for character/line fades
        switch(_tw_method)
        {
            case SCRIBBLE_TYPEWRITER_WHOLE:
                _scribble_array[@ __SCRIBBLE.CHAR_FADE_T] = 1;
                _scribble_array[@ __SCRIBBLE.LINE_FADE_T] = 1;
            break;
            
            case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
                _scribble_array[@ __SCRIBBLE.CHAR_FADE_T] = ((_tw_direction < 0)? 1 : 0) + clamp(_tw_pos / _pos_max, 0, 1);
                _scribble_array[@ __SCRIBBLE.LINE_FADE_T] = 1;
            break;
            
            case SCRIBBLE_TYPEWRITER_PER_LINE:
                _scribble_array[@ __SCRIBBLE.CHAR_FADE_T] = 1;
                _scribble_array[@ __SCRIBBLE.LINE_FADE_T] = ((_tw_direction < 0)? 1 : 0) + clamp(_tw_pos / _pos_max, 0, 1);
            break;
        }
    }
}

#endregion



#region Draw this Scribble data structure

var _old_matrix = matrix_get(matrix_world);

if ((global.__scribble_state_xscale == 1)
&&  (global.__scribble_state_yscale == 1)
&&  (global.__scribble_state_angle  == 0))
{
    var _matrix = matrix_build(_scribble_array[__SCRIBBLE.LEFT] + _x, _scribble_array[__SCRIBBLE.TOP] + _y, 0,   0,0,0,   1,1,1);
}
else
{
    var _matrix = matrix_build(_scribble_array[__SCRIBBLE.LEFT], _scribble_array[__SCRIBBLE.TOP], 0,   0,0,0,   1,1,1);
        _matrix = matrix_multiply(_matrix, matrix_build(_x, _y, 0,
                                                        0, 0, global.__scribble_state_angle,
                                                        global.__scribble_state_xscale, global.__scribble_state_yscale, 1));
}

_matrix = matrix_multiply(_matrix, _old_matrix);
matrix_set(matrix_world, _matrix);

var _colour = (is_real(global.__scribble_state_colour) && (global.__scribble_state_colour >= 0))? global.__scribble_state_colour : draw_get_colour();
var _alpha  = (is_real(global.__scribble_state_alpha ) && (global.__scribble_state_alpha  >= 0))? global.__scribble_state_alpha  : draw_get_alpha();

var _time = _scribble_array[__SCRIBBLE.ANIMATION_TIME] + SCRIBBLE_STEP_SIZE;
_scribble_array[@ __SCRIBBLE.ANIMATION_TIME] = _time;

var _vbuff_list = _scribble_array[__SCRIBBLE.VERTEX_BUFFER_LIST];
var _count = ds_list_size(_vbuff_list);
if (_count > 0)
{
    var _data_fields     = _scribble_array[__SCRIBBLE.DATA_FIELDS];
    var _char_smoothness = 0;
    var _char_t          = 1;
    var _char_count      = _scribble_array[__SCRIBBLE.CHARACTERS];
    var _line_smoothness = 0;
    var _line_t          = 1;
    var _line_count      = _scribble_array[__SCRIBBLE.LINES];
    
    switch(_scribble_array[__SCRIBBLE.TW_METHOD])
    {
        case SCRIBBLE_TYPEWRITER_WHOLE:
            _alpha *= (_scribble_array[__SCRIBBLE.TW_DIRECTION] > 0)? _scribble_array[__SCRIBBLE.TW_POSITION] : (1.0 - _scribble_array[__SCRIBBLE.TW_POSITION]);
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            _char_smoothness = _scribble_array[__SCRIBBLE.TW_SMOOTHNESS] / _char_count;
            _char_t          = _scribble_array[__SCRIBBLE.CHAR_FADE_T];
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            _line_smoothness = _scribble_array[__SCRIBBLE.TW_SMOOTHNESS] / _line_count;
            _line_t          = _scribble_array[__SCRIBBLE.LINE_FADE_T];
        break;
    }
    
    shader_set(shScribble);
    shader_set_uniform_f(global.__scribble_uniform_time           , _time);
    
    shader_set_uniform_f(global.__scribble_uniform_char_t         , _char_t);
    shader_set_uniform_f(global.__scribble_uniform_char_smoothness, _char_smoothness);
    shader_set_uniform_f(global.__scribble_uniform_char_count     , _char_count);
    
    shader_set_uniform_f(global.__scribble_uniform_line_t         , _line_t);
    shader_set_uniform_f(global.__scribble_uniform_line_smoothness, _line_smoothness);
    shader_set_uniform_f(global.__scribble_uniform_line_count     , _line_count);
    
    shader_set_uniform_f(global.__scribble_uniform_colour_blend   , colour_get_red(  _colour)/255,
                                                                    colour_get_green(_colour)/255,
                                                                    colour_get_blue( _colour)/255,
                                                                    _alpha);
        
    shader_set_uniform_f_array(global.__scribble_uniform_data_fields, _data_fields);
    
    var _i = 0;
    repeat(_count)
    {
        var _vbuff_data = _vbuff_list[| _i];
        vertex_submit(_vbuff_data[__SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER], pr_trianglelist, _vbuff_data[__SCRIBBLE_VERTEX_BUFFER.TEXTURE]);
        _i++;
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
        var _string = global.__scribble_global_cache_list[| global.__scribble_cache_test_index];
        
        var _scribble_array = global.__scribble_global_cache_map[? _string];
        if (!scribble_exists(_scribble_array))
        {
            if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: \"" + _string + "\" exists in cache but doesn't exist elsewhere");
            ds_list_delete(global.__scribble_global_cache_list, global.__scribble_cache_test_index);
        }
        else if (_scribble_array[__SCRIBBLE.TIME] + SCRIBBLE_CACHE_TIMEOUT < current_time)
        {
            if (__SCRIBBLE_DEBUG) show_debug_message("Scribble: Removing \"" + _string + "\" from cache");
            scribble_free(_scribble_array);
            ds_map_delete(global.__scribble_global_cache_map, _string);
            ds_list_delete(global.__scribble_global_cache_list, global.__scribble_cache_test_index);
        }
    }
}

#endregion



return _scribble_array;