function __scribble_class_null_element() constructor
{
    #region Setters
    
    static overwrite = function(_string) { return self; }
    static starting_format = function(_font_name, _colour) { return self; }
    static align = function(_halign, _valign) { return self; }
    static blend = function(_colour, _alpha) { return self; }
    static transform = function(_xscale, _yscale, _angle) { return self; }
    static origin = function(_x, _y) { return self; }
    static wrap = function() { return self; }
    static fit_to_box = function() { return self; }
    static line_height = function(_min, _max) { return self; }
    static template = function(_template) { return self; }
    static page = function(_page) { return self; }
    static fog = function(_colour, _alpha) { return self; }
    static ignore_command_tags = function(_state) { return self; }
    static bezier = function() { return self; }
    
    #endregion
    
    #region Typewriter Setters
    
    static typewriter_off = function() { return self; }
    static typewriter_reset = function() { return self; }
    static typewriter_in = function(_speed, _smoothness) { return self; }
    static typewriter_out = function(_speed, _smoothness, _backwards) { return self; }
    static typewriter_skip = function() { return self; }
    static typewriter_sound = function(_sound_array, _overlap, _pitch_min, _pitch_max) { return self; }
    static typewriter_sound_per_char = function(_sound_array, _pitch_min, _pitch_max) { return self; }
    static typewriter_function = function(_function) { return self; }
    static typewriter_pause = function() { return self; }
    static typewriter_unpause = function() { return self; }
    static typewriter_ease = function(_ease_method, _dx, _dy, _xscale, _yscale, _rotation, _alpha_duration) { return self; }
    
    #endregion
    
    #region Animation
    
    static animation_tick_speed = function(_speed) { return self; }
    static animation_sync = function(_source_element) { return self; }
    static animation_wave = function(_size, _frequency, _speed) { return self; }
    static animation_shake = function(_size, _speed) { return self; }
    static animation_rainbow = function(_weight, _speed) { return self; }
    static animation_wobble = function(_angle, _frequency) { return self; }
    static animation_pulse = function(_scale, _speed) { return self; }
    static animation_wheel = function(_size, _frequency, _speed) { return self; }
    static animation_cycle = function(_speed, _saturation, _value) { return self; }
    static animation_jitter = function(_min, _max, _speed) { return self; }
    static animation_blink = function(_on, _off, _offset) { return self; }
    
    #endregion
    
    #region MSDF
    
    static msdf_shadow = function(_colour, _alpha, _x_offset, _y_offset) { return self; }
    static msdf_border = function(_colour, _thickness) { return self; }
    static msdf_feather = function(_thickness) { return self; }
    
    #endregion
    
    #region Getters
    
    static get_bbox = function(_x, _y) {
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
    
    static get_width = function() { return 0; }
    static get_height = function() { return 0;}
    static get_page = function() { return 0; }
    static get_pages = function() { return 0; }
	static get_page_height = function() { return 0; }
	static get_page_width = function() { return 0; }
    static on_last_page = function() { return true; }
    static get_typewriter_state = function() { return 1.0; }
    static get_typewriter_paused = function() { return false; }
    static get_typewriter_pos = function() { return 0; }
    static get_wrapped = function() { return false; }
    static get_line_count = function() { return 0; }
    static get_ltrb_array = function() { return undefined; }
    
    #endregion
    
    #region Public Methods
    
    static draw = function(_x, _y) { return undefined; }
    static flush = function() { return undefined; }
    static build = function(_freeze) { return undefined; }
    
    #endregion
}