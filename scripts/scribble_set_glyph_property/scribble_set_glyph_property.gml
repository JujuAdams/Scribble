/// Modifies a particular value for a character in a font previously added to Scribble
///
/// Fonts can often be tricky to render correctly, and this script allows to change certain properties.
/// Properties can be adjusted at any time, but existing Scribble data structures will not be updated to match new properties.
///
/// The following properties are available:
/// enum SCRIBBLE_GLYPH
/// {
///     CHARACTER,  // 0
///     INDEX,      // 1
///     WIDTH,      // 2
///     HEIGHT,     // 3
///     X_OFFSET,   // 4
///     Y_OFFSET,   // 5
///     SEPARATION, // 6
///     U0,         // 7
///     V0,         // 8
///     U1,         // 9
///     V1          //10
/// }
/// You'll usually only want to modify SCRIBBLE_GLYPH.X_OFFSET, SCRIBBLE_GLYPH.Y_OFFSET, and SCRIBBLE_GLYPH.SEPARATION
///
/// @param fontName     The font name (as a string) of the font to modify
/// @param character    The character (as a string) to modify
/// @param property     The property to modify. See description for more details
/// @param value        The value to set
/// @param [relative]   Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to <false>, overwriting the existing value
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _font      = argument[0];
var _character = argument[1];
var _property  = argument[2];
var _value     = argument[3];
var _relative  = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : false;

if ( !variable_global_exists("__scribble_global_count") )
{
    show_error("Scribble:\nscribble_set_glyph_property() should be called after initialising Scribble.\n ", false);
    exit;
}

var _font_data = global.__scribble_font_data[? _font ];

var _array = _font_data[ __SCRIBBLE_FONT.GLYPHS_ARRAY ];
if (_array == undefined)
{
    //If the glyph array doesn't exist for this font, use the ds_map fallback
    var _map = _font_data[ __SCRIBBLE_FONT.GLYPHS_MAP ];
    var _glyph_data = _map[? _character ];
}
else
{
    var _glyph_data = _array[ ord(_character) - _font_data[ __SCRIBBLE_FONT.GLYPH_MIN ] ];
}

if (_glyph_data == undefined)
{
    show_error("Scribble:\nCharacter \"" + _character + "\" not found for font \"" + _font + "\"", false);
    exit;
}

if (_relative)
{
    _glyph_data[@ _property ] += _value;
}
else
{
    _glyph_data[@ _property ] = _value;
}