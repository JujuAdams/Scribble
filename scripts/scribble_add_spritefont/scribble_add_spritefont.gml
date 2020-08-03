/// Adds a spritefont for use with Scribble
///
/// @param fontName        Name of the spritefont to add, as a string
/// @param mapString       String from which sprite sub-image order is taken (Same behaviour as GameMaker's native font_add_sprite_ext())
/// @param separation      The space to leave between each letter (Same behaviour as GameMaker's native font_add_sprite_ext())
/// @param [spaceWidth]    Pixel width of the space character. Defaults to emulating GameMaker's behaviour
/// @param [proportional]  Allows characters to have variable widths depending on their size. Defaults to <true>. Set to <false> to make every character's width identical
///
/// scribble_add_spritefont() emulates the behaviour of font_add_sprite_ext(). For more information on the behaviour of font_add_sprite_ext(), please refer to the
/// GameMaker Studio 2 documentation.
/// 
/// Sprites used for spritefonts have specific requirements that must be met for Scribble to render them properly:
/// 
///     Collision mask mode set to Automatic
///     Colllision mask type set to Precise Per Frame (Slow)
///     "Separate Texture Page" set to off
///     The sprite must have at least a 1 pixel transparent border around the edge
/// 
/// If your characters are drawn partially garbled, try placing the spritefont in its own texture group.
/// 
/// Unlike standard fonts, spritefonts do not need to have any files added as Included Files. Similarly, spritefonts will not be added by using the autoScan feature
/// of scribble_init(). Each spritefont must be added manually by calling scribble_add_spritefont().

