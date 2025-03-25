// Feather disable all

/// Adds a font to Scribble using the font texture and font .yy file stored within project files.
/// This function is intended for use with games that would like to support moddable content or
/// for writing external editors that need to hook into project assets.
/// 
/// N.B. This function is *not* a replacement for `font_add()` and will not inherently handle
///      dynamic glyph creation.
/// 
/// @param sprite
/// @param image
/// @param yyJSON
/// @param [fontName]
/// @param [isKrutidev=false]

function scribble_font_add_from_source(_sprite, _image, _json, _font_name = undefined, _is_krutidev = false)
{
    var _texture     = sprite_get_texture(_sprite, _image);
    var _texture_uvs = sprite_get_uvs(_sprite, _image);
    
    if (_font_name == undefined)
    {
        _font_name = _json.name;
    }
    
    //Convert the .yy JSON format into the key parts of the `font_get_info()` format that we need
    var _font_info = {
        glyphs: {},
        ascenderOffset: _json.ascenderOffset,
        sdfEnabled: _json.usesSDF,
        sdfSpread: _json.sdfSpread,
        size: _json.size,
    };
    
    //Most of the work is duplicating out the glyph data
    var _json_glyphs_dict = _json.glyphs;
    var _output_glyphs_dict = _font_info.glyphs;
    var _key_array = variable_struct_get_names(_json_glyphs_dict);
    var _i = 0;
    repeat(array_length(_key_array))
    {
        var _key = _key_array[_i];
        var _json_glyph = _json_glyphs_dict[$ _key];
        
        //`font_get_info()` glyphs are largely copies of values in JSON
        var _output_glyph = variable_clone(_json_glyph);
        
        // ... but the JSON `character` property is `char`
        var _character = _output_glyph.character;
        variable_struct_remove(_output_glyph, "character");
        _output_glyph.char = _character;
        
        //In the JSON, glyph keys are stringified Unicode code points but in `font_get_info()` the keys
        //are the characters themselves
        _output_glyphs_dict[$ chr(_character)] = _output_glyph;
        
        ++_i;
    }
    
    __scribble_font_add_from_texture(_font_name, _texture, _texture_uvs, _font_info, _is_krutidev);
    
    return _font_name;
}