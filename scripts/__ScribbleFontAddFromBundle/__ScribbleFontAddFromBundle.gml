// Feather disable all

/// @param font

function __ScribbleFontAddFromBundle(_font)
{
    static _fontToTextureGroupMap = __ScribbleSystem().__fontToTextureGroupMap;
    
    var _textureGroup = _fontToTextureGroupMap[? real(_font)];
    
    var _name       = font_get_name(_font);
    var _asset      = asset_get_index(_name);
    var _textureUVs = font_get_uvs(_asset);
    var _fontInfo   = font_get_info(_font);
    var _isKrutidev = __ScribbleAssetIsKrutidev(_font, asset_font);
    
    //This is a bit silly but it seems to be the only way to reliably get an accurate line height
    var _old_font = draw_get_font();
    draw_set_font(_font);
    var _lineHeight = string_height(" ");
    draw_set_font(_old_font);
    
    return __ScribbleFontAddFromInfo(_name, _textureGroup, _textureUVs, _fontInfo, _lineHeight, _isKrutidev, true);
}