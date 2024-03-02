// Feather disable all

#macro __SCRIBBLET_VERSION  "1.0.0"
#macro __SCRIBBLET_DATE     "2024-03-02"

function __ScribbletSystem()
{
    static _system = undefined;
    if (is_struct(_system)) return _system;
    
    _system = {};
    with(_system)
    {
        __cache            = {};
        __cacheTest        = {};
        __cacheFontInfo    = {};
        __cacheSpaceWidth  = {};
        __cacheSpaceHeight = {};
        
        __budget         = SCRIBBLET_BUDGET;
        __budgetUsed     = 0;
        __budgetUsedPrev = 0;
        
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
        __vertexFormat = vertex_format_end();
        
        vertex_format_begin();
        vertex_format_add_custom(vertex_type_float2, vertex_usage_position);
        vertex_format_add_color();
        vertex_format_add_texcoord();
        __vertexFormatColor = vertex_format_end();
    }
    
    time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
    {
        static _system = __ScribbletSystem();
        with(_system)
        {
            __budgetUsedPrev = __budgetUsed;
            __budgetUsed = 0;
        }
    },
    [], -1));
    
    return _system;
}