function scribble_add_spritefont()
{
	if (!variable_global_exists("__scribble_lcg"))
	{
	    show_error("Scribble:\nscribble_add_spritefont() should be called after scribble_init()\n ", true);
	    exit;
	}

	var _font         = argument[0];
	var _mapstring    = argument[1];
	var _separation   = argument[2];
	var _space_width  = (argument_count > 3)? argument[3] : undefined;
	var _proportional = (argument_count > 4)? argument[4] : true;

	if (ds_map_exists(global.__scribble_font_data, _font))
	{
	    show_error("Scribble:\nFont \"" + _font + "\" has already been defined\n ", false);
	    return undefined;
	}

	if (!is_string(_font))
	{
	    if (is_real(_font) && (asset_get_type(font_get_name(_font)) == asset_sprite))
	    {
	        show_error("Scribble:\nFonts should be initialised using their name as a string.\n(Input to script was \"" + string(_font) + "\", which might be sprite \"" + sprite_get_name(_font) + "\")\n ", false);
	    }
	    else
	    {
	        show_error("Scribble:\nFonts should be initialised using their name as a string.\n(Input to script was an invalid datatype)\n ", false);
	    }
	    exit;
	}

	if (asset_get_type(_font) == asset_font)
	{
	    show_error("Scribble:\nTo add a normal font, please use scribble_add_font()\n ", false);
	    return scribble_add_font(_font);
	}

	if (asset_get_type(_font) != asset_sprite)
	{
	    show_error("Scribble:\nSprite \"" + _font + "\" not found in the project\n ", false);
	    return undefined;
	}



	if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Processing spritefont \"" + _font + "\"");
        
	//Strip out a map of of glyphs
	var _sprite = asset_get_index(_font);
	var _sprite_length = sprite_get_number(_sprite);
	var _length = string_length(_mapstring);
	if (SCRIBBLE_VERBOSE) show_debug_message("Scribble:   \"" + _font + "\" has " + string(_length) + " characters");

	if (_length > _sprite_length)
	{
	    show_error("Scribble:\nmapString for \"" + _font + "\" has more characters (" + string(_length) + ") than the sprite (" + string(_sprite_length) + ")\nPlease ensure you have one image in your sprite for every character\n ", true);
	    return undefined;
	}
	else if (_length < _sprite_length)
	{
	    show_debug_message("Scribble:   WARNING! mapString for \"" + _font + "\" has fewer characters (" + string(_length) + ") than the sprite (" + string(_sprite_length) + ")");
	}



	var _sprite_width  = sprite_get_width( _sprite);
	var _sprite_height = sprite_get_height(_sprite);

	var _data = array_create(__SCRIBBLE_FONT.__SIZE);
	_data[@ __SCRIBBLE_FONT.NAME        ] = _font;
	_data[@ __SCRIBBLE_FONT.PATH        ] = undefined;
	_data[@ __SCRIBBLE_FONT.FAMILY_NAME ] = undefined;
	_data[@ __SCRIBBLE_FONT.TYPE        ] = __SCRIBBLE_FONT_TYPE.SPRITE;
	_data[@ __SCRIBBLE_FONT.GLYPHS_MAP  ] = undefined;
	_data[@ __SCRIBBLE_FONT.GLYPHS_ARRAY] = undefined;
	_data[@ __SCRIBBLE_FONT.GLYPH_MIN   ] = 32;
	_data[@ __SCRIBBLE_FONT.GLYPH_MAX   ] = 32;
	_data[@ __SCRIBBLE_FONT.SPACE_WIDTH ] = _space_width;
	_data[@ __SCRIBBLE_FONT.MAPSTRING   ] = _mapstring;
	_data[@ __SCRIBBLE_FONT.SEPARATION  ] = _separation;
	global.__scribble_font_data[? _font ] = _data;

	var _texture = sprite_get_texture(_sprite, 0);
    
	var _sprite_string   = _mapstring;
	var _shift_constant  = _separation;
	var _monospace_width = (!_proportional)? sprite_get_width(_sprite) : undefined;
        
	var _font_glyphs_map = ds_map_create();
	_data[@ __SCRIBBLE_FONT.GLYPHS_MAP] = _font_glyphs_map;
    
    var _sprite_xoffset = sprite_get_xoffset(_sprite);
    var _sprite_yoffset = sprite_get_yoffset(_sprite);
    var _sprite_width   = sprite_get_width(  _sprite);
    var _sprite_height  = sprite_get_height( _sprite);
    
	//Strip out a map of of glyphs
	var _potential_separate_texture_page = 0;
	for(var _i = 0; _i < _length; _i++)
	{
	    var _char = string_char_at(_sprite_string, _i+1);
	    if (ds_map_exists(_font_glyphs_map, ord(_char))) continue;
	    if ((_char == " ") && (_space_width == undefined)) show_debug_message("Scribble:   WARNING! It is recommended that you do *not* use a space character in your spritefont. Please override the space character width by using the optional [spaceWidth] argument of scribble_add_spritefont()");
        
	    var _uvs = sprite_get_uvs(_sprite, _i);
	    if ((_uvs[0] == 0.0) && (_uvs[1] == 0.0) && (_uvs[4] == 0.0) && (_uvs[5] == 0.0) && (_uvs[6] == 1.0) && (_uvs[7] == 1.0)) _potential_separate_texture_page++;
        
        var _left   = _uvs[4] - _sprite_xoffset;
        var _top    = _uvs[5] - _sprite_yoffset;
        var _right  = _left + _sprite_width *_uvs[6] - 1;
        var _bottom = _top  + _sprite_height*_uvs[7] - 1;
        
	    //Build an array to store this glyph's properties
	    var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
	    _array[@ SCRIBBLE_GLYPH.CHARACTER] = _char;
	    _array[@ SCRIBBLE_GLYPH.INDEX    ] = ord(_char);
        
	    if ((_left > _right) && (_top > _bottom))
	    {
	        show_debug_message("Scribble:   WARNING! Character " + string(ord(_char)) + " (" + _char + ") for spritefont \"" + _font + "\" is empty");
                
	        _array[@ SCRIBBLE_GLYPH.WIDTH     ] = 1;
	        _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _sprite_height;
	        _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = 0;
	        _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
	        _array[@ SCRIBBLE_GLYPH.SEPARATION] = 1 + _shift_constant;
	        _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _texture;
	        _array[@ SCRIBBLE_GLYPH.U0        ] = 0;
	        _array[@ SCRIBBLE_GLYPH.V0        ] = 0;
	        _array[@ SCRIBBLE_GLYPH.U1        ] = 0;
	        _array[@ SCRIBBLE_GLYPH.V1        ] = 0;
	        _font_glyphs_map[? ord(_char)] = _array;
	    }
	    else
	    {
	        var _glyph_width  = 1 + _right - _left;
	        var _glyph_height = 1 + _bottom - _top;
        
	        var _x_offset   = SCRIBBLE_SPRITEFONT_ALIGN_GLYPHS_LEFT? 0 : (_left - sprite_get_bbox_left(_sprite));
	        var _separation = _glyph_width + _shift_constant;
        
	        if (!_proportional)
	        {
	            _x_offset   = _left;
	            _separation = _monospace_width + _shift_constant;
	        }
        
	        _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _glyph_width;
	        _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _glyph_height;
	        _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _x_offset;
	        _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = _top;
	        _array[@ SCRIBBLE_GLYPH.SEPARATION] = _separation;
	        _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _texture;
	        _array[@ SCRIBBLE_GLYPH.U0        ] = _uvs[0];
	        _array[@ SCRIBBLE_GLYPH.V0        ] = _uvs[1];
	        _array[@ SCRIBBLE_GLYPH.U1        ] = _uvs[2];
	        _array[@ SCRIBBLE_GLYPH.V1        ] = _uvs[3];
                
	        _font_glyphs_map[? ord(_char)] = _array;
	    }
	}
        
	if (ds_map_exists(_font_glyphs_map, 32))
	{
	    //Set the space character's height just in case the user has decided to use a space in the mapstring
	    var _array = _font_glyphs_map[? 32];
	    _array[@ SCRIBBLE_GLYPH.HEIGHT] = _sprite_height;
	}
	else
	{
	    var _glyph_width  = (!_proportional)? _sprite_width : (1 + bbox_right - bbox_left);
	    if (_space_width == undefined) _glyph_width += _shift_constant;
            
	    //Build an array to store this glyph's properties
	    var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
	    _array[@ SCRIBBLE_GLYPH.CHARACTER ] = " ";
	    _array[@ SCRIBBLE_GLYPH.INDEX     ] = 32;
	    _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _glyph_width;
	    _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _sprite_height;
	    _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = 0;
	    _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
	    _array[@ SCRIBBLE_GLYPH.SEPARATION] = _glyph_width + _shift_constant;
	    _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _texture;
	    _array[@ SCRIBBLE_GLYPH.U0        ] = 0;
	    _array[@ SCRIBBLE_GLYPH.V0        ] = 0;
	    _array[@ SCRIBBLE_GLYPH.U1        ] = 0;
	    _array[@ SCRIBBLE_GLYPH.V1        ] = 0;
	    _font_glyphs_map[? 32] = _array;
	}
        
	if (_space_width != undefined)
	{
	    var _array = _font_glyphs_map[? 32];
	    _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _space_width;
	    _array[@ SCRIBBLE_GLYPH.SEPARATION] = _space_width;
	}
    
	if (SCRIBBLE_WARNING_TEXTURE_PAGE && (_potential_separate_texture_page > 0.5*_length))
	{
	    show_error("Scribble:\nSpritefont \"" + string(_font) + "\" appears to be set to Separate Texture Page\nPlease untick Separate Texture Page for this sprite\n \n(Set SCRIBBLE_WARNING_TEXTURE_PAGE to <false> to turn off this warning)\n ", true);
	}

	if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Added \"" + _font + "\" as a spritefont");
}