// Feather disable all

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

function ScribbleFastD(_x, _y, _string, _colour = c_white, _alpha = 1, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1, _maxWidth = infinity, _maxHeight = infinity)
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
        _struct = new __ScribbleClassFastD(_string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight);
        _cache[$ _key] = _struct;
    }
    
    _struct.__drawMethod(_x, _y, _colour, _alpha);
}

function __ScribbleClassFastD(_string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight) constructor
{
    static _colourDict    = __ScribbleFastSystem().__colourDict;
    static _fitSafeMode   = true;
    static _fitIterations = 6;
    
    __string = _string;
    __hAlign = _hAlign;
    __vAlign = _vAlign;
    __font   = _font;
    __scale  = _fontScale;
    
    __xOffset = 0;
    __yOffset = 0;
    
    __fragArray     = [];
    __spriteArray   = [];
    __vertexBuffer  = undefined;
    __vertexBuilder = new __ScribbleClassFastCBuilder(__fragArray, _font);
    __fontTexture   = font_get_texture(_font);
    
    var _layoutArray = [];
    
    __drawMethod = __DrawNative;
    
    draw_set_font(_font);
    var _spaceWidth = string_width(" ");
    var _lineHeight = string_height(" ");
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
                        Trace("Command tag \"", _tagString, "\" not recognised");
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
    
    var _upperScale = _fontScale;
    var _lowerScale = 0;
    
    var _iterations = 0;
    repeat(_fitIterations)
    {
        //Bias scale search very slighty to be larger
        //This usually finds the global maxima rather than narrowing down on a local maxima
        var _tryScale = lerp(_lowerScale, _upperScale, 0.51);
        
        var _adjustedWidth  = _maxWidth/_tryScale;
        var _adjustedHeight = _maxHeight/_tryScale;
        
        var _cursorX = 0;
        var _cursorY = 0;
        
        var _stretchStart = 0;
        var _stretchWidth = 0;
        
        var _i = 0;
        repeat(array_length(_layoutArray))
        {
            var _fragment = _layoutArray[_i];
            
            _fragment.__x = _stretchWidth + _fragment.__xOffset;
            _stretchWidth += _fragment.__width;
            
            if (_fragment.__whitespaceFollows)
            {
                if ((_stretchWidth + _cursorX > _adjustedWidth) && (_cursorX != 0))
                {
                    _cursorX  = 0;
                    _cursorY += _lineHeight;
                    
                    var _j = _stretchStart;
                    repeat(1 + _i - _stretchStart)
                    {
                        with(_layoutArray[_j])
                        {
                            __y = _cursorY + __yOffset;
                        }
                        
                        ++_j;
                    }
                }
                else
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
                
                _cursorX += _stretchWidth + _spaceWidth;
                _stretchWidth = 0;
                _stretchStart = _i+1;
            }
            
            ++_i;
        }
        
        if (_cursorY + _lineHeight >= _adjustedHeight)
        {
            _upperScale = _tryScale;
        }
        else
        {
            _lowerScale = _tryScale;
        }
        
        //Ensure the final iteration causes a valid scale
        ++_iterations;
        if (_iterations >= _fitIterations-1) _upperScale = _lowerScale;
    }
    
    __scale = _lowerScale;
    
    __vertexBuffer  = undefined;
    __fontTexture   = font_get_texture(_font);
    __vertexBuilder = new __ScribbleClassFastDBuilder(__fragArray, _font);
    
    
    
    
    
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
                draw_text_transformed(_x + _scale*__x, _y + _scale*__y, __string, _scale, _scale, 0);
            }
            
            ++_i;
        }
        
        __DrawSprites(_x, _y, _alpha);
        
        __BuildVertexBuffer();
    }
    
    static __DrawSprites = function(_x, _y, _alpha)
    {
        var _scale = __scale;
        
        var _i = 0;
        repeat(array_length(__spriteArray))
        {
            with(__spriteArray[_i])
            {
                draw_sprite_ext(__sprite, __image, _x + _scale*__x, _y + _scale*__y, _scale*__scale, _scale*__scale, 0, c_white, _alpha);
            }
            
            ++_i;
        }
    }
    
    static __BuildVertexBuffer = function()
    {
        if (not global.compile) return;
        
        if (__vertexBuilder.__tickMethod())
        {
            __vertexBuffer  = __vertexBuilder.__vertexBuffer;
            __drawMethod    = (__vertexBuilder.__fontSDFSpread == undefined)? __DrawVertexBuffer : __DrawVertexBufferSDF;
            __vertexBuilder = undefined;
        }
    }
    
    static __DrawVertexBuffer = function(_x, _y, _colour, _alpha)
    {
        static _shdScribbleFastCD_u_vPositionAlphaScale = shader_get_uniform(__shdScribbleFastCD, "u_vPositionAlphaScale");
        static _shdScribbleFastCD_u_iColour = shader_get_uniform(__shdScribbleFastCD, "u_iColour");
        
        shader_set(__shdScribbleFastCD);
        shader_set_uniform_f(_shdScribbleFastCD_u_vPositionAlphaScale, _x, _y, _alpha, __scale);
        shader_set_uniform_i(_shdScribbleFastCD_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
        
        //Lean into GameMaker's native renderer for sprites
        __DrawSprites(_x, _y, _alpha);
    }
    
    static __DrawVertexBufferSDF = function(_x, _y, _colour, _alpha)
    {
        static _shdScribbleFastCD_SDF_u_vPositionAlphaScale = shader_get_uniform(__shdScribbleFastCD_SDF, "u_vPositionAlphaScale");
        static _shdScribbleFastCD_SDF_u_iColour = shader_get_uniform(__shdScribbleFastCD_SDF, "u_iColour");
        
        shader_set(__shdScribbleFastCD_SDF);
        shader_set_uniform_f(_shdScribbleFastCD_SDF_u_vPositionAlphaScale, _x, _y, _alpha, __scale);
        shader_set_uniform_i(_shdScribbleFastCD_SDF_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
        
        //Lean into GameMaker's native renderer for sprites
        __DrawSprites(_x, _y, _alpha);
    }
}

function __ScribbleClassFastDBuilder(_fragArray, _font) constructor
{
    static __vertexFormat = undefined;
    if (__vertexFormat == undefined)
    {
        vertex_format_begin();
        vertex_format_add_custom(vertex_type_float2, vertex_usage_position);
        vertex_format_add_color();
        vertex_format_add_texcoord();
        __vertexFormat = vertex_format_end();
    }
    
    __fragArray = _fragArray;
    
    __tickMethod = __DecomposeFragment;
    
    var _fontInfo = __ScribbleGetFontInfo(_font);
    __fontGlyphStruct = _fontInfo.glyphs;
    __fontSDFSpread   = _fontInfo.sdfEnabled? _fontInfo.sdfSpread : undefined;
    
    draw_set_font(_font);
    //I'd love to pull this out of the glyph data but the values we get are inaccurate
    var _spaceWidth  = string_width(" ");
    var _spaceHeight = string_height(" ");
    __spaceWidth  = _spaceWidth;
    __spaceHeight = _spaceHeight;
    
    var _fontTexture = font_get_texture(_font);
    __texTexelW = texture_get_texel_width(_fontTexture);
    __texTexelH = texture_get_texel_height(_fontTexture);
        
    __vertexBuffer = vertex_create_buffer();
    vertex_begin(__vertexBuffer, __vertexFormat);
    vertex_float2(__vertexBuffer, 0, 0); vertex_colour(__vertexBuffer, c_black, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_float2(__vertexBuffer, 0, 0); vertex_colour(__vertexBuffer, c_black, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_float2(__vertexBuffer, 0, 0); vertex_colour(__vertexBuffer, c_black, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    
    __fragment    = 0;
    __stringArray = undefined;
    __glyphX      = 0;
    __glyphY      = 0;
    
    static __DecomposeFragment = function()
    {
        var _fragmentData   = __fragArray[__fragment];
        var _fragmentString = _fragmentData.__string;
        __glyph       = 0;
        __glyphCount  = string_length(_fragmentString);
        __glyphX      = _fragmentData.__x;
        __glyphY      = _fragmentData.__y;
        __glyphColour = _fragmentData.__colour;
        
        //GameMaker needs a function to decompose a string into glyphs
        __stringArray = array_create(__glyphCount);
        string_foreach(_fragmentString, method({
            __array: __stringArray,
        }, function(_character, _position)
        {
            __array[_position-1] = _character;
        }));
        
        __tickMethod = __Tick;
        return false;
    }
    
    static __Tick = function()
    {
        var _fontSDFSpread = __fontSDFSpread ?? 0;
        var _glyphColour = __glyphColour;
        var _glyphAlpha  = (__glyphColour >= 0);
        
        repeat(1)
        {
            var _char = __stringArray[__glyph];
            if (_char == " ")
            {
                __glyphX += __spaceWidth;
            }
            else
            {
                var _glyphData = __fontGlyphStruct[$ _char];
                if (_glyphData == undefined)
                {
                    //Oh dear
                }
                else
                {
                    var _texL = _glyphData.x*__texTexelW;
                    var _texT = _glyphData.y*__texTexelH;
                    var _texR = _texL + _glyphData.w*__texTexelW;
                    var _texB = _texT + _glyphData.h*__texTexelH;
                    
                    var _glyphL = __glyphX + _glyphData.offset - _fontSDFSpread;
                    var _glyphT = __glyphY - _fontSDFSpread;
                    var _glyphR = _glyphL + _glyphData.w;
                    var _glyphB = _glyphT + _glyphData.h;
                    
                    vertex_float2(__vertexBuffer, _glyphL, _glyphT); vertex_colour(__vertexBuffer, _glyphColour, _glyphAlpha); vertex_texcoord(__vertexBuffer, _texL, _texT);
                    vertex_float2(__vertexBuffer, _glyphR, _glyphT); vertex_colour(__vertexBuffer, _glyphColour, _glyphAlpha); vertex_texcoord(__vertexBuffer, _texR, _texT);
                    vertex_float2(__vertexBuffer, _glyphL, _glyphB); vertex_colour(__vertexBuffer, _glyphColour, _glyphAlpha); vertex_texcoord(__vertexBuffer, _texL, _texB);
                    vertex_float2(__vertexBuffer, _glyphR, _glyphT); vertex_colour(__vertexBuffer, _glyphColour, _glyphAlpha); vertex_texcoord(__vertexBuffer, _texR, _texT);
                    vertex_float2(__vertexBuffer, _glyphR, _glyphB); vertex_colour(__vertexBuffer, _glyphColour, _glyphAlpha); vertex_texcoord(__vertexBuffer, _texR, _texB);
                    vertex_float2(__vertexBuffer, _glyphL, _glyphB); vertex_colour(__vertexBuffer, _glyphColour, _glyphAlpha); vertex_texcoord(__vertexBuffer, _texL, _texB);
                    
                    __glyphX += _glyphData.shift;
                }
            }
            
            __glyph++;
            if (__glyph >= __glyphCount)
            {
                __fragment++;
                if (__fragment < array_length(__fragArray))
                {
                    __tickMethod = __DecomposeFragment;
                    break;
                }
                else
                {
                    vertex_end(__vertexBuffer);
                    __tickMethod = __Freeze;
                    return false;
                }
            }
        }
        
        return false;
    }
    
    static __Freeze = function()
    {
        vertex_freeze(__vertexBuffer);
        return true;
    }
}