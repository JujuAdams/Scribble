/// Adds a MSDF font definition for Scribble
///
/// As of September 14th 2020, Scribble only accepts MSDF fonts that have been made with the following tool:
/// https://github.com/donmccurdy/msdf-bmfont-web
/// https://msdf-bmfont.donmccurdy.com/
/// A valid branch of this tool can be found here:
/// https://github.com/donmccurdy/msdf-bmfont-web
///
/// @param fontName   String name of the font to add
/// @param spaceWidth Width of a space character

if (!variable_global_exists("__scribble_lcg"))
{
    show_error("Scribble:\nscribble_add_msdf_font() should be called after scribble_init()\n ", true);
    exit;
}

var _font        = argument0;
var _space_width = argument1;

if (ds_map_exists(global.__scribble_font_data, _font))
{
    show_error("Scribble:\nFont \"" + _font + "\" has already been defined\n ", false);
    return undefined;
}

if (global.__scribble_default_font == "") global.__scribble_default_font = _font;

var _data = array_create(__SCRIBBLE_FONT.__SIZE);
_data[@ __SCRIBBLE_FONT.NAME        ] = _font;
_data[@ __SCRIBBLE_FONT.PATH        ] = undefined;
_data[@ __SCRIBBLE_FONT.SPRITE      ] = undefined;
_data[@ __SCRIBBLE_FONT.FAMILY_NAME ] = undefined;
_data[@ __SCRIBBLE_FONT.TYPE        ] = __SCRIBBLE_FONT_TYPE.MSDF;
_data[@ __SCRIBBLE_FONT.GLYPHS_MAP  ] = undefined;
_data[@ __SCRIBBLE_FONT.GLYPHS_ARRAY] = undefined;
_data[@ __SCRIBBLE_FONT.GLYPH_MIN   ] = 32;
_data[@ __SCRIBBLE_FONT.GLYPH_MAX   ] = 32;
_data[@ __SCRIBBLE_FONT.SPACE_WIDTH ] = _space_width;
_data[@ __SCRIBBLE_FONT.MAPSTRING   ] = undefined;
_data[@ __SCRIBBLE_FONT.SEPARATION  ] = undefined;
_data[@ __SCRIBBLE_FONT.MSDF_RANGE  ] = undefined;
global.__scribble_font_data[? _font] = _data;

show_debug_message( "Scribble: Defined \"" + _font + "\" as an MSDF font" );

var _sprite = sprite_add(global.__scribble_font_directory + _font + ".png", 0, false, false, 0, 0);
_data[@ __SCRIBBLE_FONT.SPRITE] = _sprite;

var _texture    = sprite_get_texture(_sprite, 0);
var _texture_tw = texture_get_texel_width( _texture);
var _texture_th = texture_get_texel_height(_texture);

var _json_buffer = buffer_load(global.__scribble_font_directory + _font + ".json");
var _json_string = buffer_read(_json_buffer, buffer_text);
buffer_delete(_json_buffer);
var _json = json_decode(_json_string);

//Try to detect if this JSON was converted from XML
//We presume the JSON uses no prefix, but we find a "font" object in the root, the assume we need - prefix for attributes
//A little further down we adjust this to @ prefix if necessary
var _key_prefix = "";
if ((ds_map_size(_json) == 1) && ds_map_exists(_json, "font"))
{
    _json = _json[? "font"];
    _key_prefix = "-";
}

//Recover the line height to be used for the height of the space character
//At the same time, figure out if this JSON uses @ prefix for attributes
var _json_common_map = _json[? "common"];
var _json_line_height = real(_json_common_map[? _key_prefix + "lineHeight"]);
if (_json_line_height == undefined)
{
    _key_prefix = "@";
    _json_line_height = real(_json_common_map[? _key_prefix + "lineHeight"]);
}

//Grab the pixel range setting used for the MSDF
//This eventually finds its way into the MSDF shader to accurately feather the glyph edges
var _json_distance_field = _json[? "distanceField"];
var _msdf_range = real(_json_distance_field[? _key_prefix + "distanceRange"]);
_data[@ __SCRIBBLE_FONT.MSDF_RANGE] = _msdf_range;

var _json_glyph_list = _json[? "chars"];
if (ds_exists(_json_glyph_list, ds_type_map))
{
    if ((ds_map_size(_json_glyph_list) == 2) && ds_map_exists(_json_glyph_list, "-count") && ds_map_exists(_json_glyph_list, "char"))
    {
        _json_glyph_list = _json_glyph_list[? "char"];
    }
}

var _size = ds_list_size( _json_glyph_list );
show_debug_message( "Scribble: MSDF \"" + _font + "\" has " + string( _size ) + " characters" );

var _font_glyphs_map = ds_map_create();
_data[@ __SCRIBBLE_FONT.GLYPHS_MAP] = _font_glyphs_map;

var _i = 0;
repeat(_size)
{
    var _json_glyph_map = _json_glyph_list[| _i ];
    var _char  = _json_glyph_map[? _key_prefix + "char"];
    var _x     = real(_json_glyph_map[? _key_prefix + "x"     ]);
    var _y     = real(_json_glyph_map[? _key_prefix + "y"     ]);
    var _w     = real(_json_glyph_map[? _key_prefix + "width" ]);
    var _h     = real(_json_glyph_map[? _key_prefix + "height"]);
    var _index = ord(_char);
    
    if (__SCRIBBLE_DEBUG) show_debug_message("Scribble:     Adding data for character \"" + string(_char) + "\" (" + string(_index) + ")");
    
    var _u0 = _x*_texture_tw;
    var _v0 = _y*_texture_th;
    var _u1 = _u0 + _w*_texture_tw;
    var _v1 = _v0 + _h*_texture_th;
    
    var _xoffset  = real(_json_glyph_map[? _key_prefix + "xoffset" ]);
    var _yoffset  = real(_json_glyph_map[? _key_prefix + "yoffset" ]);
    var _xadvance = real(_json_glyph_map[? _key_prefix + "xadvance"]);
    
    var _array = array_create(SCRIBBLE_GLYPH.__SIZE, undefined);
    _array[@ SCRIBBLE_GLYPH.CHARACTER ] = _char;
    _array[@ SCRIBBLE_GLYPH.INDEX     ] = _index;
    _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _w;
    _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _h;
    _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _xoffset;
    _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = _yoffset - _msdf_range;
    _array[@ SCRIBBLE_GLYPH.SEPARATION] = _xadvance;
    _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _texture;
    _array[@ SCRIBBLE_GLYPH.U0        ] = _u0;
    _array[@ SCRIBBLE_GLYPH.V0        ] = _v0;
    _array[@ SCRIBBLE_GLYPH.U1        ] = _u1;
    _array[@ SCRIBBLE_GLYPH.V1        ] = _v1;
    
    _font_glyphs_map[? _index] = _array;
    
    ++_i;
}

//Now handle the space character
var _array = _font_glyphs_map[? 32];
_array[@ SCRIBBLE_GLYPH.WIDTH     ] = _space_width;
_array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _json_line_height;
_array[@ SCRIBBLE_GLYPH.SEPARATION] = _space_width;

ds_map_destroy(_json);