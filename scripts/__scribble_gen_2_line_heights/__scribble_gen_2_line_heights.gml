function __scribble_gen_2_line_heights()
{
    //Set up line height limits
    var _element = global.__scribble_generator_state.element;
    var _line_height_min = _element.line_height_min;
    var _line_height_max = _element.line_height_max;
    
    if (_line_height_min < 0) _line_height_min = 1;
    if (_line_height_max < 0) _line_height_max = infinity;
    
    with(global.__scribble_generator_state)
    {
        line_height_min = _line_height_min;
        line_height_max = _line_height_max;
    }
}