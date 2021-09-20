/// @param fontName
/// @param type

function __scribble_class_font(_name, _type) constructor
{
    global.__scribble_font_data[? _name] = self;
    
    name = _name;
    type = _type; //Can be either: "standard", "sprite", "runtime", "msdf"
    
    path         = undefined;
    glyphs_map   = undefined;
    glyphs_array = undefined;
    glyph_min    = 32;
    glyph_max    = 32;
    space_width  = undefined;
    mapstring    = undefined;
    separation   = undefined;
    msdf_range   = undefined;
    xscale       = 1.0;
    yscale       = 1.0;
    scale_dist   = 1.0;
    
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
            if ((_name != "name") && (_name != "type"))
            {
                variable_struct_set(_target, _name, variable_struct_get(self, _name));
            }
            
            ++_i;
        }
    }
}