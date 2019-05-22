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
var _x      = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : 0;
var _y      = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : 0;
var _xscale = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : SCRIBBLE_DEFAULT_XSCALE;
var _yscale = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : SCRIBBLE_DEFAULT_YSCALE;
var _angle  = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : SCRIBBLE_DEFAULT_ANGLE;
var _colour = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : draw_get_colour();
var _alpha  = ((argument_count > 7) && (argument[7] != undefined))? argument[7] : draw_get_alpha();
var _pma    = ((argument_count > 8) && (argument[8] != undefined))? argument[8] : SCRIBBLE_DEFAULT_PREMULTIPLY_ALPHA;

if (!is_real(_json) || !ds_exists(_json, ds_type_list))
{
    show_error("Scribble:\nScribble data structure \"" + string(_json) + "\" doesn't exist!\n ", false);
    exit;
}

#region Check if we should've called scribble_step() for this Scribble data structure

if ((_json[| __SCRIBBLE.TW_DIRECTION ] != 0) && (ds_list_size(_json[| __SCRIBBLE.EV_CHARACTER_LIST ]) > 0))
{
    if ( !_json[| __SCRIBBLE.HAS_CALLED_STEP])
    {
        if (SCRIBBLE_CALL_STEP_IN_DRAW)
        {
            scribble_step( _json);
        }
        else
        {
            if (_json[| __SCRIBBLE.NO_STEP_COUNT] >= 1) //Give GM one frame of grace before throwing an error
            {
                show_error("Scribble:\nscribble_step() must be called in the Step event for events and typewriter effects to work.\n ", false);
            }
            else
            {
                _json[| __SCRIBBLE.NO_STEP_COUNT]++;
            }
        }
    }
}

#endregion

var _old_matrix = matrix_get(matrix_world);

if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
{
    var _matrix = matrix_build(_json[| __SCRIBBLE.LEFT] + _x, _json[| __SCRIBBLE.TOP] + _y, 0,   0,0,0,   1,1,1);
}
else
{
    var _matrix = matrix_build(_json[| __SCRIBBLE.LEFT], _json[| __SCRIBBLE.TOP], 0,   0,0,0,   1,1,1);
        _matrix = matrix_multiply(_matrix, matrix_build(_x,_y,0,   0,0,_angle,   _xscale,_yscale,1));
}

_matrix = matrix_multiply(_matrix, _old_matrix);
matrix_set(matrix_world, _matrix);

var _vbuff_list = _json[| __SCRIBBLE.VERTEX_BUFFER_LIST ];

var _count = ds_list_size(_vbuff_list);
if (_count > 0)
{
    var _time            = _json[| __SCRIBBLE.ANIMATION_TIME];
    var _data_fields     = _json[| __SCRIBBLE.DATA_FIELDS   ];
    var _char_smoothness = 0;
    var _char_t          = 1;
    var _line_smoothness = 0;
    var _line_t          = 1;
    
    switch(_json[| __SCRIBBLE.TW_METHOD])
    {
        case SCRIBBLE_TYPEWRITER_WHOLE:
            _alpha *= (_json[| __SCRIBBLE.TW_DIRECTION] > 0)? _json[| __SCRIBBLE.TW_POSITION] : (1.0 - _json[| __SCRIBBLE.TW_POSITION]);
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_CHARACTER:
            _char_smoothness = _json[| __SCRIBBLE.TW_SMOOTHNESS] / _json[| __SCRIBBLE.LENGTH];
            _char_t          = _json[| __SCRIBBLE.CHAR_FADE_T] * _json[| __SCRIBBLE.LENGTH];
        break;
        
        case SCRIBBLE_TYPEWRITER_PER_LINE:
            _line_smoothness = _json[| __SCRIBBLE.TW_SMOOTHNESS] / _json[| __SCRIBBLE.LINES];
            _line_t          = _json[| __SCRIBBLE.LINE_FADE_T] * _json[| __SCRIBBLE.LINES];
        break;
    }
    
    shader_set(shScribble);
    shader_set_uniform_f(global.__scribble_uniform_pma            , _pma);
    shader_set_uniform_f(global.__scribble_uniform_time           , _time);
    
    shader_set_uniform_f(global.__scribble_uniform_char_t         , _char_t);
    shader_set_uniform_f(global.__scribble_uniform_char_smoothness, _char_smoothness);
    
    shader_set_uniform_f(global.__scribble_uniform_line_t         , _line_t);
    shader_set_uniform_f(global.__scribble_uniform_line_smoothness, _line_smoothness);
    
    shader_set_uniform_f(global.__scribble_uniform_colour_blend   , colour_get_red(  _colour)/255,
                                                                    colour_get_green(_colour)/255,
                                                                    colour_get_blue( _colour)/255,
                                                                    _alpha);
        
    shader_set_uniform_f_array(global.__scribble_uniform_data_fields, _data_fields);
    
    var _i = 0;
    repeat(_count)
    {
        var _vbuff_data = _vbuff_list[| _i];
        vertex_submit(_vbuff_data[| __SCRIBBLE_VERTEX_BUFFER.VERTEX_BUFFER], pr_trianglelist, _vbuff_data[| __SCRIBBLE_VERTEX_BUFFER.TEXTURE]);
        _i++;
    }
    
    shader_reset();
}

matrix_set(matrix_world, _old_matrix);