/// @param string
/// @param font
/// @param hAlign
/// @param vAlign
/// @param wrapWidth

function __ScribbletClassBuilderFit(_string, _font, _hAlign, _vAlign, _wrapWidth) constructor
{
    static _system       = __ScribbletSystem();
    static _vertexFormat = _system.__vertexFormat;
    
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
    
    var _fontInfo = __ScribbletGetFontInfo(_font);
    __fontGlyphStruct = _fontInfo.glyphs;
    __spaceWidth      = undefined;
    __spaceHeight     = undefined;
    
    var _fontTexture = _fontInfo.__forcedTexturePointer;
    __texTexelW = texture_get_texel_width(_fontTexture);
    __texTexelH = texture_get_texel_height(_fontTexture);
        
    __vertexBuffer = vertex_create_buffer();
    vertex_begin(__vertexBuffer, _vertexFormat);
    vertex_float2(__vertexBuffer, 0, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_float2(__vertexBuffer, 0, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_float2(__vertexBuffer, 0, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    
    __glyph = 0;
    __glyphCount = string_length(__string);
    __glyphX = 0;
    __glyphY = 0;
    
    if (not SCRIBBLET_PROGRESSIVE_BUILD)
    {
        while(not __tickMethod()) {}
    }
    
    
    
    
    
    static __Destroy = function()
    {
        if (__vertexBuffer != undefined)
        {
            vertex_delete_buffer(__vertexBuffer);
            __vertexBuffer = undefined;
        }
    }
    
    
    
    
    
    static __Decompose = function()
    {
        __stringArray = __ScribbletStringDecompose(__string, __glyphCount);
        __tickMethod = __Layout;
        return false;
    }
    
    static __Layout = function()
    {
        var _wrapWidth = __wrapWidth;
        
        if (SCRIBBLET_RESET_DRAW_STATE) var _oldFont = draw_get_font();
        draw_set_font(__font);
        
        //I'd love to pull this out of the glyph data but the values we get are inaccurate
        var _spaceWidth  = __ScribbletGetSpaceWidth(__font);
        var _spaceHeight = __ScribbletGetSpaceHeight(__font);
        __spaceWidth  = _spaceWidth;
        __spaceHeight = _spaceHeight;
        
        var _wordArray = string_split(__string, " ");
        var _wordCount = array_length(_wordArray);
        
        //Remove trailing whitespace
        var _i = _wordCount-1;
        repeat(_wordCount)
        {
            if (_wordArray[_i] == "")
            {
                array_delete(_wordArray, _i, 1);
            }
            else
            {
                break;
            }
            
            --_i;
        }
        
        __lineWidthArray = [];
        __lineBreakArray = [];
        
        var _x = 0;
        var _y = 0;
        var _index = 0;
        var _i = 0;
        repeat(array_length(_wordArray))
        {
            var _word = _wordArray[_i];
            if (_word != "")
            {
                var _width = string_width(_word);
                if (_x + _width > _wrapWidth)
                {
                    array_push(__lineWidthArray, _x - _spaceWidth);
                    array_push(__lineBreakArray, _index);
                    
                    _x = 0;
                    _y += _spaceHeight;
                }
                
                _index += string_length(_word) + 1;
            }
            else
            {
                var _width = 0;
            }
            
            _x += _width + _spaceWidth;
            ++_i;
        }
        
        array_push(__lineWidthArray, _x - _spaceWidth);
        array_push(__lineBreakArray, infinity);
        __nextLineBreak = __lineBreakArray[0];
        
        var _height = _y + _spaceHeight;
        
        switch(__hAlign)
        {
            case fa_left:   __glyphX = 0;                      break;
            case fa_center: __glyphX = -__lineWidthArray[0]/2; break;
            case fa_right:  __glyphX = -__lineWidthArray[0];   break;
        }
        
        switch(__vAlign)
        {
            case fa_top:    __glyphY = 0;          break;
            case fa_middle: __glyphY = -_height/2; break;
            case fa_bottom: __glyphY = -_height;   break;
        }
        
        __tickMethod = __Tick;
        
        if (SCRIBBLET_RESET_DRAW_STATE) draw_set_font(_oldFont);
    }
    
    static __Tick = function()
    {
        repeat(SCRIBBLET_BUILD_GLYPH_ITERATIONS)
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
                    
                    var _glyphL = __glyphX + _glyphData.offset;
                    var _glyphT = __glyphY + _glyphData.yOffset;
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
        if ((_system.__budget - _system.__budgetUsed > 500) || (_system.__budgetUsed == 0))
        {
            vertex_freeze(__vertexBuffer);
            __tickMethod = __Finished;
            return true;
        }
        else
        {
            return false;
        }
    }
    
    static __Finished = function()
    {
        return true;
    }
}