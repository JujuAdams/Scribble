/// Draws text using Scribble's formatting.
/// 
/// 
/// @param x                         The x position in the room to draw at.
/// @param y                         The y position in the room to draw at.
/// @param string_or_scribbleArray   The text to be drawn. See below for formatting help. (Advanced users can use this script to manually draw Scribble data structures.)
/// @param [cacheGroup]              Advanced use only. See scribble_create() for more information. Please use scribble_create() if you wish to use an <undefined> cache group.
/// 
/// 
/// Formatting commands:
/// []                                  Reset formatting to defaults
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
/// [<flag name>] [/<flag name>]        Set/unset a custom shader format flag
/// 
/// Scribble has the following formatting flags as defaults:
/// [wave]    [/wave]                   Set/unset text to wave up and down
/// [shake]   [/shake]                  Set/unset text to shake
/// [rainbow] [/rainbow]                Set/unset text to cycle through rainbow colours

var _x           = argument[0];
var _y           = argument[1];
var _string      = argument[2];
var _cache_group = (argument_count > 3)? argument[3] : SCRIBBLE_DEFAULT_CACHE_GROUP;



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
    if (_cache_group == undefined)
    {
        show_error("Scribble:\n<undefined> cache group not permitted in scribble_draw().\nPlease use scribble_create().\n ", false);
        _cache_group = SCRIBBLE_DEFAULT_CACHE_GROUP;
    }
    
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
        var _scribble_array = scribble_create(_string, _cache_group);
    }
}



#region Unpack state variables

var _tw_direction  = _scribble_array[__SCRIBBLE.TW_DIRECTION];
var _tw_fade_in    = is_real(global.__scribble_state_tw_fade_in   )? global.__scribble_state_tw_fade_in    : _tw_direction;
var _tw_method     = is_real(global.__scribble_state_tw_method    )? global.__scribble_state_tw_method     : _scribble_array[__SCRIBBLE.TW_METHOD    ];
var _tw_speed      = is_real(global.__scribble_state_tw_speed     )? global.__scribble_state_tw_speed      : _scribble_array[__SCRIBBLE.TW_SPEED     ];
var _tw_smoothness = is_real(global.__scribble_state_tw_smoothness)? global.__scribble_state_tw_smoothness : _scribble_array[__SCRIBBLE.TW_SMOOTHNESS];
var _xscale        = is_real(global.__scribble_state_xscale       )? global.__scribble_state_xscale        : _scribble_array[__SCRIBBLE.XSCALE       ];
var _yscale        = is_real(global.__scribble_state_yscale       )? global.__scribble_state_yscale        : _scribble_array[__SCRIBBLE.YSCALE       ];
var _angle         = is_real(global.__scribble_state_angle        )? global.__scribble_state_angle         : _scribble_array[__SCRIBBLE.ANGLE        ];
var _colour        = is_real(global.__scribble_state_colour       )? global.__scribble_state_colour        : _scribble_array[__SCRIBBLE.BLEND_COLOUR ];
var _alpha         = is_real(global.__scribble_state_alpha        )? global.__scribble_state_alpha         : _scribble_array[__SCRIBBLE.ALPHA        ];
var _box_halign    = is_real(global.__scribble_state_box_halign   )? global.__scribble_state_box_halign    : _scribble_array[__SCRIBBLE.HALIGN       ];
var _box_valign    = is_real(global.__scribble_state_box_valign   )? global.__scribble_state_box_valign    : _scribble_array[__SCRIBBLE.VALIGN       ];

var _left = 0;
var _top  = 0;

switch(_box_halign)
{
    case fa_center: _left = -_scribble_array[__SCRIBBLE.WIDTH] div 2; break;
    case fa_right:  _left = -_scribble_array[__SCRIBBLE.WIDTH];       break;
}

switch(_box_valign)
{
    case fa_middle: _top = -_scribble_array[__SCRIBBLE.HEIGHT] div 2; break;
    case fa_bottom: _top = -_scribble_array[__SCRIBBLE.HEIGHT];       break;
}

#endregion



#region Handle triggering typewriter

//If needed, trigger the fade out typewriter behaviour
if (_tw_direction == 0)
{
    //If directed to, start a fade in
    if (_tw_fade_in)
    {
        _tw_direction = 1;
        _scribble_array[@ __SCRIBBLE.TW_DIRECTION] = 1;
        _scribble_array[@ __SCRIBBLE.TW_POSITION ] = 0;
        _scribble_array[@ __SCRIBBLE.CHAR_FADE_T ] = (_tw_method != SCRIBBLE_TYPEWRITER_PER_CHARACTER);
        _scribble_array[@ __SCRIBBLE.LINE_FADE_T ] = (_tw_method != SCRIBBLE_TYPEWRITER_PER_LINE);
    }
}
else
{
    //If we're actively running the typewriter...
    if (_tw_fade_in)
    {
        //If directed to, try to start a fade in
        if (scribble_get_typewriter_position(_scribble_array) == 2.0)
        {
            _tw_direction = 1;
            _scribble_array[@ __SCRIBBLE.TW_DIRECTION] = 1;
            _scribble_array[@ __SCRIBBLE.TW_POSITION ] = 0;
            _scribble_array[@ __SCRIBBLE.CHAR_FADE_T ] = (_tw_method != SCRIBBLE_TYPEWRITER_PER_CHARACTER);
            _scribble_array[@ __SCRIBBLE.LINE_FADE_T ] = (_tw_method != SCRIBBLE_TYPEWRITER_PER_LINE);
        }
    }
    else
    {
        //Otherwise wait until the typewriter 
        if (scribble_get_typewriter_position(_scribble_array) == 1.0)
        {
            _tw_direction = -1;
            _scribble_array[@ __SCRIBBLE.TW_DIRECTION] = -1;
            _scribble_array[@ __SCRIBBLE.TW_POSITION ] =  0;
            _scribble_array[@ __SCRIBBLE.CHAR_FADE_T ] =  1;
            _scribble_array[@ __SCRIBBLE.LINE_FADE_T ] =  1;
        }
    }
}

#endregion



#region If we're actively running the typewriter, step through

if (_tw_direction != 0)
{
    _tw_speed *= SCRIBBLE_STEP_SIZE;
    if (_tw_speed > 0)
    {
        #region Advance typewriter
        
        var _tw_pos  = _scribble_array[__SCRIBBLE.TW_POSITION];
        var _pos_max = 1.0;
        var _scan_a  = -1;
        var _scan_b  = -1;
        
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

if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
{
    var _matrix = matrix_build(_left + _x, _top + _y, 0,   0,0,0,   1,1,1);
}
else
{
    var _matrix = matrix_build(_left, _top, 0,   0,0,0,   1,1,1);
        _matrix = matrix_multiply(_matrix, matrix_build(_x,_y,0,   0,0,_angle,   _xscale,_yscale,1));
}

_matrix = matrix_multiply(_matrix, _old_matrix);
matrix_set(matrix_world, _matrix);

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
            _alpha *= (_tw_direction > 0)? _scribble_array[__SCRIBBLE.TW_POSITION] : (1.0 - _scribble_array[__SCRIBBLE.TW_POSITION]);
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            _char_smoothness = _tw_smoothness / _char_count;
            _char_t          = _scribble_array[__SCRIBBLE.CHAR_FADE_T];
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            _line_smoothness = _tw_smoothness / _line_count;
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
        ++_i;
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