/// @param fragArray
/// @param font

function __ScribbleClassFastBuilderB(_fragArray, _font) constructor
{
    static _system       = __ScribbleFastSystem();
    static _vertexFormat = _system.__vertexFormatB;
    
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
    vertex_begin(__vertexBuffer, _vertexFormat);
    vertex_float2(__vertexBuffer, 0, 0); vertex_colour(__vertexBuffer, c_black, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_float2(__vertexBuffer, 0, 0); vertex_colour(__vertexBuffer, c_black, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_float2(__vertexBuffer, 0, 0); vertex_colour(__vertexBuffer, c_black, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    
    __fragment    = 0;
    __stringArray = undefined;
    __glyphX      = 0;
    
    static __DecomposeFragment = function()
    {
        var _fragmentData   = __fragArray[__fragment];
        var _fragmentString = _fragmentData.__string;
        __glyph       = 0;
        __glyphCount  = string_length(_fragmentString);
        __glyphX      = _fragmentData.__x;
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
                    var _glyphT = -_fontSDFSpread;
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
        if ((_system.__budget - _system.__budgetUsed > 500) || (_system.__budgetUsed == 0))
        {
            vertex_freeze(__vertexBuffer);
            return true;
        }
        else
        {
            return false;
        }
    }
}