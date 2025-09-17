// Feather disable all

/// @param fontName
/// @param glyphCount
/// @param renderType
/// @param fromBundle
/// @param texelsValid
/// @param underlineY
/// @param strikeY

function __ScribbleClassFont(_name, _glyphCount, _renderType, _fromBundle, _texelsValid, _underlineY, _strikeY) constructor
{
    //The name of the font. This is the alias used to reference the font elsewhere
    __name = _name;
    
    //One of the `__SCRIBBLE_RENDER_*` macros. Largely used to determine which shader path to use
    __renderType = _renderType;
    
    //Whether the source texture data exists in the asset bundle. If set to `false`, the source
    //texture data was added at runtime (probably with `sprite_add()`). This value can be `undefined`
    //if the origin is not known (typically spritefonts).
    __fromBundle = _fromBundle;
    
    //Whether the source texture is ready - loaded into RAM and fetched into VRAM
    __texelsValid = _texelsValid;
    
    //Position of the underline/strike-through relative to the top of the line
    __underlineY = _underlineY; //*Not* the raw value. This value is changed by scribble_font_scale()
    __strikeY    = _strikeY;    //*Not* the raw value. This value is changed by scribble_font_scale()
    
    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    _fontDataMap[? _name] = self;
    
    __glyphDataGrid = ds_grid_create(_glyphCount, __SCRIBBLE_GLYPH_PROPR_COUNT);
    __glyphsMap     = ds_map_create();
    __kerningMap    = ds_map_create();
    __ligatureMap   = ds_map_create();
    
    __isKrutidev = false;
    __bilinear    = (__renderType == __SCRIBBLE_RENDER_SDF)? true : undefined;
    
    __superfont    = false;
    __runtime      = false;
    __sourceSprite = undefined;
    __remap        = undefined;
    
    __scale  = 1.0;
    __height = 0; //*Not* the raw height. This value is changed by scribble_font_scale()
    
    __halignOffsetArray = [0, 0, 0,   0, 0, 0, 0];
    __valignOffsetArray = [0, 0, 0,   0, 0, 0];
    
    __styleRegular    = undefined;
    __styleBold       = undefined;
    __styleItalic     = undefined;
    __styleBoldItalic = undefined;
    
    
    
    
    
    static __CopyTo = function(_target, _copyStyles)
    {
        var _names = variable_struct_get_names(self);
        var _i = 0;
        repeat(array_length(_names))
        {
            var _name = _names[_i];
            if (_name == "__glyphsMap")
            {
                ds_map_copy(_target.__glyphsMap, __glyphsMap);
            }
            else if (_name == "__glyphDataGrid")
            {
                ds_grid_copy(_target.__glyphDataGrid, __glyphDataGrid);
            }
            else if ((_name != "__name")
                  && (_name != "__fromBundle")
                  && (_copyStyles || ((_name != "__styleRegular") && (_name != "__styleBold") && (_name != "__styleItalic") && (_name != "__styleBoldItalic"))))
            {
                variable_struct_set(_target, _name, variable_struct_get(self, _name));
            }
            
            ++_i;
        }
    }
    
    static __clear = function()
    {
        if (not __superfont) __ScribbleError("Cannot clear non-superfont fonts");
        
        ds_map_clear(__glyphsMap);
        
        __height = 0;
        __texelsValid = false;
    }
    
    static __EnsureMaterialTexturesFetched = function()
    {
        //N.B. This is an expensive function! Use sparingly
        
        var _glyphDataGrid = __glyphDataGrid;
        var _glyphCount = ds_grid_width(_glyphDataGrid);
        
        //TODO - Use some kind of cool optimization if the font is a standard font and every glyph has the same material
        
        var _i = 0;
        repeat(_glyphCount)
        {
            var _material = _glyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_MATERIAL];
            var _textureIndex = _material.__texture;
            if (_textureIndex != undefined)
            {
                texture_prefetch(_textureIndex);
            }
            
            ++_i;
        }
    }
    
    static __EnsureTexelData = function()
    {
        if (__texelsValid) return;
        
        var _glyphDataGrid = __glyphDataGrid;
        var _glyphCount = ds_grid_width(_glyphDataGrid);
        
        if (not ds_grid_value_exists(_glyphDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID, _glyphCount-1, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID, false))
        {
            //Don't do any extra work if every texel is valid
            __texelsValid = true;
            return;
        }
        
        //TODO - Use some kind of cool optimization if the font is a standard font and every glyph has the same material
        
        var _allReady = true;
        var _i = 0;
        repeat(_glyphCount)
        {
            if (not _glyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID])
            {
                var _material = _glyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_MATERIAL];
                
                var _textureIndex = _material.__texture;
                if ((_textureIndex != undefined) && texture_is_ready(_textureIndex))
                {
                    _glyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID] = true;
                    
                    var _texel_w = texture_get_texel_width(_textureIndex);
                    var _texel_h = texture_get_texel_height(_textureIndex);
                    
                    _glyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U0] *= _texel_w;
                    _glyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V0] *= _texel_h;
                    _glyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_U1] *= _texel_w;
                    _glyphDataGrid[# _i, __SCRIBBLE_GLYPH_PROPR_V1] *= _texel_h;
                }
                else
                {
                    _allReady = false;
                }
            }
            
            ++_i;
        }
        
        if (_allReady)
        {
            __texelsValid = true;
        }
    }
    
    static __EnsureAdditionalCharacters = function()
    {
        if (not ds_map_exists(__glyphsMap, ord(SCRIBBLE_MISSING_CHARACTER)))
        {
            __ScribbleTrace("Couldn't find \"missing character\" glyph data, character code ", ord(SCRIBBLE_MISSING_CHARACTER), " (", SCRIBBLE_MISSING_CHARACTER, ") in font \"", __name, "\"");
            __glyphsMap[? ord(SCRIBBLE_MISSING_CHARACTER)] = __glyphsMap[? SCRIBBLE_UNICODE_ZWSP];
        }
    }
    
    static __Destroy = function()
    {
        if (__SCRIBBLE_DEBUG) __ScribbleTrace("Destroying font \"", __name, "\"");
        
        ds_map_destroy(__glyphsMap);
        ds_grid_destroy(__glyphDataGrid);
        
        ds_map_delete(_fontDataMap, __name);
        
        if (__sourceSprite != undefined)
        {
            sprite_delete(__sourceSprite);
            __sourceSprite = undefined;
        }
    }
}
