/// @param name
/// @param startColour
/// @param gradientArray

function scribble_cycle_create(_name, _start_colour, _gradient_array)
{
    static _scribble_state = __scribble_get_state();
    
    var _surface = _scribble_state.__cycle_surface;
    if (!surface_exists(_surface))
    {
        _surface = surface_create(SCRIBBLE_CYCLE_ACCURACY, 1+SCRIBBLE_CYCLE_COUNT);
        _scribble_state.__cycle_surface = _surface;
        
        surface_set_target(_surface);
        draw_clear(c_white);
        surface_reset_target();
        
        _scribble_state.__cycle_texture = surface_get_texture(_surface);
    }
    
    var _open_array = _scribble_state.__cycle_open_array;
    if (array_length(_open_array) <= 0) __scribble_error("No room for new cycle definitions. Please increase SCRIBBLE_CYCLE_COUNT");
    
    var _y = array_pop(_open_array);
    _scribble_state.__cycle_struct[$ _name] = {
        __name:         _name,
        __y:            _y,
        __v:            (_y+0.5) / (1+SCRIBBLE_CYCLE_COUNT),
        __start_colour: _start_colour,
        __array:        _gradient_array,
    };
    
    surface_set_target(_surface);
    shader_set(__shd_scribble_oklab_interpolate);
    
    var _prev_x      = 0;
    var _prev_colour = _start_colour;
    
    var _i = 0;
    repeat(array_length(_gradient_array) div 2)
    {
        var _x      = SCRIBBLE_CYCLE_ACCURACY*clamp(_gradient_array[_i], 0, 1);
        var _colour = _gradient_array[_i+1];
        
        draw_sprite_general(__scribble_white_pixel, 0, 0, 0, 1, 1, _prev_x, _y, _x - _prev_x, 1, 0, _prev_colour, _colour, _colour, _prev_colour, 1);
        
        _prev_x      = _x;
        _prev_colour = _colour;
        
        _i += 2;
    }
    
    draw_sprite_general(__scribble_white_pixel, 0, 0, 0, 1, 1, _prev_x, _y, SCRIBBLE_CYCLE_ACCURACY - _prev_x, 1, 0, _prev_colour, _start_colour, _start_colour, _prev_colour, 1);
    
    surface_save(_surface, "cycle.png");
    
    surface_reset_target();
    shader_reset();
}