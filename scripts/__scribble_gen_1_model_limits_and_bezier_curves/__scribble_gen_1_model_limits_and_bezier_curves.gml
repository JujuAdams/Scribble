// Feather disable all
function __scribble_gen_1_model_limits_and_bezier_curves()
{
    static _generator_state = __scribble_system().__generator_state;
    
    var _modelMaxWidth = __layoutMaxWidth - (__padding_l + __padding_r);
    if (_modelMaxWidth < 0) _modelMaxWidth = infinity;
    
    var _modelMaxHeight = __layoutMaxHeight - (__padding_t + __padding_b);
    if (_modelMaxHeight < 0) _modelMaxHeight = infinity;
    
    //TODO - Cache Bezier curves
    
    //Make a copy of the Bezier array
    var _element_bezier_array = __bezier_array;
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
        
        if ((_modelMaxWidth >= 0) && !is_infinity(_modelMaxWidth)) __scribble_trace("Warning! Maximum width (" + string(_modelMaxWidth) + ") has been replaced with Bezier curve length (" + string(_dist) + "). Use -1 as the maximum width to turn off this warning");
        _modelMaxWidth = _dist;
        
        _generator_state.__bezier_lengths_array = _bezier_lengths;
    }
    
    //Set up line height limits
    var _line_spacing_raw = __line_spacing;
    if (is_string(_line_spacing_raw))
    {
        var _length = string_length(_line_spacing_raw);
        if (string_char_at(_line_spacing_raw, _length) == "%")
        {
            try
            {
                var _line_spacing_add      = 0;
                var _line_spacing_multiply = real(string_copy(_line_spacing_raw, 1, _length-1)) / 100;
            }
            catch(_error)
            {
                __scribble_trace(_error);
                __scribble_error("Could not parse line spacing \"", _line_spacing_raw, "\"\nLine spacing must be number or percentage strings e.g. \"200%\"");
            }
        }
        else
        {
            __scribble_error("Could not parse line spacing \"", _line_spacing_raw, "\"\nLine spacing must be number or percentage strings e.g. \"200%\"");
        }
    }
    else
    {
        var _line_spacing_add      = _line_spacing_raw;
        var _line_spacing_multiply = 0;
    }
    
    with(_generator_state)
    {
        __modelMaxWidth  = _modelMaxWidth;
        __modelMaxHeight = _modelMaxHeight;
        
        __line_height = other.__element_line_height;
        
        __line_spacing_add      = _line_spacing_add;
        __line_spacing_multiply = _line_spacing_multiply;
    }
}
