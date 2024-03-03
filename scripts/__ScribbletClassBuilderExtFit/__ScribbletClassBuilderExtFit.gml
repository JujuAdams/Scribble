/// @param fragArray
/// @param font
function __ScribbletClassBuilderExtFit(_fragArray, _font) constructor
{
    static _system       = __ScribbletSystem();
    static _vertexFormat = _system.__vertexFormatColor;
    
    __fragmentArray = _fragArray;
    
    __tickMethod = __DecomposeFragment;
    
    var _fontInfo = __ScribbletGetFontInfo(_font);
    __fontGlyphStruct = _fontInfo.glyphs;
    
    __spaceWidth  = __ScribbletGetSpaceWidth(_font);
    __spaceHeight = __ScribbletGetSpaceHeight(_font);
    
    var _fontTexture = _fontInfo.__forcedTexturePointer;
    __texTexelW = texture_get_texel_width(_fontTexture);
    __texTexelH = texture_get_texel_height(_fontTexture);
        
    __vertexBuffer = vertex_create_buffer();
    vertex_begin(__vertexBuffer, _vertexFormat);
    vertex_float2(__vertexBuffer, 0, 0); vertex_colour(__vertexBuffer, c_black, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_float2(__vertexBuffer, 0, 0); vertex_colour(__vertexBuffer, c_black, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_float2(__vertexBuffer, 0, 0); vertex_colour(__vertexBuffer, c_black, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    
    __fragment    = 0;
    __stringArray = undefined;
    __glyphX      = 0;
    __glyphY      = 0;
    
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
    
    
    
    
    
    static __DecomposeFragment = function()
    {
        var _fragmentData   = __fragmentArray[__fragment];
        var _fragmentString = _fragmentData.__string;
        
        __glyph       = 0;
        __glyphCount  = string_length(_fragmentString);
        __glyphX      = _fragmentData.__x;
        __glyphY      = _fragmentData.__y;
        __glyphColour = _fragmentData.__colour;
        
        __stringArray = __ScribbletStringDecompose(_fragmentString, __glyphCount);
        __tickMethod = __Tick;
        return false;
    }
    
    static __Tick = function()
    {
        var _glyphColour = __glyphColour;
        var _glyphAlpha  = (__glyphColour >= 0);
        
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
                if (__fragment < array_length(__fragmentArray))
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