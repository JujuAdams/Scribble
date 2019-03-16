/// void scribble_set_glyph_property(fontName, character, property, value, [relative]);
/// Modifies a particular value for a character in a font previously added to Scribble
///
/// Fonts can often be tricky to render correctly, and this script allows to change certain properties.
/// Properties can be adjusted at any time, but existing Scribble data structures will not be updated to match new properties.
///
/// Three properties are available:
/// 1) SCRIBBLE_GLYPH_X_OFFSET   - The relative x-position to display the glyph
/// 2) SCRIBBLE_GLYPH_Y_OFFSET   - The relative y-position to display the glyph
/// 3) SCRIBBLE_GLYPH_SEPARATION - The effective width of the glyph
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
var _relative  = false;

switch (argument_count){
    case 5:
        if ( argument[4] != undefined ) _relative = argument[4];
        break;
}

if ( global.__scribble_init_complete == SCRIBBLE_INIT_START ) {
    show_error( "scribble_set_glyph_property() should be called after initialising Scribble.", false );
    exit;
}

if ( global.__scribble_init_complete == SCRIBBLE_INIT_DURING ) {
    show_error( "scribble_init_add_spritefont() should be called before scribble_init_end()", true );
    return undefined;
}

var _font_data = global.__scribble_font_data[? _font ];

var _array = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_ARRAY ];
if ( _array == undefined ) {
    //If the glyph array doesn't exist for this font, use the ds_map fallback
    var _map = _font_data[ __E_SCRIBBLE_FONT.GLYPHS_MAP ];
    var _glyph_data = _map[? _character ];
} else {
    var _glyph_data = _array[ ord(_character) - _font_data[ __E_SCRIBBLE_FONT.GLYPH_MIN ] ];
}

if ( _glyph_data == undefined ) {
    show_error( "Character " + _character + " not found for font " + _font, false );
    exit;
}

if ( _relative ) {
    _glyph_data[@ _property ] += _value;
} else {
    _glyph_data[@ _property ] = _value;
}
