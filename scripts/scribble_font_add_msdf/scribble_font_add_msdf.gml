/// Adds a MSDF font definition for Scribble
///
/// As of September 14th 2020, Scribble only accepts MSDF fonts that have been made with the following tool:
/// https://github.com/donmccurdy/msdf-bmfont-web
/// https://msdf-bmfont.donmccurdy.com/
/// A valid branch of this tool can be found here:
/// https://github.com/donmccurdy/msdf-bmfont-web
///
/// @param fontName     String name of the font to add
/// @param sprite       Source sprite to use as the glyph texture atlas
/// @param jsonName     Path to the JSON file that contains glyph data, relative to Scribble's root directory in Included Files

function scribble_font_add_msdf(_font, _sprite, _json_name)
{
    if (ds_map_exists(global.__scribble_font_data, _font))
    {
        show_error("Scribble:\nFont \"" + _font + "\" has already been defined\n ", false);
        return undefined;
    }
    
    if (global.__scribble_default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_font) + "\"");
        global.__scribble_default_font = _font;
    }
    
    var _font_data = new __scribble_class_font(_font, "msdf");
    
    if (SCRIBBLE_VERBOSE) show_debug_message( "Scribble: Defined \"" + _font + "\" as an MSDF font" );

    var _sprite_width  = sprite_get_width(_sprite);
    var _sprite_height = sprite_get_height(_sprite);
    var _sprite_uvs    = sprite_get_uvs(_sprite, 0);
    var _texture       = sprite_get_texture(_sprite, 0);

    var _json_buffer = buffer_load(global.__scribble_font_directory + _json_name);
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
    _font_data.msdf_range = _msdf_range;

    var _json_glyph_list = _json[? "chars"];
    if (ds_exists(_json_glyph_list, ds_type_map))
    {
        if ((ds_map_size(_json_glyph_list) == 2) && ds_map_exists(_json_glyph_list, "-count") && ds_map_exists(_json_glyph_list, "char"))
        {
            _json_glyph_list = _json_glyph_list[? "char"];
        }
    }

    var _size = ds_list_size( _json_glyph_list );
    if (SCRIBBLE_VERBOSE) show_debug_message( "Scribble: \"" + _font + "\" has " + string( _size ) + " characters" );

    var _font_glyphs_map = ds_map_create();
    _font_data.glyphs_map = _font_glyphs_map;

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
    
        var _u0 = lerp(_sprite_uvs[0], _sprite_uvs[2],       _x /_sprite_width );
        var _v0 = lerp(_sprite_uvs[1], _sprite_uvs[3],       _y /_sprite_height);
        var _u1 = lerp(_sprite_uvs[0], _sprite_uvs[2], (_x + _w)/_sprite_width );
        var _v1 = lerp(_sprite_uvs[1], _sprite_uvs[3], (_y + _h)/_sprite_height);
    
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
    _array[@ SCRIBBLE_GLYPH.WIDTH ] = _array[SCRIBBLE_GLYPH.SEPARATION];
    _array[@ SCRIBBLE_GLYPH.HEIGHT] = _json_line_height;

    ds_map_destroy(_json);
}