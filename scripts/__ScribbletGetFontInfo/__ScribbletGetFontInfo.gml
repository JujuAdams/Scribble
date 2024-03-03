function __ScribbletGetFontInfo(_font)
{
    static _system         = __ScribbletSystem();
    static _cache          = _system.__cacheFontInfo;
    static _spriteFontData = _system.__spriteFontData;
    
    var _name = font_get_name(_font);
    
    var _fontInfo = _cache[$ _name];
    if (_fontInfo == undefined)
    {
        _fontInfo = font_get_info(_font);
        _cache[$ _name] = _fontInfo;
        
        var _fontGlyphStruct = _fontInfo.glyphs;
        var _glyphNameArray = variable_struct_get_names(_fontGlyphStruct);
        
        //Check if this is a spritefont
        if ((_fontInfo.texture < 0) && (_fontInfo.spriteIndex >= 0))
        {
            var _sprite  = _fontInfo.spriteIndex;
            var _spriteInfo = sprite_get_info(_sprite);
            
            var _framesArray = _spriteInfo.frames;
            var _textureIndex = _framesArray[0].texture;
            var _texturePointer = sprite_get_texture(_sprite, 0);
            
            //Force the texture information for the font
            _fontInfo.__forcedTexturePointer = _texturePointer;
            _fontInfo.__isDynamic = false;
            
            var _texTexelW = texture_get_texel_width(_texturePointer);
            var _texTexelH = texture_get_texel_height(_texturePointer);
            
            //Check if all textures match. Scribblet doesn't support split texture pages!
            if (GM_build_type == "run")
            {
                var _i = 0;
                repeat(array_length(_framesArray))
                {
                    var _frameInfo = _framesArray[_i];
                    if (_frameInfo.texture != _textureIndex)
                    {
                        __ScribbletError("Spritefont ", sprite_get_name(_sprite), " is not on one texture");
                    }
                    
                    ++_i;
                }
            }
            
            var _extraData = _spriteFontData[$ font_get_name(_font)];
            if (_extraData == undefined)
            {
                __ScribbletError("Spritefont ", _font, " (sprite=", sprite_get_name(_sprite), ") has not been attached with ScribbletAddSpriteFont()");
            }
            
            var _proportional = _extraData.__proportional;
            var _separation   = _extraData.__separation;
            var _spriteWidth  = sprite_get_width(_sprite);
            
            var _i = 0;
            repeat(array_length(_glyphNameArray))
            {
                var _name = _glyphNameArray[_i];
                var _glyphInfo = _fontGlyphStruct[$ _name];
                var _image = _glyphInfo.char;
                var _imageInfo = _framesArray[_image];
                
                var _uvs  = sprite_get_uvs(_sprite, _image);
                var _left = round(_uvs[0] / _texTexelW);
                var _top  = round(_uvs[1] / _texTexelH);
                
                
                if (_proportional)
                {
                    var _xOffset = 0;
                    var _glyphSeparation = _imageInfo.crop_width + _separation;
                }
                else
                {            
                    var _xOffset = _imageInfo.x_offset;
                    var _glyphSeparation = _spriteWidth + _separation;
                }
                
                _glyphInfo.x       = _left;
                _glyphInfo.y       = _top;
                _glyphInfo.w       = _imageInfo.crop_width;
                _glyphInfo.h       = _imageInfo.crop_height;
                _glyphInfo.shift   = _glyphSeparation;
                _glyphInfo.offset  = _xOffset;
                _glyphInfo.yOffset = _imageInfo.y_offset;
                
                ++_i;
            }
        }
        else
        {
            //Force the texture information for the font
            _fontInfo.__forcedTexturePointer = font_get_texture(_font);
            _fontInfo.__isDynamic = _fontInfo.freetype;
            
            if (_fontInfo.sdfEnabled)
            {
                var _offset = _fontInfo.sdfSpread;
                var _i = 0;
                repeat(array_length(_glyphNameArray))
                {
                    var _name = _glyphNameArray[_i];
                    var _glyphInfo = _fontGlyphStruct[$ _name];
                    
                    _glyphInfo.offset  -=  _offset;
                    _glyphInfo.yOffset  = -_offset;
                    
                    ++_i;
                }
            }
            else
            {
                var _i = 0;
                repeat(array_length(_glyphNameArray))
                {
                    var _name = _glyphNameArray[_i];
                    var _glyphInfo = _fontGlyphStruct[$ _name];
                    
                    _glyphInfo.yOffset = 0;
                    
                    ++_i;
                }
            }
        }
    }
    
    return _fontInfo;
}