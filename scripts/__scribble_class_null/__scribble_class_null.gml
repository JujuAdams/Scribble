function __scribble_class_null() constructor
{
    #region Setters
    
    starting_format = function(_font_name, _colour) { return self; }
    align = function(_halign, _valign) { return self; }
    blend = function(_colour, _alpha) { return self; }
    transform = function(_xscale, _yscale, _angle) { return self; }
    origin = function(_x, _y) { return self; }
    wrap = function() { return self; }
    line_height = function(_min, _max) { return self; }
    template = function(_template) { return self; }
    page = function(_page) { return self; }
    animation = function(_property, _value) { return self; }
    fog = function(_colour, _alpha) { return self; }
    ignore_command_tags = function(_state) { return self; }
    bezier = function() { return self; }
    reset = function() { return self; }
    
    #endregion
    
    #region Typewriter Setters
    
    typewriter_off = function() { return self; }
    typewriter_in = function(_speed, _smoothness) { return self; }
    typewriter_out = function(_speed, _smoothness) { return self; }
    typewriter_sound = function(_sound_array, _overlap, _pitch_min, _pitch_max) { return self; }
    typewriter_sound_per_char = function(_sound_array, _pitch_min, _pitch_max) { return self; }
    typewriter_function = function(_function) { return self; }
    typewriter_pause = function() { return self; }
    typewriter_unpause = function() { return self; }
    
    #endregion
    
    #region Getters
    
    get_bbox = function(_x, _y) {
        return { left:   _x,
                 top:    _y,
                 right:  _x,
                 bottom: _y,
                 
                 width:  0,
                 height: 0,
                 
                 x0: _x, y0: _y,
                 x1: _x, y1: _y,
                 x2: _x, y2: _y,
                 x3: _x, y3: _y };
    }
    
    get_width = function() { return 0; }
    get_height = function() { return 0;}
    get_page = function() { return 0; }
    get_pages = function() { return 0; }
    get_typewriter_state = function() { return 1.0; }
    get_typewriter_paused = function() { return false; }
    
    #endregion
    
    #region Public Methods
    
    draw = function(_x, _y) { return self; }
    flush_now = function() { return self; }
    cache_now = function(_freeze) { return self; }
    
    #endregion
}