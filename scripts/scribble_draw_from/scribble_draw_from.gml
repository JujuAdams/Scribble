/// Draws a Scribble data structure created with scribble_create()
///
/// @param json                 The Scribble data structure to be drawn. See scribble_create()
/// @param [x]                  The x position in the room to draw at. Defaults to 0
/// @param [y]                  The y position in the room to draw at. Defaults to 0
/// @param [xscale]             The horizontal scaling of the text. Defaults to the value set in __scribble_config()
/// @param [yscale]             The vertical scaling of the text. Defaults to the value set in __scribble_config()
/// @param [angle]              The rotation of the text. Defaults to the value set in __scribble_config()
/// @param [colour]             The blend colour for the text. Defaults to draw_get_colour()
/// @param [alpha]              The alpha blend for the text. Defaults to draw_get_alpha()
/// @param [premultiplyAlpha]   Whether to multiply the RGB channels by the resulting alpha value in the shader. Useful for fixing blending defects
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _json   = argument[0];
var _x      = argument[1];
var _y      = argument[2];
var _xscale = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 1;
var _yscale = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 1;
var _angle  = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
var _colour = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : draw_get_colour();
var _alpha  = ((argument_count > 7) && (argument[7] != undefined))? argument[7] : draw_get_alpha();
var _pma    = ((argument_count > 8) && (argument[8] != undefined))? argument[8] : false;

if (!is_real(_json) || !ds_exists(_json, ds_type_list))
{
    show_error("Scribble:\nScribble data structure \"" + string(_json) + "\" doesn't exist!\n ", false);
    exit;
}

#region Handle typewriter

_json[| SCRIBBLE.ANIMATION_TIME] += SCRIBBLE_STEP_SIZE;

var _typewriter_direction = _json[| SCRIBBLE.TW_DIRECTION];
if (_typewriter_direction != 0)
{
    var _do_event_scan = false;
    var _scan_range_b = _json[| SCRIBBLE.EV_SCAN_B];
    
    var _tw_pos   = _json[| SCRIBBLE.TW_POSITION];
    var _tw_speed = _json[| SCRIBBLE.TW_SPEED   ];
    _tw_speed *= SCRIBBLE_STEP_SIZE;
    
    switch(_json[| SCRIBBLE.TW_METHOD])
    {
        case SCRIBBLE_TYPEWRITER_WHOLE:
            _do_event_scan = false;
            
            if (_typewriter_direction > 0)
            {
                if (floor(_tw_pos) < floor(_tw_pos + _tw_speed))
                {
                    var _scan_range_b = _json[| SCRIBBLE.LENGTH];
                    _do_event_scan = true;
                }
            }
            
            _tw_pos += _tw_speed;
            _tw_pos = clamp(_tw_pos, 0, 1);
            _json[| SCRIBBLE.TW_POSITION] = _tw_pos;
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            if (_typewriter_direction > 0)
            {
                _do_event_scan = true;
                var _scan_range_b = _tw_pos + _tw_speed;
            }
            
            var _length = _json[| SCRIBBLE.LENGTH];
            _tw_pos += _tw_speed;
            _tw_pos = min(_tw_pos, _length);
            
            _json[| SCRIBBLE.TW_POSITION] = _tw_pos;
            _json[| SCRIBBLE.CHAR_FADE_T] = ((_typewriter_direction < 0)? 1 : 0) + clamp(_tw_pos / _length, 0, 1);
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            var _lines = _json[| SCRIBBLE.LINES];
            
            if (_typewriter_direction > 0)
            {
                var _list = _json[| SCRIBBLE.LINE_LIST];
                if (floor(_tw_pos) > floor(_tw_pos - _tw_speed))
                {
                    var _line_b = _list[| min(floor(_tw_pos + _tw_speed), _lines-1)];
                    var _scan_range_b = _line_b[__SCRIBBLE_LINE.LAST_CHAR];
                    _do_event_scan = true;
                }
            }
            
            _tw_pos += _tw_speed;
            _tw_pos = min(_tw_pos, _lines);
            
            _json[| SCRIBBLE.TW_POSITION] = _tw_pos;
            _json[| SCRIBBLE.LINE_FADE_T] = ((_typewriter_direction < 0)? 1 : 0) + clamp(_tw_pos / _lines, 0, 1);
        break;
        
        default:
            show_error("Scribble:\nTypewriter method not recognised.\nPlease use SCRIBBLE_TYPEWRITER_PER_CHARACTER or SCRIBBLE_TYPEWRITER_PER_LINE.\n ", false);
        break;
    }
    
    _json[| SCRIBBLE.EV_SCAN_DO] = _do_event_scan;
    _json[| SCRIBBLE.EV_SCAN_B ] = _scan_range_b;
}

#endregion

var _old_matrix = matrix_get(matrix_world);

if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
{
    var _matrix = matrix_build(_json[| SCRIBBLE.LEFT] + _x, _json[| SCRIBBLE.TOP] + _y, 0,   0,0,0,   1,1,1);
}
else
{
    var _matrix = matrix_build(_json[| SCRIBBLE.LEFT], _json[| SCRIBBLE.TOP], 0,   0,0,0,   1,1,1);
        _matrix = matrix_multiply(_matrix, matrix_build(_x,_y,0,   0,0,_angle,   _xscale,_yscale,1));
}

_matrix = matrix_multiply(_matrix, _old_matrix);
matrix_set(matrix_world, _matrix);

var _vbuff_list = _json[| SCRIBBLE.VERTEX_BUFFER_LIST];

var _count = ds_list_size(_vbuff_list);
if (_count > 0)
{
    var _time            = _json[| SCRIBBLE.ANIMATION_TIME];
    var _data_fields     = _json[| SCRIBBLE.DATA_FIELDS   ];
    var _char_smoothness = 0;
    var _char_t          = 1;
    var _char_count      = _json[| SCRIBBLE.LENGTH];
    var _line_smoothness = 0;
    var _line_t          = 1;
    var _line_count      = _json[| SCRIBBLE.LINES];
    
    switch(_json[| SCRIBBLE.TW_METHOD])
    {
        case SCRIBBLE_TYPEWRITER_WHOLE:
            _alpha *= (_json[| SCRIBBLE.TW_DIRECTION] > 0)? _json[| SCRIBBLE.TW_POSITION] : (1.0 - _json[| SCRIBBLE.TW_POSITION]);
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            _char_smoothness = _json[| SCRIBBLE.TW_SMOOTHNESS] / _char_count;
            _char_t          = _json[| SCRIBBLE.CHAR_FADE_T  ];
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            _line_smoothness = _json[| SCRIBBLE.TW_SMOOTHNESS] / _line_count;
            _line_t          = _json[| SCRIBBLE.LINE_FADE_T  ];
        break;
    }
    
    shader_set(shScribble);
    shader_set_uniform_f(global.__scribble_uniform_pma            , _pma);
    shader_set_uniform_f(global.__scribble_uniform_time           , _time);
    
    shader_set_uniform_f(global.__scribble_uniform_char_t         , _char_t);
    shader_set_uniform_f(global.__scribble_uniform_char_smoothness, _char_smoothness);
    shader_set_uniform_f(global.__scribble_uniform_char_count     , _char_count);
    
    shader_set_uniform_f(global.__scribble_uniform_line_t         , _line_t);
    shader_set_uniform_f(global.__scribble_uniform_line_smoothness, _line_smoothness);
    shader_set_uniform_f(global.__scribble_uniform_line_count     , _line_count);
    
    shader_set_uniform_f(global.__scribble_uniform_z              , SCRIBBLE_Z);
    
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