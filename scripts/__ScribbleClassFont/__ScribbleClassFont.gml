// Feather disable all

/// @param fontName
/// @param glyphCount
/// @param renderType
/// @param fromBundle
/// @param texelsValid
/// @param underlineY
/// @param strikeY

global.gpuBlank = gpu_get_state();

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
    
    __glyphDataGrid = ds_grid_create(_glyphCount, __SCRIBBLE_GLYPH_PROPR_SIZE);
    __glyphsMap     = ds_map_create();
    __kerningMap    = ds_map_create();
    __ligatureMap   = ds_map_create();
    
    __isKrutidev = false;
    __bilinear    = (__renderType == __SCRIBBLE_RENDER_SDF)? true : undefined;
    
    __dynamic      = false;
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
    
    //Variables used for the `font_add()` implementation
    __dynFontAsset      = undefined;
    __dynNextSlot       = 0;
    __dynFreeSlotArray  = undefined;
    __dynGlyphToSlotMap = undefined;
    __dynSurface        = undefined;
    __dynSurfaceWidth   = undefined;
    __dynSurfaceHeight  = undefined;
    __dynSlotCount      = 0;
    __dynSlotWidth      = undefined;
    __dynSlotHeight     = undefined;
    __dynSlotCountX     = undefined;
    __dynSlotCountY     = undefined;
    __dynMaterial       = undefined;
    __dynSurfaceDirty   = false;
    __dynDirtyArray     = undefined;
    __dynSlotDataGrid   = undefined;
    __dynCleanUpIndex   = infinity;
    __dynTimeSource     = undefined;
    
    
    
    
    
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
    
    static __EnsureGlyph = function(_glyph)
    {
        var _glyphDataGrid = __glyphDataGrid;
        var _dynGlyphToSlotMap = __dynGlyphToSlotMap;
        var _gridIndex = __glyphsMap[? _glyph];
        
        //Try to find a pre-existing slot that perhaps has fallen into disuse
        var _existingSlot = _dynGlyphToSlotMap[? _glyph];
        if (_existingSlot != undefined)
        {
            if (__dynSlotDataGrid[# _existingSlot, __SCRIBBLE_DYN_SLOT_DATA_GLYPH] == _glyph)
            {
                var _index = array_get_index(__dynFreeSlotArray, _existingSlot);
                if (_index >= 0) array_delete(__dynFreeSlotArray, _index, 1);
                
                _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_DYN_SLOT] = _existingSlot;
                return _existingSlot;
            }
        }
        
        var _freeSlot = array_pop(__dynFreeSlotArray);
        if (_freeSlot == undefined)
        {
            _freeSlot = __dynNextSlot;
            
            if (_freeSlot >= __dynSlotCount)
            {
                __ScribbleTrace("Warning! Run out of space on font texture page");
                _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_U0] = 0;
                _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_V0] = 0;
                _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_U1] = 0;
                _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_V1] = 0;
                return;
            }
            
            ++__dynNextSlot;
        }
        
        //Link glyph to slot and vice versa
        _dynGlyphToSlotMap[? _glyph] = _freeSlot;
        __dynSlotDataGrid[# _freeSlot, __SCRIBBLE_DYN_SLOT_DATA_GLYPH] = _glyph;
        
        var _left = 1 + (_freeSlot mod __dynSlotCountX)*__dynSlotWidth;
        var _top  = 1 + (_freeSlot div __dynSlotCountY)*__dynSlotHeight;
        
        _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_U0      ] = _left / __dynSurfaceWidth;
        _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_V0      ] = _top  / __dynSurfaceHeight;
        _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_U1      ] = (_left + _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_WIDTH ]) / __dynSurfaceWidth;
        _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_V1      ] = (_top  + _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_HEIGHT]) / __dynSurfaceHeight;
        _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_DYN_SLOT] = _freeSlot;
        
        __dynSurfaceDirty = true;
        array_push(__dynDirtyArray, _glyph, _gridIndex);
        
        return _freeSlot;
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
        
        if (__dynTimeSource != undefined)
        {
            time_source_stop(__dynTimeSource);
            time_source_destroy(__dynTimeSource);
        }
    }
    
    static __EnsureDynamicSurface = function()
    {
        static _identityMatrix = matrix_build_identity();
        
        if (not surface_exists(__dynSurface))
        {
            __ScribbleTrace($"Lost dynamic surface for font \"{__name}\", regenerating");
            
            __dynSurfaceDirty = true;
            __dynSurface = surface_create(__dynSurfaceWidth, __dynSurfaceHeight);
            
            var _wipeSurface = true;
        }
        else
        {
            var _wipeSurface = false;
        }
        
        if (not __dynSurfaceDirty)
        {
            return false;
        }
        
        __dynSurfaceDirty = false;
        
        var _glyphDataGrid = __glyphDataGrid;
        var _dynDirtyArray = __dynDirtyArray;
        
        var _surfaceWidth  = __dynSurfaceWidth;
        var _surfaceHeight = __dynSurfaceHeight;
        
        var _cellWidth  = __dynSlotWidth;
        var _cellHeight = __dynSlotHeight;
        
        gpu_push_state();
        gpu_set_state(global.gpuBlank);
        
        var _oldWorldMatrix = matrix_get(matrix_world);
        matrix_set(matrix_world, _identityMatrix);
        
        //Set font draw state. This isn't usually used but does come up when handling `font_add()` fonts
        var _oldFont   = draw_get_font();
        var _oldHAlign = draw_get_halign();
        var _oldVAlign = draw_get_valign();
        
        draw_set_font(__dynFontAsset);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        gpu_set_blendmode_ext(bm_one, bm_zero);
        
        if (_wipeSurface)
        {
            surface_set_target(__dynSurface);
            draw_clear_alpha(c_white, 0);
            surface_reset_target();
            
            var _dynDirtyArray = __dynDirtyArray;
            var _glyphsMap     = __glyphsMap;
            var _dynGlyphMap   = __dynGlyphToSlotMap;
            
            array_resize(_dynDirtyArray, 0);
            
            var _glyph = ds_map_find_first(_dynGlyphMap);
            repeat(ds_map_size(_dynGlyphMap))
            {
                array_push(_dynDirtyArray, _glyph, _glyphsMap[? _glyph]);
                _glyph = ds_map_find_next(_dynGlyphMap, _glyph);
            }
        }
        
        surface_set_target(__dynSurface);
        shader_set(__shdScribblePassthrough);
        
        var _i = 0;
        repeat(array_length(_dynDirtyArray) div 2)
        {
            var _glyph     = _dynDirtyArray[_i];
            var _gridIndex = _dynDirtyArray[_i+1];
            
            var _left = round(_glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_U0] * _surfaceWidth);
            var _top  = round(_glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_V0] * _surfaceHeight);
            
            draw_sprite_stretched_ext(__ScribblePixel, 0, _left-1, _top-1, _cellWidth, _cellHeight, c_white, 0);
            draw_text(_left - _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_DYN_X],
                      _top  - _glyphDataGrid[# _gridIndex, __SCRIBBLE_GLYPH_PROPR_DYN_Y],
                      chr(_glyph));
            
            _i += 2;
        }
        
        surface_reset_target();
        shader_reset();
        
        surface_save(__dynSurface, "test.png");
        
        draw_set_font(_oldFont);
        draw_set_halign(_oldHAlign);
        draw_set_valign(_oldVAlign);
        
        gpu_pop_state();
        matrix_set(matrix_world, _oldWorldMatrix);
        
        return true;
    }
    
    static __CreateUseGrid = function()
    {
        return ds_grid_create(__dynSlotCount, 1);
    }
}
