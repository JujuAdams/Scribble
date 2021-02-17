function __scribble_class_null_model() constructor
{
    last_drawn = current_time;
    flushed = false;
    valign = fa_top;
    
    uses_standard_font = false;
    uses_msdf_font     = false;
    
    static draw = function(_x, _y, _element) { return undefined; }
    static flush = function() { return undefined; }
    static reset = function() { return undefined; }
    
    static get_bbox = function(_page)
    {
        return { left:   0,
                 top:    0,
                 right:  0,
                 bottom: 0,
                 width:  0,
                 height: 0 };
    }
    
    static get_width = function(_page) { return 0; }
    static get_height = function(_page) { return 0; }
    static get_page_array = function() { return []; }
    static get_pages = function() { return 0; }
    static get_wrapped = function() { return false; }
    static get_line_count = function() { return 0; }
    static get_ltrb_array = function()
    {
        if (!SCRIBBLE_CREATE_GLYPH_LTRB_ARRAY) __scribble_error("SCRIBBLE_CREATE_GLYPH_LTRB_ARRAY is not enabled\nPlease set this macro to <true> to use this function");
        return [];
    }
}