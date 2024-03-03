/// @param key
/// @param string
/// @param hAlign
/// @param vAlign
/// @param font
/// @param fontScale
/// @param maxWidth
/// @param maxHeight

function __ScribbletClassExtFit(_key, _string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight) constructor
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
    
    __fragmentArray     = [];
    __spriteArray   = [];
    __vertexBuffer  = undefined;
    __vertexBuilder = new __ScribbletClassBuilderExt(__fragmentArray, _font);
    __fontTexture   = __ScribbletGetFontInfo(_font).__forcedTexturePointer;
    
    var _layoutArray = [];
    
    __width  = undefined;
    __height = undefined;
    
    Draw = __DrawNative;
    
    if (SCRIBBLET_RESET_DRAW_STATE) var _oldFont = draw_get_font();
    draw_set_font(_font);
    
    var _spriteScale = SCRIBBLET_SCALE_SPRITES? 1 : (1/_fontScale);
    var _spaceWidth  = __ScribbletGetSpaceWidth(_font);
    var _lineHeight  = __ScribbletGetSpaceHeight(_font);
    
    var _substringArray = string_split(__string, "[");
    _substringArray[0] = "]" + _substringArray[0];
    
    var _colour = -1;
    
    var _cursorX = 0;
    var _cursorY = 0;
    
    //Then iterate other command tag + text fragment combos, splitting as necessary
    var _i = 0;
    repeat(array_length(_substringArray))
    {
        var _tagSplitArray = string_split(_substringArray[_i], "]", false, 1);
        if (array_length(_tagSplitArray) == 2)
        {
            //Handle the contents of the tag
            var _tagString  = _tagSplitArray[0];
            var _textString = _tagSplitArray[1];
            
            if (_tagString != "")
            {
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
                        
                        var _fragment = {
                            __sprite: _sprite,
                            __image: _spriteImage,
                            __x: undefined,
                            __y: undefined,
                            __xOffset: _spriteX + _spriteScale*sprite_get_xoffset(_sprite),
                            __yOffset: _spriteY + 0.5*(_lineHeight - _spriteScale*sprite_get_height(_sprite)) + _spriteScale*sprite_get_yoffset(_sprite),
                            __width: _spriteScale*sprite_get_width(_sprite),
                            __whitespaceFollows: string_starts_with(_textString, " "),
                        };
                        
                        array_push(_layoutArray, _fragment);
                        array_push(__spriteArray, _fragment);
                    }
                    else
                    {
                        __ScribbletTrace("Command tag \"", _tagString, "\" not recognised");
                    }
                }
            }
            
            //Then we handle the next text fragment
            if (_textString != "")
            {
                var _splitArray = string_split(_textString, " ");
                var _splitCount = array_length(_splitArray);
                var _j = 0;
                repeat(_splitCount)
                {
                    var _substring = _splitArray[_j];
                    if (_substring != "")
                    {
                        var _fragment = {
                            __colour: _colour,
                            __string: _substring,
                            __x: undefined,
                            __y: undefined,
                            __xOffset: 0,
                            __yOffset: 0,
                            __width: string_width(_substring),
                            __whitespaceFollows: (_j < _splitCount-1),
                        };
                        
                        array_push(_layoutArray, _fragment);
                        array_push(__fragmentArray, _fragment);
                    }
                    
                    ++_j;
                }
            }
        }
        
        ++_i;
    }
    
    _layoutArray[array_length(_layoutArray)-1].__whitespaceFollows = true;
    
    var _overallWidth = 0;
    
    var _tryScale   = _fontScale;
    var _upperScale = _fontScale;
    var _lowerScale = 0.1;
    
    var _iterations = 0;
    while(_iterations < SCRIBBLET_FIT_ITERATIONS)
    {
        //TODO - Set up special "last iteration" loop
        var _lastIteration = (_iterations >= SCRIBBLET_FIT_ITERATIONS-1);
        
        var _adjustedWidth  = _maxWidth/_tryScale;
        var _adjustedHeight = _maxHeight/_tryScale;
        
        var _cursorX = 0;
        var _cursorY = 0;
        
        var _lineStart = 0;
        
        var _stretchStart = 0;
        var _stretchWidth = 0;
        
        var _i = 0;
        repeat(array_length(_layoutArray))
        {
            var _fragment = _layoutArray[_i];
            
            if (_lastIteration)
            {
                _fragment.__x = _stretchWidth + _fragment.__xOffset;
            }
            
            _stretchWidth += _fragment.__width;
            
            if (_fragment.__whitespaceFollows)
            {
                if ((_cursorX + _stretchWidth > _adjustedWidth) && (_cursorX != 0))
                {
                    if (_lastIteration)
                    {
                        _overallWidth = max(_overallWidth, _cursorX - _spaceWidth);
                        
                        //Sort out the horizontal alignment for the current line
                        if (_hAlign == fa_center)
                        {
                            var _j = _lineStart;
                            repeat(_stretchStart - _lineStart)
                            {
                                with(_layoutArray[_j]) __x -= _cursorX/2;
                                ++_j;
                            }
                        }
                        else if (_hAlign == fa_right)
                        {
                            var _j = _lineStart;
                            repeat(_stretchStart - _lineStart)
                            {
                                with(_layoutArray[_j]) __x -= _cursorX;
                                ++_j;
                            }
                        }
                        
                        _lineStart  = _stretchStart;
                    }
                    
                    _cursorX  = 0;
                    _cursorY += _lineHeight;
                    
                    if (_lastIteration)
                    {
                        var _j = _stretchStart;
                        repeat(1 + _i - _stretchStart)
                        {
                            with(_layoutArray[_j]) __y = _cursorY + __yOffset;
                            ++_j;
                        }
                    }
                }
                else //Stretch fits on the same line
                {
                    if (_lastIteration)
                    {
                        var _j = _stretchStart;
                        repeat(1 + _i - _stretchStart)
                        {
                            with(_layoutArray[_j])
                            {
                                __x += _cursorX;
                                __y  = _cursorY + __yOffset;
                            }
                            
                            ++_j;
                        }
                    }
                }
                
                _cursorX      += _stretchWidth + _spaceWidth;
                _stretchWidth  = 0;
                _stretchStart  = _i+1;
            }
            
            ++_i;
        }
        
        if (_lastIteration)
        {
            _overallWidth = max(_overallWidth, _cursorX - (_fragment.__whitespaceFollows? _spaceWidth : 0));
            
            //Sort out the horizontal alignment for the last line (only on the last iteration though)
            if ((_hAlign == fa_center) || (_hAlign == fa_right))
            {
                var _offset = (_hAlign == fa_center)? (_overallWidth/2) : _overallWidth;
                var _j = _lineStart;
                repeat(_stretchStart - _lineStart)
                {
                    with(_layoutArray[_j]) __x -= _offset;
                    ++_j;
                }
            }
        }
        
        //Determine if this iteration should be the new upper or lower bound based on whether we
        //exceeded the height limit
        var _height = _cursorY + _lineHeight;
        if (_height > _adjustedHeight)
        {
            _upperScale = _tryScale;
            
        }
        else
        {
            _lowerScale = _tryScale;
            
            //We start at the base starting scale in the first (0th) iteration. If we already fit
            //into the bounding box then we can skip a lot of iterations
            if (_iterations == 0) _iterations = SCRIBBLET_FIT_ITERATIONS-2;
        }
        
        //Ensure the final iteration uses a valid scale
        if (_iterations >= SCRIBBLET_FIT_ITERATIONS-2)
        {
            _tryScale = _lowerScale;
        }
        else
        {
            //Bias scale search very slighty to be larger
            //This usually finds the global maxima rather than narrowing down on a local maxima
            _tryScale = lerp(_lowerScale, _upperScale, 0.51);
        }
        
        ++_iterations;
    }
    
    //Adjust for vertical alignment
    if ((_vAlign == fa_middle) || (_vAlign == fa_bottom))
    {
        var _offset = (_vAlign == fa_middle)? (_height/2) : _height;
        var _i = 0;
        repeat(array_length(_layoutArray))
        {
            with(_layoutArray[_i]) __y -= _offset;
            ++_i;
        }
    }
    
    __scale  = _lowerScale / _fontScale;
    __width  = __scale*__fontScale*_overallWidth;
    __height = __scale*__fontScale*_height;
    
    __xOffset = 0;
    __yOffset = 0;
    
    __vertexBuffer  = undefined;
    __fontTexture   = __ScribbletGetFontInfo(_font).__forcedTexturePointer;
    __vertexBuilder = new __ScribbletClassBuilderExtFit(__fragmentArray, _font);
    
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
    
    
    
    
    
    static __DrawNative = function(_x, _y, _colour = c_white, _alpha = 1, _forceNative = SCRIBBLET_DEFAULT_FORCE_NATIVE)
    {
        draw_set_font(__font);
        draw_set_alpha(_alpha);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        var _scale = __scale*__fontScale;
        
        var _i = 0;
        repeat(array_length(__fragmentArray))
        {
            with(__fragmentArray[_i])
            {
                draw_set_colour((__colour >= 0)? __colour : _colour);
                draw_text_transformed(_x + _scale*__x, _y + _scale*__y, __string, _scale, _scale, 0);
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