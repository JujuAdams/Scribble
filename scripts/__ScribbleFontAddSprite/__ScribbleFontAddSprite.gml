// Feather disable all
#macro font_add_sprite          __ScribbleFontAddSprite
#macro font_add_sprite_ext      __scribble_font_add_sprite_ext
#macro __font_add_sprite__      font_add_sprite
#macro __font_add_sprite_ext__  font_add_sprite_ext

function __ScribbleFontAddSprite(_sprite, _first, _proportional, _separation)
{
    var _spritefont = __font_add_sprite__(_sprite, _first, _proportional, _separation);
    __scribble_font_add_sprite_common(_sprite, _spritefont, _proportional, _separation);
    return _spritefont;
}

function __scribble_font_add_sprite_ext(_sprite, _mapstring, _proportional, _separation)
{
    var _spritefont = __font_add_sprite_ext__(_sprite, _mapstring, _proportional, _separation);
    __scribble_font_add_sprite_common(_sprite, _spritefont, _proportional, _separation);
    return _spritefont;
}

function __scribble_font_add_sprite_common(_sprite, _spritefont, _proportional, _separation)
{
    var _fontInfo = font_get_info(_spritefont);
    var _spriteName = sprite_get_name(_sprite);
    
    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    if (ds_map_exists(_fontDataMap, _spriteName))
    {
        __ScribbleTrace("Warning! A spritefont for \"", _spriteName, "\" has already been added. Destroying the old spritefont and creating a new one");
        _fontDataMap[? _spriteName].__Destroy();
    }
    
    var _isKrutidev = __ScribbleAssetIsKrutidev(_sprite, asset_sprite);
    var _globalGlyphBidiMap = __ScribbleSystem().__glyphData.__bidiMap;
    
    var _scribbleState = __ScribbleSystem().__state;
    if (_scribbleState.__defaultFont == undefined)
    {
        if (SCRIBBLE_VERBOSE) __ScribbleTrace("Setting default font to \"" + string(_spriteName) + "\"");
        _scribbleState.__defaultFont = _spriteName;
    }
    
    var _spriteWidth  = sprite_get_width(_sprite);
    var _spriteHeight = sprite_get_height(_sprite);
    
    var _spriteInfo = sprite_get_info(_sprite);
    var _spriteFrames = _spriteInfo.frames;
    
    var _spriteXOffset = 0;
    var _spriteYOffset = 0;
    
    if (!SCRIBBLE_SPRITEFONT_IGNORE_ORIGIN)
    {
        _spriteXOffset += sprite_get_xoffset(_sprite);
        _spriteYOffset += sprite_get_yoffset(_sprite);
    }
    
    var _infoGlyphsDict = _fontInfo.glyphs;
    var _infoGlyphNames = variable_struct_get_names(_infoGlyphsDict);
    if (SCRIBBLE_VERBOSE) __ScribbleTrace("  \"", _spriteName, "\" has ", array_length(_infoGlyphNames), " characters");
    
    var _size = array_length(_infoGlyphNames);
    
    var _underlineY = sprite_get_bbox_bottom(_sprite) + 1;
    var _strikeY    = floor(0.5*(sprite_get_bbox_bottom(_sprite) - sprite_get_bbox_top(_sprite)));
    
    var _fontData = new __ScribbleClassFont(_spriteName, _size, __SCRIBBLE_RENDER_RASTER, undefined, true, _underlineY, _strikeY);
    var _font_glyphs_map   = _fontData.__glyphsMap;
    var _fontGlyphDataGrid = _fontData.__glyphDataGrid;
    if (_isKrutidev) _fontData.__isKrutidev = true;
    
    //Set some basic repeated values in bulk for a little speed boost
    ds_grid_set_region(_fontGlyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_FONT_SCALE,   _size-1, __SCRIBBLE_GLYPH_PROPR_FONT_SCALE,   1);
    ds_grid_set_region(_fontGlyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID, _size-1, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID, true);
    
    //Also create a duplicate entry so that we can find this spritefont in draw_text_scribble()
    _fontDataMap[? font_get_name(_spritefont)] = _fontData;
    
    var _i = 0;
    repeat(_size)
    {
        var _glyph   = _infoGlyphNames[_i];
        var _unicode = ord(_glyph);
        var _image   = _infoGlyphsDict[$ _glyph].char;
        
        var _uvs = sprite_get_uvs(_sprite, _image);
        
        if (_unicode == SCRIBBLE_UNICODE_SPACE)
        {
            if (_proportional)
            {
                if (_image >= array_length(_spriteFrames)) //Cases where the space character has not been added to the mapstring
                {
                    var _spaceWidth = 1 + sprite_get_bbox_right(_sprite) - sprite_get_bbox_left(_sprite) + _separation;
                }
                else
                {
                    var _spaceWidth = _spriteFrames[_image].crop_width + _separation;
                }
            }
            else
            {
                var _spaceWidth = _spriteWidth + _separation;
            }
            
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_CHARACTER   ] = _glyph;
                                                                   
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_UNICODE     ] = _unicode;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_BIDI        ] = __SCRIBBLE_BIDI_WHITESPACE;
                                                                   
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_X_OFFSET    ] = -_spriteXOffset;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_Y_OFFSET    ] = -_spriteYOffset;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_WIDTH       ] = _spaceWidth;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_HEIGHT      ] = _spriteHeight;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT ] = _spriteHeight;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_SEPARATION  ] = _spaceWidth;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_LEFT_OFFSET ] = 0;
            //_fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_FONT_SCALE  ] = 1; //Set above in bulk
                                                                   
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_MATERIAL    ] = __ScribbleSpriteGetMaterial(_sprite, 0); //Use the material for the first image from the sprite
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U0          ] = 0;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V0          ] = 0;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U1          ] = 0;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V1          ] = 0;
            //_fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID] = _texelsValid; //Set above in bulk
            
            _font_glyphs_map[? _unicode] = _i;
        }
        else
        {
            var _imageInfo = _spriteFrames[_image];
            var _material = __ScribbleSpriteGetMaterial(_sprite, _image);
            
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
            
            if ((_unicode >= 0x3000) && (_unicode <= 0x303F)) //CJK Symbols and Punctuation
            {
                var _bidi = __SCRIBBLE_BIDI_SYMBOL;
            }
            else if ((_unicode >= 0x3040) && (_unicode <= 0x30FF)) //Hiragana and Katakana
            {
                var _bidi = __SCRIBBLE_BIDI_ISOLATED_CJK;
            }
            else if ((_unicode >= 0x4E00) && (_unicode <= 0x9FFF)) //CJK Unified ideographs block
            {
                var _bidi = __SCRIBBLE_BIDI_ISOLATED_CJK;
            }
            else if ((_unicode >= 0xFF00) && (_unicode <= 0xFF0F)) //Fullwidth symbols
            {
                var _bidi = __SCRIBBLE_BIDI_SYMBOL;
            }
            else if ((_unicode >= 0xFF1A) && (_unicode <= 0xFF1F)) //More fullwidth symbols
            {
                var _bidi = __SCRIBBLE_BIDI_SYMBOL;
            }
            else if ((_unicode >= 0xFF5B) && (_unicode <= 0xFF64)) //Yet more fullwidth symbols
            {
                var _bidi = __SCRIBBLE_BIDI_SYMBOL;
            }
            else
            {
                var _bidi = _globalGlyphBidiMap[? _unicode];
                if (_bidi == undefined) _bidi = __SCRIBBLE_BIDI_L2R;
            }
            
            if (_isKrutidev)
            {
                if (_bidi != __SCRIBBLE_BIDI_WHITESPACE)
                {
                    _bidi = __SCRIBBLE_BIDI_L2R_DEVANAGARI;
                    _unicode += __SCRIBBLE_DEVANAGARI_OFFSET;
                }
            }
            
            var _w = _imageInfo.crop_width;
            var _h = _imageInfo.crop_height;
            
            //Build an array to store this glyph's properties
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_CHARACTER   ] = _glyph;
                                                                   
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_UNICODE     ] = _unicode;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_BIDI        ] = _bidi;
                                                                   
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_X_OFFSET    ] = _xOffset - _spriteXOffset;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_Y_OFFSET    ] = _imageInfo.y_offset - _spriteYOffset;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_WIDTH       ] = _w;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_HEIGHT      ] = _h;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT ] = _spriteHeight;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_SEPARATION  ] = _glyphSeparation;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_LEFT_OFFSET ] = -_xOffset;
            //_fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_FONT_SCALE  ] = 1; //Set above in bulk
                                                                   
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_MATERIAL    ] = _material;
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U0          ] = _uvs[0];
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V0          ] = _uvs[1];
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U1          ] = _uvs[2];
            _fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V1          ] = _uvs[3];
            //_fontGlyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID] = _texelsValid; //Set above in bulk
            
            _font_glyphs_map[? _unicode] = _i;
        }
        
        ++_i;
    }
    
    var _spaceIndex = _font_glyphs_map[? SCRIBBLE_UNICODE_SPACE];
    _fontData.__height = _fontGlyphDataGrid[# _spaceIndex, __SCRIBBLE_GLYPH_PROPR_HEIGHT];
    _fontData.__EnsureAdditionalCharacters();
    
    if (SCRIBBLE_VERBOSE) __ScribbleTrace("Added \"", _spriteName, "\" as a spritefont");
    
    return _spritefont;
}
