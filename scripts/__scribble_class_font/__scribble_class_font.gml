/// @param fontName
/// @param glyphCount
/// @param isMSDF
/// @ignore
function __scribble_class_font(_name, _glyph_count, _msdf) constructor
{
    __name = _name;
    global.__scribble_font_data[? _name] = self;
    
    __glyph_data_grid = ds_grid_create(_glyph_count, SCRIBBLE_GLYPH.__SIZE);
    __glyphs_map = ds_map_create();
    
    __is_krutidev = false;
    
    __msdf         = _msdf;
    __msdf_pxrange = undefined;
    __superfont    = false;
    
    __scale  = 1.0;
    __height = 0; //*Not* the raw height. This value is changed by scribble_font_scale()
    
    __style_regular     = undefined;
    __style_bold        = undefined;
    __style_italic      = undefined;
    __style_bold_italic = undefined;
    
    static __copy_to = function(_target, _copy_styles)
    {
        var _names = variable_struct_get_names(self);
        var _i = 0;
        repeat(array_length(_names))
        {
            var _name = _names[_i];
            if (_name == "__glyphs_map")
            {
                ds_map_copy(_target.__glyphs_map, __glyphs_map);
            }
            else if (_name == "__glyph_data_grid")
            {
                ds_grid_copy(_target.__glyph_data_grid, __glyph_data_grid);
            }
            else if ((_name != "__name") && (_copy_styles || ((_name != "__style_regular") && (_name != "__style_bold") && (_name != "__style_italic") && (_name != "__style_bold_italic"))))
            {
                variable_struct_set(_target, _name, variable_struct_get(self, _name));
            }
            
            ++_i;
        }
    }
    
    static __calculate_font_height = function()
    {
        __height = __glyph_data_grid[# __glyphs_map[? 32], SCRIBBLE_GLYPH.HEIGHT];
        return __height;
    }
    
    static __clear = function()
    {
        if (!__superfont) __scribble_error("Cannot clear non-superfont fonts");
        
        ds_map_clear(__glyphs_map);
        
        __msdf_pxrange = undefined;
        __msdf         = undefined;
        
        __height = 0;
    }
    
    static __destroy = function()
    {
        if (__SCRIBBLE_DEBUG) __scribble_trace("Destroying font \"", __name, "\"");
        ds_map_destroy(__glyphs_map);
        ds_grid_destroy(__glyph_data_grid);
        ds_map_delete(global.__scribble_font_data, __name);
    }
}