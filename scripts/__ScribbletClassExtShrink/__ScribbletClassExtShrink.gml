/// @param key
/// @param string
/// @param hAlign
/// @param vAlign
/// @param font
/// @param fontScale
/// @param maxWidth
/// @param maxHeight

function __ScribbletClassExtShrink(_key, _string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight) constructor
{
    static _system     = __ScribbletSystem();
    static _colourDict = _system.__colourDict;
    
    __wrapper = undefined;
    __lastDraw = current_time;
    
    __key       = _key;
    __string    = _string;
    __hAlign    = _hAlign;
    __vAlign    = _vAlign;
    __font      = _font;
    __scale     = _fontScale;
    __fontScale = _fontScale;
    
    __fontIsDynamic = __ScribbletGetFontInfo(_font).__isDynamic;
    
    Draw = __DrawNative;
        
    __spriteArray   = [];
    __fragmentArray     = [];
    __vertexBuffer  = undefined;
    __vertexBuilder = new __ScribbletClassBuilderExt(__fragmentArray, _font);
    __fontTexture   = __ScribbletGetFontInfo(_font).__forcedTexturePointer;
    
    if (SCRIBBLET_RESET_DRAW_STATE) var _oldFont = draw_get_font();
    draw_set_font(__font);
    
    var _substringArray = string_split(__string, "[");
    if (array_length(_substringArray) <= 1) 
    {
        //No square brackets, fall back on simple rendering
        
        __width   = string_width(__string);
        __height  = string_height(__string);
        __scale   = min(1, _maxWidth/__width, _maxHeight/__height);
        __width  *= __scale;
        __height *= __scale;
        
        switch(__hAlign)
        {
            case fa_left:   __xOffset = 0;          break;
            case fa_center: __xOffset = -__width/2; break;
            case fa_right:  __xOffset = -__width;   break;
        }
        
        switch(__vAlign)
        {
            case fa_top:    __yOffset = 0;           break;
            case fa_middle: __yOffset = -__height/2; break;
            case fa_bottom: __yOffset = -__height;   break;
        }
        
        Draw = (__scale == 1)? __DrawSimple : __DrawSimpleScaled;
        
        //Add a spoofed fragment so the vertex buffer builder has something to work on
        array_push(__fragmentArray, {
            __colour: -1,
            __string: __string,
            __x: 0,
        });
    }
    else
    {
        var _spriteScale = SCRIBBLET_SCALE_SPRITES? 1 : (1/_fontScale);
        var _lineHeight  = __ScribbletGetSpaceHeight(_font);
        
        //Handle the first text fragment
        var _textString = _substringArray[0];
        if (_textString != "")
        {
            array_push(__fragmentArray, {
                __colour: -1,
                __string: _textString,
                __x: 0,
            });
            
            var _x = string_width(_textString);
        }
        else
        {
            var _x = 0;
        }
        
        var _colour = -1;
        
        //Then iterate other command tag + text fragment combos, splitting as necessary
        var _i = 1;
        repeat(array_length(_substringArray)-1)
        {
            var _tagSplitArray = string_split(_substringArray[_i], "]", false, 1);
            if (array_length(_tagSplitArray) == 2)
            {
                //Handle the contents of the tag
                var _tagString = _tagSplitArray[0];
                
                //First we try to find the colour state
                var _foundColour = _colourDict[$ _tagString];
                if (_foundColour != undefined)
                {
                    _colour = _foundColour;
                }
                else
                {
                    var _spriteSplitArray = string_split(_tagString, ",");
                    
                    //Then we try to find a sprite using the command tag
                    var _sprite = asset_get_index(_spriteSplitArray[0]);
                    if (sprite_exists(_sprite))
                    {
                        //Decode sprite arguments
                        switch(array_length(_spriteSplitArray))
                        {
                            case 1:
                                var _spriteImage = 0;
                                var _spriteX     = 0;
                                var _spriteY     = 0;
                            break;
                            
                            case 2:
                                var _spriteImage = real(_spriteSplitArray[1]);
                                var _spriteX     = 0;
                                var _spriteY     = 0;
                            break;
                            
                            case 3:
                                var _spriteImage = real(_spriteSplitArray[1]);
                                var _spriteX     = real(_spriteSplitArray[2]);
                                var _spriteY     = 0;
                            break;
                            
                            case 4:
                                var _spriteImage = real(_spriteSplitArray[1]);
                                var _spriteX     = real(_spriteSplitArray[2]);
                                var _spriteY     = real(_spriteSplitArray[3]);
                            break;
                        }
                        
                        array_push(__spriteArray, {
                            __sprite: _sprite,
                            __image: _spriteImage,
                            __x: _spriteX + _x + _spriteScale*sprite_get_xoffset(_sprite),
                            __y: _spriteY + 0.5*(_lineHeight - _spriteScale*sprite_get_height(_sprite)) + _spriteScale*sprite_get_yoffset(_sprite),
                        });
                        
                        _x += _spriteScale*sprite_get_width(_sprite);
                    }
                    else
                    {
                        __ScribbletTrace("Command tag \"", _tagString, "\" not recognised");
                    }
                }
                
                //Then we handle the next text fragment
                var _textString = _tagSplitArray[1];
                if (_textString != "")
                {
                    array_push(__fragmentArray, {
                        __colour: _colour,
                        __string: _tagSplitArray[1],
                        __x: _x,
                    });
                    
                    _x += string_width(_textString);
                }
            }
            
            ++_i;
        }
        
        __width   = __fontScale*_x;
        __height  = __fontScale*_lineHeight;
        __scale   = min(1, _maxWidth/__width, _maxHeight/__height);
        __width  *= __scale;
        __height *= __scale;
        
        switch(__hAlign)
        {
            case fa_left:   __xOffset = 0;          break;
            case fa_center: __xOffset = -__width/2; break;
            case fa_right:  __xOffset = -__width;   break;
        }
        
        switch(__vAlign)
        {
            case fa_top:    __yOffset = 0;           break;
            case fa_middle: __yOffset = -__height/2; break;
            case fa_bottom: __yOffset = -__height;   break;
        }
    }
    
    if (SCRIBBLET_RESET_DRAW_STATE) draw_set_font(_oldFont);
    if (SCRIBBLET_VERBOSE) __ScribbletTrace("Created ", self);
    if (not SCRIBBLET_PROGRESSIVE_BUILD) __BuildVertexBuffer();
    
    
    
    
    
    static toString = function()
    {
        return __key;
    }
    
    static GetWidth = function()
    {
        return __width;
    }
    
    static GetHeight = function()
    {
        return __height;
    }
    
    
    
    
    
    static __DrawSimple = function(_x, _y, _colour = c_white, _alpha = 1, _forceNative = SCRIBBLET_DEFAULT_FORCE_NATIVE)
    {
        draw_set_font(__font);
        draw_set_colour(_colour);
        draw_set_alpha(_alpha);
        draw_set_halign(__hAlign);
        draw_set_valign(__vAlign);
        
        draw_text(_x, _y, __string);
        if (not _forceNative) __BuildVertexBufferTimed();
        
        if (SCRIBBLET_RESET_DRAW_STATE) ScribbletResetDrawState();
    }
    
    static __DrawSimpleScaled = function(_x, _y, _colour = c_white, _alpha = 1, _forceNative = SCRIBBLET_DEFAULT_FORCE_NATIVE)
    {
        draw_set_font(__font);
        draw_set_colour(_colour);
        draw_set_alpha(_alpha);
        draw_set_halign(__hAlign);
        draw_set_valign(__vAlign);
        
        draw_text_transformed(_x, _y, __string, __scale, __scale, 0);
        if (not _forceNative) __BuildVertexBufferTimed();
        
        if (SCRIBBLET_RESET_DRAW_STATE) ScribbletResetDrawState();
    }
    
    static __DrawNative = function(_x, _y, _colour = c_white, _alpha = 1, _forceNative = SCRIBBLET_DEFAULT_FORCE_NATIVE)
    {
        draw_set_font(__font);
        draw_set_alpha(_alpha);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        var _scale = __scale*__fontScale;
        _x += __xOffset;
        _y += __yOffset;
        
        var _i = 0;
        repeat(array_length(__fragmentArray))
        {
            with(__fragmentArray[_i])
            {
                draw_set_colour((__colour >= 0)? __colour : _colour);
                draw_text_transformed(_x + _scale*__x, _y, __string, _scale, _scale, 0);
            }
            
            ++_i;
        }
        
        __DrawSprites(_x, _y, _alpha);
        
        if (not _forceNative) __BuildVertexBufferTimed();
        
        if (SCRIBBLET_RESET_DRAW_STATE) ScribbletResetDrawState();
    }
    
    static __DrawSprites = function(_x, _y, _alpha)
    {
        var _textScale   = __scale*__fontScale;
        var _spriteScale = SCRIBBLET_SCALE_SPRITES? _textScale : __scale;
        
        var _i = 0;
        repeat(array_length(__spriteArray))
        {
            with(__spriteArray[_i])
            {
                draw_sprite_ext(__sprite, __image, _x + _textScale*__x, _y + _textScale*__y, _spriteScale, _spriteScale, 0, c_white, _alpha);
            }
            
            ++_i;
        }
    }
    
    
    
    
    
    static __BuildVertexBufferTimed = function()
    {
        if (__fontIsDynamic) return; //Don't bake dynamic fonts
        if (_system.__budgetUsed >= _system.__budget) return; //Don't exceed the baking budget
        
        var _timer = get_timer();
        __BuildVertexBuffer();
        _system.__budgetUsed += get_timer() - _timer;
    }
    
    static __BuildVertexBuffer = function()
    {
        if (__fontIsDynamic) return; //Don't bake dynamic fonts
        
        if (__vertexBuilder != undefined) && (__vertexBuilder.__tickMethod())
        {
            if (SCRIBBLET_VERBOSE) __ScribbletTrace("Compiled ", self);
            __vertexBuffer = __vertexBuilder.__vertexBuffer;
            Draw = __ScribbletGetFontInfo(__font).sdfEnabled? __DrawVertexBufferSDF : __DrawVertexBuffer;
            __vertexBuilder = undefined;
        }
    }
    
    static __DrawVertexBuffer = function(_x, _y, _colour = c_white, _alpha = 1, _forceNative_UNUSED)
    {
        static _shdScribbletExt_u_vPositionAlphaScale = shader_get_uniform(__shdScribbletColor, "u_vPositionAlphaScale");
        static _shdScribbletExt_u_iColour = shader_get_uniform(__shdScribbletColor, "u_iColour");
        
        _x += __xOffset;
        _y += __yOffset;
        
        shader_set(__shdScribbletColor);
        shader_set_uniform_f(_shdScribbletExt_u_vPositionAlphaScale, _x, _y, _alpha, __scale*__fontScale);
        shader_set_uniform_i(_shdScribbletExt_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
        
        //Lean into GameMaker's native renderer for sprites
        __DrawSprites(_x, _y, _alpha);
    }
    
    static __DrawVertexBufferSDF = function(_x, _y, _colour = c_white, _alpha = 1, _forceNative_UNUSED)
    {
        static _shdScribbletExt_SDF_u_vPositionAlphaScale = shader_get_uniform(__shdScribbletColorSDF, "u_vPositionAlphaScale");
        static _shdScribbletExt_SDF_u_iColour = shader_get_uniform(__shdScribbletColorSDF, "u_iColour");
        
        _x += __xOffset;
        _y += __yOffset;
        
        shader_set(__shdScribbletColorSDF);
        shader_set_uniform_f(_shdScribbletExt_SDF_u_vPositionAlphaScale, _x, _y, _alpha, __scale*__fontScale);
        shader_set_uniform_i(_shdScribbletExt_SDF_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
        
        //Lean into GameMaker's native renderer for sprites
        __DrawSprites(_x, _y, _alpha);
    }
    
    
    
    
    
    static __Destroy = function()
    {
        if (__vertexBuilder != undefined)
        {
            __vertexBuilder.__Destroy();
            __vertexBuilder = undefined;
        }
        
        if (__vertexBuffer != undefined)
        {
            vertex_delete_buffer(__vertexBuffer);
            __vertexBuffer = undefined;
        }
    }
}