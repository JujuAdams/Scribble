/// Modifies a particular value for a character in a font previously added to Scribble.
/// 
/// 
/// Returns: The new value of the property that was modified.
/// @param fontName     The font name (as a string) of the font to modify.
/// @param character    The character (as a string) to modify.
/// @param property     The property to modify. See below for more details.
/// @param value        The value to set.
/// @param [relative]   Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to <false>, overwriting the existing value. Skip this argument or use <undefined> to use the default value.
/// 
/// 
/// Fonts can often be tricky to render correctly, and this script allows you to change certain properties.
/// Properties can be adjusted at any time, but existing/cached Scribble text will not be updated to match new properties.
/// Tip! Use scribble_set_glyph(<font>, <character>, <property>, 0, true) to get the current value of a glyph's property.
/// 
/// 
/// Three properties are available for modification:
/// SCRIBBLE_GLYPH_X_OFFSET:   The relative x-offset to draw the glyph
/// SCRIBBLE_GLYPH_Y_OFFSET:   The relative y-offset to draw the glyph
/// SCRIBBLE_GLYPH_SEPARATION: The distance in the x-axis that this character is separated from the next

var _font      = argument[0];
var _character = argument[1];
var _property  = argument[2];
var _value     = argument[3];
var _relative  = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : false;

if ( !variable_global_exists("__scribble_global_count") )
{
    show_error("Scribble:\nscribble_glyph_property() should be called after initialising Scribble.\n ", false);
    exit;
}

if (!ds_map_exists(global.__scribble_font_data, _font))
{
    show_error("Scribble:\nFont \"" + string(_font) + "\" not found\n ", false);
    exit;
}

var _font_data = global.__scribble_font_data[? _font ];

var _array = _font_data[ __SCRIBBLE_FONT.GLYPHS_ARRAY ];
if (_array == undefined)
{
    //If the glyph array doesn't exist for this font, use the ds_map fallback
    var _map = _font_data[ __SCRIBBLE_FONT.GLYPHS_MAP ];
    var _glyph_data = _map[? ord(_character) ];
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

var _new_value = _relative? (_glyph_data[_property] + _value) : _value;
_glyph_data[@ _property] = _new_value;
return _new_value;