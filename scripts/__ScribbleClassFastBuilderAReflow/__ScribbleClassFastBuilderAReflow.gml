/// @param string
/// @param font
/// @param hAlign
/// @param vAlign
/// @param wrapWidth

function __ScribbleClassFastBuilderAReflow(_string, _font, _hAlign, _vAlign, _wrapWidth) constructor
{
    static __vertexFormat = __ScribbleFastSystem().__vertexFormatA;
    
    __string    = _string;
    __hAlign    = _hAlign;
    __vAlign    = _vAlign;
    __font      = _font;
    __wrapWidth = _wrapWidth;
    
    __stringArray    = undefined;
    __nextLineBreak  = infinity;
    __lineBreakIndex = 0;
    __lineWidthArray = undefined;
    __lineBreakArray = undefined;
    __tickMethod     = __Decompose;
    
    var _fontInfo = __ScribbleGetFontInfo(_font);
    __fontGlyphStruct = _fontInfo.glyphs;
    __fontSDFSpread   = _fontInfo.sdfEnabled? _fontInfo.sdfSpread : undefined;
    __spaceWidth      = undefined;
    __spaceHeight     = undefined;
    
    var _fontTexture = font_get_texture(_font);
    __texTexelW = texture_get_texel_width(_fontTexture);
    __texTexelH = texture_get_texel_height(_fontTexture);
        
    __vertexBuffer = vertex_create_buffer();
    vertex_begin(__vertexBuffer, __vertexFormat);
    vertex_float2(__vertexBuffer, 0, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_float2(__vertexBuffer, 0, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_float2(__vertexBuffer, 0, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    
    __glyph = 0;
    __glyphCount = string_length(__string);
    __glyphX = 0;
    __glyphY = 0;
    
    
    
    
    
    static __Decompose = function()
    {
        //GameMaker needs a function to decompose a string into glyphs
        __stringArray = array_create(__glyphCount);
        string_foreach(__string, method({
            __array: __stringArray,
        }, function(_character, _position)
        {
            __array[_position-1] = _character;
        }));
        
        __tickMethod = __Layout;
        return false;
    }
    
    static __Layout = function()
    {
        var _wrapWidth = __wrapWidth;
        draw_set_font(__font);
        
        //I'd love to pull this out of the glyph data but the values we get are inaccurate
        var _spaceWidth  = string_width(" ");
        var _spaceHeight = string_height(" ");
        __spaceWidth  = _spaceWidth;
        __spaceHeight = _spaceHeight;
        
        var _wordArray   = string_split(__string, " ");
        
        __lineWidthArray = [];
        __lineBreakArray = [];
        
        var _x = 0;
        var _y = 0;
        var _index = 0;
        var _i = 0;
        repeat(array_length(_wordArray))
        {
            var _word = _wordArray[_i];
            
            var _width = string_width(_word);
            if (_x + _width > _wrapWidth)
            {
                array_push(__lineWidthArray, _x - _spaceWidth);
                array_push(__lineBreakArray, _index);
                
                _x = 0;
                _y += _spaceHeight;
            }
            
            _index += string_length(_word) + 1;
            _x += _width + _spaceWidth;
            ++_i;
        }
        
        array_push(__lineWidthArray, _x);
        array_push(__lineBreakArray, infinity);
        __nextLineBreak = __lineBreakArray[0];
        
        switch(__hAlign)
        {
            case fa_left:   __glyphX = 0;                      break;
            case fa_center: __glyphX = -__lineWidthArray[0]/2; break;
            case fa_right:  __glyphX = -__lineWidthArray[0];   break;
        }
        
        switch(__vAlign)
        {
            case fa_top:    __glyphY = 0;     break;
            case fa_middle: __glyphY = -_y/2; break;
            case fa_bottom: __glyphY = -_y;   break;
        }
        
        __tickMethod = __Tick;
    }
    
    static __Tick = function()
    {
        var _fontSDFSpread = __fontSDFSpread ?? 0;
        
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
                    
                    vertex_float2(__vertexBuffer, _glyphL, _glyphT); vertex_texcoord(__vertexBuffer, _texL, _texT);
                    vertex_float2(__vertexBuffer, _glyphR, _glyphT); vertex_texcoord(__vertexBuffer, _texR, _texT);
                    vertex_float2(__vertexBuffer, _glyphL, _glyphB); vertex_texcoord(__vertexBuffer, _texL, _texB);
                    vertex_float2(__vertexBuffer, _glyphR, _glyphT); vertex_texcoord(__vertexBuffer, _texR, _texT);
                    vertex_float2(__vertexBuffer, _glyphR, _glyphB); vertex_texcoord(__vertexBuffer, _texR, _texB);
                    vertex_float2(__vertexBuffer, _glyphL, _glyphB); vertex_texcoord(__vertexBuffer, _texL, _texB);
                    
                    __glyphX += _glyphData.shift;
                }
            }
            
            __glyph++;
            
            if (__glyph == __nextLineBreak)
            {
                __lineBreakIndex++;
                
                switch(__hAlign)
                {
                    case fa_left:   __glyphX = 0;                                     break;
                    case fa_center: __glyphX = -__lineWidthArray[__lineBreakIndex]/2; break;
                    case fa_right:  __glyphX = -__lineWidthArray[__lineBreakIndex];   break;
                }
                
                __nextLineBreak = __lineBreakArray[__lineBreakIndex];
                
                __glyphY += __spaceHeight;
            }
            
            if (__glyph >= __glyphCount)
            {
                vertex_end(__vertexBuffer);
                __tickMethod = __Freeze;
                return false;
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