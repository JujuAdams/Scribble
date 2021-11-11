/// @param fontName
/// @param type

function __scribble_class_font(_name, _type) constructor
{
    global.__scribble_font_data[? _name] = self;
    
    name = _name;
    type = _type; //Can be either: "standard", "sprite", "msdf", "collage", "baked"
    
    glyphs_map = ds_map_create();
    msdf_range = undefined;
    xscale     = 1.0;
    yscale     = 1.0;
    scale_dist = 1.0;
    height     = 0;
    
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
            if ((_name != "name") && (_name != "type") && (_name != "glyphs_map"))
            {
                variable_struct_set(_target, _name, variable_struct_get(self, _name));
            }
            
            ++_i;
        }
    }
    
    static calculate_font_height = function()
    {
        height = glyphs_map[? 32][SCRIBBLE_GLYPH.HEIGHT];
    }
    
    //Unused as of 2021-11-11. Not sure how many problems this would cause if it was enabled
    //static destroy = function()
    //{
    //    ds_map_destroy(glyphs_map);
    //    ds_map_delete(global.__scribble_font_data, name);
    //}
}