function __scribble_gen_1_model_limits_and_bezier_curves()
{
    var _element = global.__scribble_generator_state.__element;
    
    var _model_max_width = _element.__wrap_max_width - (_element.__padding_l + _element.__padding_r);
    if (_model_max_width < 0) _model_max_width = infinity;
    
    var _model_max_height = _element.__wrap_max_height - (_element.__padding_t + _element.__padding_b);
    if (_model_max_height < 0) _model_max_height = infinity;
    
    //TODO - Cache Bezier curves
    
    //Make a copy of the Bezier array
    var _element_bezier_array = _element.__bezier_array;
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
        
        if (_model_max_width >= 0) __scribble_trace("Warning! Maximum width set by scribble_set_wrap() (" + string(_model_max_width) + ") has been replaced with Bezier curve length (" + string(_dist) + "). Use -1 as the maximum width to turn off this warning");
        _model_max_width = _dist;
        
        global.__scribble_generator_state.__bezier_lengths_array = _bezier_lengths;
    }
    
    //Set up line height limits
    var _element = global.__scribble_generator_state.__element;
    var _line_height_min = _element.__line_height_min;
    var _line_height_max = _element.__line_height_max;
    
    if (_line_height_min < 0) _line_height_min = 1;
    if (_line_height_max < 0) _line_height_max = infinity;
    
    var _line_spacing_raw = _element.__line_spacing;
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
    
    with(global.__scribble_generator_state)
    {
        __model_max_width  = _model_max_width;
        __model_max_height = _model_max_height;
        
        __line_height_min = _line_height_min;
        __line_height_max = _line_height_max;
        
        __line_spacing_add      = _line_spacing_add;
        __line_spacing_multiply = _line_spacing_multiply;
    }
}