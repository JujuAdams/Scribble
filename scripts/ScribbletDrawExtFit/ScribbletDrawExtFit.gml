// Feather disable all

/// Draws plain text with limited formatting. The text is shrunk down to within the given maximum
/// width and height by reflowing the text at a smaller size. Text will appear immediately
/// using GameMaker's native text rendering. Over a few frames and in the  background, Scribble
/// will build a vertex buffer in the background that replaces the native text rendering and is
/// faster to draw.
/// 
/// N.B. Manual line breaks ("newlines") are not supported.
/// 
/// This function relies on internal caching for performance gains. If you change any of the
/// following arguments, Scribble will have to do extra work to recache the new text data. Try to
/// limit how often you change these variables to get the best performance.
///     - string
///     - hAlign
///     - vAlign
///     - font
///     - fontScale
///     - maxWidth
///     - maxHeight
/// 
/// Two types of formatting command are supported:
/// 
/// 1. Partial Text Colouring
///     "This is [c_orange]orange[/c] text."
///     Tags that contain the name of a colour constant will colour subsequent characters in the
///     string. [/c] [/color] [/colour] can be used to reset the colour to the default colour for
///     the function call.
/// 
/// 2. In-line Sprites
///     "You need [sprCoin]100 to buy this bomb."
///     Sprites can be inserted by using the name of the sprite in between two square brackets.
///     Inserted sprites cannot be animated and show only one image at a time. By default, image 0
///     is shown.
///     
///     "You've found [sprFairy,0][sprFairy,1][sprFairy,2]"
///     By adding a second parameter to that tag, a different subimage in a sprite can be inserted.
///     
///     "Wow, magical! [sprSparke,0,0,4][sprSparke,0,0,0][sprSparke,0,0,-4]"
///     You may also specify a third and fourth parameter which acts as an x/y offset for the
///     sprite image. In this case, three images are displayed in a diagonal line from bottom to
///     top, going left to right. This feature is helpful for adjusting sprite positions to line
///     up better with text.
/// 
/// @param x
/// @param y
/// @param string
/// @param [colour=white]
/// @param [alpha=1]
/// @param [hAlign=left]
/// @param [vAlign=top]
/// @param [font]
/// @param [fontScale=1]
/// @param [width]
/// @param [height]
/// @param [forceNative=false]

function ScribbletDrawExtFit(_x, _y, _string, _colour = c_white, _alpha = 1, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1, _maxWidth = infinity, _maxHeight = infinity, _forceNative = SCRIBBLET_DEFAULT_FORCE_NATIVE)
{
    static _system = __ScribbletSystem();
    static _cache  = _system.__elementsCache;
    static _array  = _system.__elementsArray;
    
    if ((_string == "") || (_maxWidth < 0) || (_maxHeight < 0)) return;
    if (_font == undefined) _font = _system.__defaultFont;
    
    var _key = string_concat(_string, ":",
                             _hAlign + 3*_vAlign, ":", //Pack these flags together
                             _font, ":",
                             _fontScale, ":",
                             _maxWidth, ":",
                             _maxHeight, ":E");
    
    var _struct = _cache[$ _key];
    if (_struct == undefined)
    {
        _struct = new __ScribbletClassExtFit(_key, _string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight);
        _cache[$ _key] = _struct;
        array_push(_array, _struct);
    }
    
    _struct.__drawMethod(_x, _y, _colour, _alpha, _forceNative);
    _struct.__lastDraw = current_time;
    return _struct;
}

