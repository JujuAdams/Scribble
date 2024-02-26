// Feather disable all

/// Draws plain text with limited formatting but without text wrapping. Text will appear
/// immediately using GameMaker's native text rendering. Over a few frames and in the
/// background, Scribble will build a vertex buffer in the background that replaces the native
/// text rendering and is faster to draw.
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

function ScribbleFastBShrink(_x, _y, _string, _colour = c_white, _alpha = 1, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1, _maxWidth = infinity, _maxHeight = infinity)
{
    static _system = __ScribbleFastSystem();
    static _cache  = _system.__cacheTest;
    
    if (_font == undefined) _font = _system.__defaultFont;
    
    _maxWidth  = max(0, _maxWidth);
    _maxHeight = max(0, _maxHeight);
    
    var _key = string_concat(_string, ":",
                             _hAlign + 3*_vAlign, //Pack these flags together
                             _font,
                             _fontScale, ":",
                             _maxWidth, ":",
                             _maxHeight);
    
    var _struct = _cache[$ _key];
    if (_struct == undefined)
    {
        _struct = new __ScribbleClassFastBShrink(_string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight);
        _cache[$ _key] = _struct;
    }
    
    _struct.__drawMethod(_x, _y, _colour, _alpha);
}

function __ScribbleClassFastBShrink(_string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight) constructor
{
    static _system     = __ScribbleFastSystem();
    static _colourDict = _system.__colourDict;
    
    __string    = _string;
    __hAlign    = _hAlign;
    __vAlign    = _vAlign;
    __font      = _font;
    __scale     = _fontScale;
    __fontScale = _fontScale;
    
    __fontSDFSpread = undefined;
    __drawMethod    = __DrawNative;
        
    __spriteArray   = [];
    __fragArray     = [];
    __vertexBuffer  = undefined;
    __vertexBuilder = new __ScribbleClassFastBuilderB(__fragArray, _font);
    __fontTexture   = font_get_texture(_font);
    
    var _substringArray = string_split(__string, "[");
    if (array_length(_substringArray) <= 1) 
    {
        //No square brackets, fall back on simple rendering
        
        var _width  = string_width(__string);
        var _height = string_height(__string);
        __scale = min(1, _maxWidth/_width, _maxHeight/_height);
        
        switch(__hAlign)
        {
            case fa_left:   __xOffset = 0;                 break;
            case fa_center: __xOffset = -__scale*_width/2; break;
            case fa_right:  __xOffset = -__scale*_width;   break;
        }
        
        switch(__vAlign)
        {
            case fa_top:    __yOffset = 0;                  break;
            case fa_middle: __yOffset = -__scale*_height/2; break;
            case fa_bottom: __yOffset = -__scale*_height;   break;
        }
        
        __drawMethod = (__scale == 1)? __DrawSimple : __DrawSimpleScaled;
        
        //Add a spoofed fragment so the vertex buffer builder has something to work on
        array_push(__fragArray, {
            __colour: -1,
            __string: __string,
            __x: 0,
        });
    }
    else
    {
        var _lineHeight = string_height(" ");
        
        //Handle the first text fragment
        var _textString = _substringArray[0];
        if (_textString != "")
        {
            array_push(__fragArray, {
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
                            __x: _spriteX + _x + sprite_get_xoffset(_sprite)/_fontScale,
                            __y: _spriteY + 0.5*(_lineHeight - sprite_get_height(_sprite)/_fontScale) + sprite_get_yoffset(_sprite)/_fontScale,
                        });
                        
                        _x += sprite_get_width(_sprite);
                    }
                    else
                    {
                        Trace("Command tag \"", _tagString, "\" not recognised");
                    }
                }
                
                //Then we handle the next text fragment
                var _textString = _tagSplitArray[1];
                if (_textString != "")
                {
                    array_push(__fragArray, {
                        __colour: _colour,
                        __string: _tagSplitArray[1],
                        __x: _x,
                    });
                    
                    _x += string_width(_textString);
                }
            }
            
            ++_i;
        }
        
        var _width  = _x;
        var _height = _lineHeight;
        __scale = min(1, _maxWidth/_width, _maxHeight/_height);
        
        switch(__hAlign)
        {
            case fa_left:   __xOffset = 0;                 break;
            case fa_center: __xOffset = -__scale*_width/2; break;
            case fa_right:  __xOffset = -__scale*_width;   break;
        }
        
        switch(__vAlign)
        {
            case fa_top:    __yOffset = 0;                  break;
            case fa_middle: __yOffset = -__scale*_height/2; break;
            case fa_bottom: __yOffset = -__scale*_height;   break;
        }
    }
    
    if (SCRIBBLE_FAST_VERBOSE) Trace("Created ", self);
    
    
    
    
    
    static __DrawSimple = function(_x, _y, _colour, _alpha)
    {
        draw_set_font(__font);
        draw_set_colour(_colour);
        draw_set_alpha(_alpha);
        draw_set_halign(__hAlign);
        draw_set_valign(__vAlign);
        
        draw_text(_x, _y, __string);
        __BuildVertexBuffer();
        
        if (SCRIBBLE_FAST_RESET_DRAW_STATE) ScribbleResetFontState();
    }
    
    static __DrawSimpleScaled = function(_x, _y, _colour, _alpha)
    {
        draw_set_font(__font);
        draw_set_colour(_colour);
        draw_set_alpha(_alpha);
        draw_set_halign(__hAlign);
        draw_set_valign(__vAlign);
        
        draw_text_transformed(_x, _y, __string, __scale, __scale, 0);
        __BuildVertexBuffer();
        
        if (SCRIBBLE_FAST_RESET_DRAW_STATE) ScribbleResetFontState();
    }
    
    static __DrawNative = function(_x, _y, _colour, _alpha)
    {
        draw_set_font(__font);
        draw_set_alpha(_alpha);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        var _scale = __scale;
        _x += __xOffset;
        _y += __yOffset;
        
        var _i = 0;
        repeat(array_length(__fragArray))
        {
            with(__fragArray[_i])
            {
                draw_set_colour((__colour >= 0)? __colour : _colour);
                draw_text_transformed(_x + _scale*__x, _y, __string, _scale, _scale, 0);
            }
            
            ++_i;
        }
        
        __DrawSprites(_x, _y, _alpha);
        
        __BuildVertexBuffer();
        
        if (SCRIBBLE_FAST_RESET_DRAW_STATE) ScribbleResetFontState();
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
    
    
    
    
    
    static __BuildVertexBuffer = function()
    {
        if (_system.__budgetUsed >= _system.__budget) return;
        var _timer = get_timer();
        
        if (__vertexBuilder != undefined) && (__vertexBuilder.__tickMethod())
        {
            if (SCRIBBLE_FAST_VERBOSE) Trace("Compiled ", self);
            __vertexBuffer  = __vertexBuilder.__vertexBuffer;
            __drawMethod    = (__vertexBuilder.__fontSDFSpread == undefined)? __DrawVertexBuffer : __DrawVertexBufferSDF;
            __vertexBuilder = undefined;
        }
        
        _system.__budgetUsed += get_timer() - _timer;
    }
    
    static __DrawVertexBuffer = function(_x, _y, _colour, _alpha)
    {
        static _shdScribbleFastB_u_vPositionAlphaScale = shader_get_uniform(__shdScribbleFastB, "u_vPositionAlphaScale");
        static _shdScribbleFastB_u_iColour = shader_get_uniform(__shdScribbleFastB, "u_iColour");
        
        _x += __xOffset;
        _y += __yOffset;
        
        shader_set(__shdScribbleFastB);
        shader_set_uniform_f(_shdScribbleFastB_u_vPositionAlphaScale, _x, _y, _alpha, __scale);
        shader_set_uniform_i(_shdScribbleFastB_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
        
        //Lean into GameMaker's native renderer for sprites
        __DrawSprites(_x, _y, _alpha);
    }
    
    static __DrawVertexBufferSDF = function(_x, _y, _colour, _alpha)
    {
        static _shdScribbleFastB_SDF_u_vPositionAlphaScale = shader_get_uniform(__shdScribbleFastB_SDF, "u_vPositionAlphaScale");
        static _shdScribbleFastB_SDF_u_iColour = shader_get_uniform(__shdScribbleFastB_SDF, "u_iColour");
        
        _x += __xOffset;
        _y += __yOffset;
        
        shader_set(__shdScribbleFastB_SDF);
        shader_set_uniform_f(_shdScribbleFastB_SDF_u_vPositionAlphaScale, _x, _y, _alpha, __scale);
        shader_set_uniform_i(_shdScribbleFastB_SDF_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
        
        //Lean into GameMaker's native renderer for sprites
        __DrawSprites(_x, _y, _alpha);
    }
}