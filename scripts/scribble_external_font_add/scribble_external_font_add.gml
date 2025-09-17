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

function scribble_external_font_add(_sprite, _image, _json, _fontName = undefined, _isKrutidev = false)
{
    //Get source image data for the sprite/image that is being used as the glyph stlas for the font
    var _sourceFontInfo = sprite_get_info(_sprite);
    var _frameInfo = _sourceFontInfo.frames[_image]
    
    var _textureIndex  = _frameInfo.texture;
    
    //Ensure this texture has been fetched so we get valid texture dimensions
    texture_prefetch(_textureIndex);
    
    var _textureWidth  = texture_get_width(_textureIndex);
    var _textureHeight = texture_get_height(_textureIndex);
    
    
    var _textureUVs = [
        _frameInfo.x / _textureWidth,
        _frameInfo.y / _textureHeight,
        _frameInfo.w / _textureWidth,
        _frameInfo.h / _textureHeight,
    ];
    
    if (_fontName == undefined)
    {
        _fontName = _json.name;
    }
    
    //Convert the .yy JSON format into the key parts of the `font_get_info()` format that we need
    var _fontInfo = {
        texture:        _textureIndex,
        glyphs:         {},
        ascenderOffset: _json.ascenderOffset,
        ascender:       _json.ascender,
        sdfEnabled:     _json.usesSDF,
        sdfSpread:      _json.sdfSpread,
        size:           _json.size,
    };
    
    //Most of the work is duplicating out the glyph data
    var _jsonGlyphsDict = _json.glyphs;
    var _outputGlyphsDict = _fontInfo.glyphs;
    var _keyArray = variable_struct_get_names(_jsonGlyphsDict);
    var _i = 0;
    repeat(array_length(_keyArray))
    {
        var _key = _keyArray[_i];
        var _jsonGlyph = _jsonGlyphsDict[$ _key];
        
        //`font_get_info()` glyphs are largely copies of values in JSON
        var _outputGlyph = variable_clone(_jsonGlyph);
        
        // ... but the JSON `character` property is `char`
        var _character = _outputGlyph.character;
        variable_struct_remove(_outputGlyph, "character");
        _outputGlyph.char = _character;
        
        //In the JSON, glyph keys are stringified Unicode code points but in `font_get_info()` the keys
        //are the characters themselves
        _outputGlyphsDict[$ chr(_character)] = _outputGlyph;
        
        ++_i;
    }
    
    __ScribbleFontAddFromInfo(_fontName, undefined, _textureUVs, _fontInfo, _json.lineHeight, _isKrutidev, false);
    
    return _fontName;
}