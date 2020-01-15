/// Adds a spritefont for use with Scribble.
///
/// @param fontName       String name of the spritefont to add.
/// @param mapString      String from which sprite sub-image order is taken. (Same behaviour as GameMaker's native font_add_sprite_ext())
/// @param separation     The space to leave between each letter. (Same behaviour as GameMaker's native font_add_sprite_ext())
/// @param [spaceWidth]   Pixel width of the space character. Defaults to emulating GameMaker's behaviour.
///
/// Scribble's spritefonts emulate GameMaker's native behaviour. Spritefonts otherwise behave indentically to normal fonts within Scribble.
/// All Scribble spritefonts are proportional as per GameMaker's font_add_sprite_ext() function.

if (!variable_global_exists("__scribble_global_count"))
{
    show_error("Scribble:\nscribble_add_spritefont() should be called after scribble_init()\n ", true);
    exit;
}

var _font        = argument[0];
var _mapstring   = argument[1];
var _separation  = argument[2];
var _space_width = (argument_count > 3)? argument[3] : undefined;

if (ds_map_exists(global.__scribble_font_data, _font))
{
    show_error("Scribble:\nFont \"" + _font + "\" has already been defined\n ", false);
    return undefined;
}

if (!is_string(_font))
{
    if (is_real(_font))
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

var _data = array_create(__SCRIBBLE_FONT.__SIZE);
_data[@ __SCRIBBLE_FONT.NAME        ] = _font;
_data[@ __SCRIBBLE_FONT.PATH        ] = undefined;
_data[@ __SCRIBBLE_FONT.TYPE        ] = __SCRIBBLE_FONT_TYPE.SPRITE;
_data[@ __SCRIBBLE_FONT.GLYPHS_MAP  ] = undefined;
_data[@ __SCRIBBLE_FONT.GLYPHS_ARRAY] = undefined;
_data[@ __SCRIBBLE_FONT.GLYPH_MIN   ] = 32;
_data[@ __SCRIBBLE_FONT.GLYPH_MAX   ] = 32;
_data[@ __SCRIBBLE_FONT.TEXTURE     ] = undefined;
_data[@ __SCRIBBLE_FONT.SPACE_WIDTH ] = _space_width;
_data[@ __SCRIBBLE_FONT.MAPSTRING   ] = _mapstring;
_data[@ __SCRIBBLE_FONT.SEPARATION  ] = _separation;
global.__scribble_font_data[? _font ] = _data;


        
if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Processing spritefont \"" + _font + "\"");

var _sprite = asset_get_index(_font);
_data[@ __SCRIBBLE_FONT.TEXTURE] = sprite_get_texture(_sprite, 0);

if (sprite_get_bbox_left(  _sprite) == 0)
|| (sprite_get_bbox_top(   _sprite) == 0)
|| (sprite_get_bbox_right( _sprite) == sprite_get_width(_sprite)-1)
|| (sprite_get_bbox_bottom(_sprite) == sprite_get_height(_sprite)-1)
{
    show_debug_message("Scribble:   WARNING! \"" + _font + "\" may be rendered incorrectly due to the bounding box overlapping the edge of the sprite. Please add at least a 1px border around your spritefont sprite. Please also update the bounding box if needed");
}
        
var _sprite_string  = _data[__SCRIBBLE_FONT.MAPSTRING  ];
var _shift_constant = _data[__SCRIBBLE_FONT.SEPARATION ];
var _space_width    = _data[__SCRIBBLE_FONT.SPACE_WIDTH];
        
var _font_glyphs_map = ds_map_create();
_data[@ __SCRIBBLE_FONT.GLYPHS_MAP] = _font_glyphs_map;

var _old_x      = x;
var _old_y      = y;
var _old_sprite = sprite_index;
var _old_mask   = mask_index;

sprite_index = _sprite;
mask_index   = _sprite;
x            = -sprite_get_xoffset(_sprite);
y            = -sprite_get_yoffset(_sprite);
        
//Strip out a map of of glyphs
var _length = string_length(_sprite_string);
if (SCRIBBLE_VERBOSE) show_debug_message("Scribble:   \"" + _font + "\" has " + string(_length) + " characters");
for(var _i = 0; _i < _length; _i++)
{
    var _char = string_char_at(_sprite_string, _i+1);
    if ( ds_map_exists(_font_glyphs_map, ord(_char))) continue;
    if (_char == " ") show_debug_message("Scribble:   WARNING! It is strongly recommended that you do *not* use a space character in your sprite font in GMS2.2.1 and above due to IDE bugs. Use scribble_font_char_set_*() to define a space character");
            
    image_index = _i;
    var _uvs = sprite_get_uvs(_sprite, image_index);
            
    //Perform line sweeping to get accurate glyph data
    var _left   = bbox_left-1;
    var _top    = bbox_top-1;
    var _right  = bbox_right+1;
    var _bottom = bbox_bottom+1;
            
    while (!collision_line(      _left, bbox_top-1,        _left, bbox_bottom+1, id, true, false) && (_left < _right )) ++_left;
    while (!collision_line(bbox_left-1,       _top, bbox_right+1,          _top, id, true, false) && (_top  < _bottom)) ++_top;
    while (!collision_line(     _right, bbox_top-1,       _right, bbox_bottom+1, id, true, false) && (_right  > _left)) --_right;
    while (!collision_line(bbox_left-1,    _bottom, bbox_right+1,       _bottom, id, true, false) && (_bottom > _top )) --_bottom;
            
    //Build an array to store this glyph's properties
    var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
    _array[@ SCRIBBLE_GLYPH.CHARACTER] = _char;
    _array[@ SCRIBBLE_GLYPH.INDEX    ] = ord(_char);
            
    if ((_left == _right) && (_top == _bottom))
    {
        show_debug_message("Scribble:   WARNING! Character " + string(ord(_char)) + "(" + _char + ") for sprite font \"" + _font + "\" is empty");
                
        _array[@ SCRIBBLE_GLYPH.WIDTH     ] = 1;
        _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = sprite_get_height(_sprite);
        _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = 0;
        _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
        _array[@ SCRIBBLE_GLYPH.SEPARATION] = 1 + _shift_constant;
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
        _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _glyph_width;
        _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _glyph_height;
        _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _left - bbox_left;
        _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = _top-1;
        _array[@ SCRIBBLE_GLYPH.SEPARATION] = _glyph_width + _shift_constant;
        _array[@ SCRIBBLE_GLYPH.U0        ] = _uvs[0];
        _array[@ SCRIBBLE_GLYPH.V0        ] = _uvs[1];
        _array[@ SCRIBBLE_GLYPH.U1        ] = _uvs[2];
        _array[@ SCRIBBLE_GLYPH.V1        ] = _uvs[3];
                
        _font_glyphs_map[? ord(_char)] = _array;
    }
}
        
if (!ds_map_exists(_font_glyphs_map, 32))
{
    var _glyph_width  = sprite_get_width(_sprite);
    var _glyph_height = sprite_get_height(_sprite);
            
    //Build an array to store this glyph's properties
    var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
    _array[@ SCRIBBLE_GLYPH.CHARACTER ] = " ";
    _array[@ SCRIBBLE_GLYPH.INDEX     ] = 32;
    _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _glyph_width;
    _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _glyph_height;
    _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = 0;
    _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
    _array[@ SCRIBBLE_GLYPH.SEPARATION] = _glyph_width + _shift_constant;
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

sprite_index = _old_sprite;
mask_index   = _old_mask;
x            = _old_x;
y            = _old_y;

if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Added \"" + _font + "\" as a spritefont");