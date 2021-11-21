/// @param fontName

function __scribble_class_font(_name) constructor
{
    global.__scribble_font_data[? _name] = self;
    
    name = _name;
    
    glyphs_map = ds_map_create();
    
    superfont = false;
    
    msdf_pxrange = undefined;
    msdf         = undefined;
    
    xscale     = 1.0;
    yscale     = 1.0;
    scale_dist = 1.0;
    height     = 0; //*Not* the raw height. This value is changed by scribble_font_scale()
    
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
            if ((_name != "name") && (_name != "glyphs_map"))
            {
                variable_struct_set(_target, _name, variable_struct_get(self, _name));
            }
            
            ++_i;
        }
    }
    
    static calculate_font_height = function()
    {
        height = yscale*glyphs_map[? 32][SCRIBBLE_GLYPH.HEIGHT];
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
    //    ds_map_delete(global.__scribble_font_data, name);
    //}
}