function __ScribbletClassExtFit(_key, _string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight) constructor
{
    static _system     = __ScribbletSystem();
    static _colourDict = _system.__colourDict;
    
    __key       = _key;
    __string    = _string;
    __hAlign    = _hAlign;
    __vAlign    = _vAlign;
    __font      = _font;
    __scale     = _fontScale;
    __fontScale = _fontScale;
    
    __fragArray     = [];
    __spriteArray   = [];
    __vertexBuffer  = undefined;
    __vertexBuilder = new __ScribbletClassBuilderExt(__fragArray, _font);
    __fontTexture   = font_get_texture(_font);
    
    var _layoutArray = [];
    
    __width  = undefined;
    __height = undefined;
    
    __drawMethod = __DrawNative;
    
    if (SCRIBBLET_RESET_DRAW_STATE) var _oldFont = draw_get_font();
    draw_set_font(_font);
    
    var _spaceWidth = __ScribbletGetSpaceWidth(_font);
    var _lineHeight = __ScribbletGetSpaceHeight(_font);
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
                            __xOffset: _spriteX + sprite_get_xoffset(_sprite)/_fontScale,
                            __yOffset: _spriteY + 0.5*(_lineHeight - sprite_get_height(_sprite)/_fontScale) + sprite_get_yoffset(_sprite)/_fontScale,
                            __width: sprite_get_width(_sprite)/_fontScale,
                            __whitespaceFollows: string_starts_with(_textString, " "),
                            __scale: 1/_fontScale,
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
                        array_push(__fragArray, _fragment);
                    }
                    
                    ++_j;
                }
            }
        }
        
        ++_i;
    }
    
    _layoutArray[array_length(_layoutArray)-1].__whitespaceFollows = true;
    
    var _overallWidth = 0;
    
    var _upperScale = _fontScale;
    var _lowerScale = 0;
    var _tryScale   = _upperScale;
    
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
        
        if (_iterations >= SCRIBBLET_FIT_ITERATIONS-1)
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
    
    __scale  = _lowerScale;
    __width  = __scale*_overallWidth;
    __height = __scale*_height;
    
    __xOffset = 0;
    __yOffset = 0;
    
    __vertexBuffer  = undefined;
    __fontTexture   = font_get_texture(_font);
    __vertexBuilder = new __ScribbletClassBuilderExtFit(__fragArray, _font);
    
    if (SCRIBBLET_RESET_DRAW_STATE) draw_set_font(_oldFont);
    if (SCRIBBLET_VERBOSE) __ScribbletTrace("Created ", self);
    if (not SCRIBBLET_PROGRESSIVE_BUILD) __BuildVertexBuffer();
    
    
    
    
    
    static GetWidth = function()
    {
        return __width;
    }
    
    static GetHeight = function()
    {
        return __height;
    }
    
    
    
    
    
    static __DrawNative = function(_x, _y, _colour, _alpha, _forceNative)
    {
        draw_set_font(__font);
        draw_set_alpha(_alpha);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        var _scale = __scale;
        
        var _i = 0;
        repeat(array_length(__fragArray))
        {
            with(__fragArray[_i])
            {
                draw_set_colour((__colour >= 0)? __colour : _colour);
                draw_text_transformed(_x + _scale*__x, _y + _scale*__y, __string, _scale, _scale, 0);
            }
            
            ++_i;
        }
        
        __DrawSprites(_x, _y, _alpha);
        
        if (not _forceNative) __BuildVertexBufferTimed();
        
        if (SCRIBBLET_RESET_DRAW_STATE) ScribbletResetDraw();
    }
    
    static __DrawSprites = function(_x, _y, _alpha)
    {
        var _fontScale = __fontScale;
        var _scale     = __scale;
        
        var _i = 0;
        repeat(array_length(__spriteArray))
        {
            with(__spriteArray[_i])
            {
                draw_sprite_ext(__sprite, __image, _x + _scale*__x, _y + _scale*__y, _scale*_fontScale, _scale*_fontScale, 0, c_white, _alpha);
            }
            
            ++_i;
        }
    }
    
    
    
    
    
    static __BuildVertexBufferTimed = function()
    {
        if (_system.__budgetUsed >= _system.__budget) return;
        var _timer = get_timer();
        __BuildVertexBuffer();
        _system.__budgetUsed += get_timer() - _timer;
    }
    
    static __BuildVertexBuffer = function()
    {
        if (__vertexBuilder != undefined) && (__vertexBuilder.__tickMethod())
        {
            if (SCRIBBLET_VERBOSE) __ScribbletTrace("Compiled ", self);
            __vertexBuffer  = __vertexBuilder.__vertexBuffer;
            __drawMethod    = (__vertexBuilder.__fontSDFSpread == undefined)? __DrawVertexBuffer : __DrawVertexBufferSDF;
            __vertexBuilder = undefined;
        }
    }
    
    static __DrawVertexBuffer = function(_x, _y, _colour, _alpha, _forceNative)
    {
        static _shdScribbletDrawExt_u_vPositionAlphaScale = shader_get_uniform(__shdScribbletColor, "u_vPositionAlphaScale");
        static _shdScribbletDrawExt_u_iColour = shader_get_uniform(__shdScribbletColor, "u_iColour");
        
        shader_set(__shdScribbletColor);
        shader_set_uniform_f(_shdScribbletDrawExt_u_vPositionAlphaScale, _x, _y, _alpha, __scale);
        shader_set_uniform_i(_shdScribbletDrawExt_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
        
        //Lean into GameMaker's native renderer for sprites
        __DrawSprites(_x, _y, _alpha);
    }
    
    static __DrawVertexBufferSDF = function(_x, _y, _colour, _alpha, _forceNative)
    {
        static _shdScribbletDrawExt_SDF_u_vPositionAlphaScale = shader_get_uniform(__shdScribbletColorSDF, "u_vPositionAlphaScale");
        static _shdScribbletDrawExt_SDF_u_iColour = shader_get_uniform(__shdScribbletColorSDF, "u_iColour");
        
        shader_set(__shdScribbletColorSDF);
        shader_set_uniform_f(_shdScribbletDrawExt_SDF_u_vPositionAlphaScale, _x, _y, _alpha, __scale);
        shader_set_uniform_i(_shdScribbletDrawExt_SDF_u_iColour, _colour);
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