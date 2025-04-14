// Feather disable all

/// Adds a font to Scribble using the font texture and font .yy file stored within project files.
/// This function is intended for use with games that would like to support moddable content or
/// for writing external editors that need to hook into project assets. This function returns
/// the name of the font that has been added.
/// 
/// N.B. This function is *not* a replacement for `font_add()` and will not inherently handle
///      dynamic glyph creation.
/// 
/// @param sprite
/// @param image
/// @param yyJSON
/// @param [fontName]
/// @param [isKrutidev=false]

function scribble_external_font_add(_sprite, _image, _json, _font_name = undefined, _is_krutidev = false)
{
    //Get source image data for the sprite/image that is being used as the glyph stlas for the font
    var _source_font_info = sprite_get_info(_sprite);
    var _frame_info = _source_font_info.frames[_image]
    
    var _texture_index  = _frame_info.texture;
    var _texture_width  = texture_get_width(_texture_index);
    var _texture_height = texture_get_height(_texture_index);
    
    var _texture_uvs = [
        _frame_info.x / _texture_width,
        _frame_info.y / _texture_height,
        _frame_info.w / _texture_width,
        _frame_info.h / _texture_height,
    ];
    
    if (_font_name == undefined)
    {
        _font_name = _json.name;
    }
    
    //Convert the .yy JSON format into the key parts of the `font_get_info()` format that we need
    var _font_info = {
        texture: _texture_index,
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
    
    __scribble_font_add_from_info(_font_name, _texture_uvs, _font_info, _is_krutidev, false);
    
    return _font_name;
}