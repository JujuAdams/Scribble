enum __SCRIBBLE_FONT
{
	NAME,         // 0
	PATH,         // 1
    FAMILY_NAME,  // 2
	TYPE,         // 3
	GLYPHS_MAP,   // 4
	GLYPHS_ARRAY, // 5
	GLYPH_MIN,    // 6
	GLYPH_MAX,    // 7
	SPACE_WIDTH,  // 8
	MAPSTRING,    // 9
	SEPARATION,   //10
	__SIZE        //11
}

function __scribble_font(_name, _type) constructor
{
    name = _name;
    type = _type; //Can be either: "standard", "sprite", "runtime", "msdf"
    
    path         = undefined;
    family_name  = "";
    glyphs_map   = undefined;
    glyphs_array = undefined;
    glyph_min    = undefined;
    glyph_max    = undefined;
    space_width  = undefined;
    mapstring    = "";
    separation   = 0;
}