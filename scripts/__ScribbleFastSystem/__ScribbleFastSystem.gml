// Feather disable all

function __ScribbleFastSystem()
{
    static _system = undefined;
    if (is_struct(_system)) return _system;
    
    _system = {};
    with(_system)
    {
        __cache = {};
        __cacheTest = {};
        __cacheFontInfo = {};
        __defaultFont = fntTest;
        
        __colourDict = {};
        __colourDict[$ "c_red"  ] = c_red;
        __colourDict[$ "c_blue" ] = c_blue;
        __colourDict[$ "c_lime" ] = c_lime;
        __colourDict[$ "/c"     ] = -1;
        __colourDict[$ "/color" ] = -1;
        __colourDict[$ "/colour"] = -1;
        
        vertex_format_begin();
        vertex_format_add_custom(vertex_type_float2, vertex_usage_position);
        vertex_format_add_texcoord();
        __vertexFormatA = vertex_format_end();
        
        vertex_format_begin();
        vertex_format_add_custom(vertex_type_float2, vertex_usage_position);
        vertex_format_add_color();
        vertex_format_add_texcoord();
        __vertexFormatB = vertex_format_end();
    }
    
    return _system;
}