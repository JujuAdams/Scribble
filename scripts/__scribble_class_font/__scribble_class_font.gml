/// @param fontName
/// @param glyphCount
/// @param isMSDF

function __scribble_class_font(_name, _glyph_count, _msdf) constructor
{
    name = _name;
    global.__scribble_font_data[? _name] = self;
    
    glyph_data_grid = ds_grid_create(_glyph_count, SCRIBBLE_GLYPH.__SIZE);
    glyphs_map = ds_map_create();
    
    msdf         = _msdf;
    msdf_pxrange = undefined;
    superfont    = false;
    
    scale  = 1.0;
    height = 0; //*Not* the raw height. This value is changed by scribble_font_scale()
    
    style_regular     = undefined;
    style_bold        = undefined;
    style_italic      = undefined;
    style_bold_italic = undefined;
    
    static copy_to = function(_target)
    {
        var _names = variable_struct_get_names(self);
        var _i = 0;
        repeat(array_length(_names))
        {
            var _name = _names[_i];
            if (_name == "glyphs_map")
            {
                ds_map_copy(_target.glyphs_map, glyphs_map);
            }
            else if (_name == "glyph_data_grid")
            {
                ds_grid_copy(_target.glyph_data_grid, glyph_data_grid);
            }
            else if ((_name != "name") && (_name != "style_regular") && (_name != "style_bold") && (_name != "style_italic") && (_name != "style_bold_italic"))
            {
                variable_struct_set(_target, _name, variable_struct_get(self, _name));
            }
            
            ++_i;
        }
    }
    
    static calculate_font_height = function()
    {
        height = glyph_data_grid[# glyphs_map[? 32], SCRIBBLE_GLYPH.HEIGHT];
        return height;
    }
    
    static clear = function()
    {
        if (!superfont) __scribble_error("Cannot clear non-superfont fonts");
        
        ds_map_clear(glyphs_map);
        
        msdf_pxrange = undefined;
        msdf         = undefined;
        
        height = 0;
    }
    
    //Unused as of 2021-11-11. Not sure how many problems this would cause if it was enabled
    //static destroy = function()
    //{
    //    ds_map_destroy(glyphs_map);
    //    ds_grid_destroy(glyph_data_grid);
    //    ds_map_delete(global.__scribble_font_data, name);
    //}
}