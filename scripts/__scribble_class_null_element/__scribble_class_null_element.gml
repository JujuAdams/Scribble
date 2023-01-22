function __scribble_class_null_element() constructor
{
    static __error = function()
    {
        __scribble_error("Cannot call text element methods using the result from .draw()\nThis can occur in two situations:\n  1. scribble().draw().method();\n  2. t = scribble().draw(); t.method()\n\nInstead use:\n  1. scribble().method().draw();\n  2. t = scribble(); t.method(); t.draw();");
    }
    
    
    
    #region Basics
    
    static draw = function()
    {
        __error();
    }
    
    static starting_format = function()
    {
        __error();
    }
    
    static align = function()
    {
        __error();
    }
    
    static blend = function()
    {
        __error();
    }
    
    static gradient = function()
    {
        __error();
    }
    
    static fog = function()
    {
        __error();
    }
    
    static flash = function()
    {
        __error();
    }
    
    #endregion
    
    
    
    #region Layout
    
    static origin = function()
    {
        __error();
    }
    
    static transform = function()
    {
        __error();
    }
    
    static skew = function()
    {
        __error();
    }
    
    static scale_to_box = function()
    {
        __error();
    }
    
    static wrap = function()
    {
        __error();
    }
    
    static fit_to_box = function()
    {
        __error();
    }
    
    static pin_guide_width = function()
    {
        __error();
    }
    
    static line_height = function()
    {
        __error();
    }
    
    static line_spacing = function()
    {
        __error();
    }
    
    static padding = function()
    {
        __error();
    }
    
    static bezier = function()
    {
        __error();
    }
    
    static right_to_left = function()
    {
        __error();
    }
    
    #endregion
    
    
    
    #region Regions
    
    static region_detect = function()
    {
    }
    
    static region_set_active = function()
    {
    }
    
    static region_get_active = function()
    {
        __error();
    }
    
    #endregion
    
    
    
    #region Dimensions
    
    static __update_bbox_matrix = function()
    {
        __error();
    }
    
    static get_left = function()
    {
        __error();
    }
    
    static get_top = function()
    {
        __error();
    }
    
    static get_right = function()
    {
        __error();
    }
    
    static get_bottom = function()
    {
        __error();
    }
    
    static get_width = function()
    {
        __error();
    }
    
    static get_height = function()
    {
        __error();
    }
    
    static get_bbox = function()
    {
        __error();
    }
    
    static get_bbox_revealed = function()
    {
        __error();
    }
    
    #endregion
    
    
    
    #region Pages
    
    static page = function()
    {
        __error();
    }
    
    static get_page = function()
    {
        __error();
    }
    
    static get_pages = function()
    {
        __error();
    }
    
    static get_page_count = function()
    {
        __error();
    }
    
    static on_last_page = function()
    {
        __error();
    }
    
    #endregion
    
    
    
    #region Other Getters
    
    static get_wrapped = function()
    {
        __error();
    }
    
    static get_text = function()
    {
        __error();
    }
    
    static get_glyph_data = function()
    {
        __error();
    }
    
    static get_glyph_count = function()
    {
        __error();
    }
    
    static get_line_count = function()
    {
        __error();
    }
    
    #endregion
    
    
    
    #region Typewriter
    
    static reveal = function()
    {
        __error();
    }
    
    static get_reveal = function()
    {
        __error();
    }
    
    #endregion
    
    
    
    #region Animation
    
    static animation_tick_speed = function()
    {
        __error();
    }
    
    static animation_speed = function()
    {
        __error();
    }
    
    static get_animation_speed = function()
    {
        __error();
    }
    
    static is_animated = function()
    {
        __error();
    }
    
    static animation_sync = function()
    {
        __error();
    }
    
    static animation_wave = function()
    {
        __error();
    }
    
    static animation_shake = function()
    {
        __error();
    }
    
    static animation_rainbow = function()
    {
        __error();
    }
    
    static animation_wobble = function()
    {
        __error();
    }
    
    static animation_pulse = function()
    {
        __error();
    }
    
    static animation_wheel = function()
    {
        __error();
    }
    
    static animation_cycle = function()
    {
        __error();
    }
    
    static animation_jitter = function()
    {
        __error();
    }
    
    static animation_blink = function()
    {
        __error();
    }
    
    #endregion
    
    
    
    #region MSDF
    
    static msdf_shadow = function()
    {
        __error();
    }
    
    static msdf_border = function()
    {
        __error();
    }
    
    static msdf_feather = function()
    {
        __error();
    }
    
    #endregion
    
    
    
    #region Cache Management
    
     /// @param freeze
    static build = function()
    {
        __error();
    }
    
    static flush = function()
    {
        __error();
    }
    
    #endregion
    
    
    
    #region Miscellaneous
    
    static get_events = function()
    {
        __error();
    }
    
    /// @param templateFunction/Array
    /// @param [executeOnlyOnChange=true]
    static template = function()
    {
        __error();
    }
    
    /// @param state
    static ignore_command_tags = function()
    {
        __error();
    }
    
    static z = function()
    {
        __error();
    }
    
    static get_z = function()
    {
        __error();
    }
    
    /// @param string
    /// @param [uniqueID]
    static overwrite = function()
    {
        __error();
    }
    
    static debug_draw_bbox = function()
    {
        __error();
    }
    
    #endregion
    
    
    
    #region Legacy Typewriter
    
    static typewriter_off = function()
    {
        __error();
    }
    
    static typewriter_reset = function()
    {
        __error();
    }
    
    static typewriter_in = function()
    {
        __error();
    }
    
    static typewriter_out = function()
    {
        __error();
    }
    
    static typewriter_skip = function()
    {
        __error();
    }
    
    static typewriter_sound = function()
    {
        __error();
    }
    
    static typewriter_sound_per_char = function()
    {
        __error();
    }
    
    static typewriter_function = function()
    {
        __error();
    }
    
    static typewriter_pause = function()
    {
        __error();
    }
    
    static typewriter_unpause = function()
    {
        __error();
    }
    
    static typewriter_ease = function()
    {
        __error();
    }
    
    static get_typewriter_state = function()
    {
        __error();
    }
    
    static get_typewriter_paused = function()
    {
        __error();
    }
    
    static get_typewriter_pos = function()
    {
        __error();
    }
    
    #endregion
}
