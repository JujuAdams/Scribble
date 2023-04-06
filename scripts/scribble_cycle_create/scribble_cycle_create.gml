/// @param name
/// @param startColour
/// @param gradientArray

function scribble_cycle_create(_name, _start_colour, _gradient_array)
{
    static _scribble_state = __scribble_get_state();
    static _open_array = _scribble_state.__cycle_open_array;
    static _cycle_dict = _scribble_state.__cycle_dict;
    
    if (array_length(_open_array) <= 0) __scribble_error("No room for new cycle definitions. Please increase SCRIBBLE_CYCLE_COUNT");
    if (variable_struct_exists(_cycle_dict, _name)) __scribble_trace("Warning! Overwriting cycle \"", _name, "\"");
    
    var _y = array_pop(_open_array);
    _cycle_dict[$ _name] = {
        __name:         _name,
        __y:            _y,
        __v:            (_y+0.5) / (1+SCRIBBLE_CYCLE_COUNT),
        __start_colour: _start_colour,
        __array:        _gradient_array,
    };
    
    surface_set_target(__scribble_ensure_cycle_surface());
    shader_set(__shd_scribble_oklab_interpolate);
    __scribble_render_cycle_texture(_name);
    shader_reset();
    surface_reset_target();
}

function __scribble_ensure_cycle_surface()
{
    static _scribble_state = __scribble_get_state();
    static _cycle_dict = _scribble_state.__cycle_dict;
    
    var _surface = _scribble_state.__cycle_surface;
    
    if (!surface_exists(_surface))
    {
        __scribble_trace("Warning! Cycle texture doesn't exist, generating it");
        
        _surface = surface_create(SCRIBBLE_CYCLE_ACCURACY, 1+SCRIBBLE_CYCLE_COUNT);
        _scribble_state.__cycle_surface = _surface;
        
        surface_set_target(_surface);
        draw_clear(c_white);
        
        var _old_shader = shader_current();
        shader_set(__shd_scribble_oklab_interpolate);
        
        var _names_array = variable_struct_get_names(_cycle_dict);
        var _i = 0;
        repeat(array_length(_names_array))
        {
            __scribble_render_cycle_texture(_names_array[_i]);
            ++_i;
        }
        
        if (_old_shader < 0)
        {
            shader_reset();
        }
        else
        {
            shader_set(_old_shader);
        }
        
        surface_reset_target();
    }
    
    return _surface;
}

function __scribble_render_cycle_texture(_name)
{
    static _scribble_state = __scribble_get_state();
    static _cycle_dict = _scribble_state.__cycle_dict;
    
    with(_cycle_dict[$ _name])
    {
        var _prev_x      = 0;
        var _prev_colour = __start_colour;
        
        var _i = 0;
        repeat(array_length(__array) div 2)
        {
            var _x      = SCRIBBLE_CYCLE_ACCURACY*clamp(__array[_i], 0, 1);
            var _colour = __array[_i+1];
            
            draw_sprite_general(__scribble_white_pixel, 0, 0, 0, 1, 1, _prev_x, __y, _x - _prev_x, 1, 0, _prev_colour, _colour, _colour, _prev_colour, 1);
            
            _prev_x      = _x;
            _prev_colour = _colour;
            
            _i += 2;
        }
        
        draw_sprite_general(__scribble_white_pixel, 0, 0, 0, 1, 1, _prev_x, __y, SCRIBBLE_CYCLE_ACCURACY - _prev_x, 1, 0, _prev_colour, __start_colour, __start_colour, _prev_colour, 1);
    }
    
}