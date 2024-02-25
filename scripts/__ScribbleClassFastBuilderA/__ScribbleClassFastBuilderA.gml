/// @param string
/// @param hAlign
/// @param vAlign
/// @param font

function __ScribbleClassFastBuilderA(_string, _hAlign, _vAlign, _font) constructor
{
    static __vertexFormat = __ScribbleFastSystem().__vertexFormatA;
    
    __string = _string;
    __hAlign = _hAlign;
    __vAlign = _vAlign;
    __font   = _font;
    
    __tickMethod = __Decompose;
    
    var _fontInfo = __ScribbleGetFontInfo(_font);
    __fontGlyphStruct = _fontInfo.glyphs;
    __fontSDFSpread   = _fontInfo.sdfEnabled? _fontInfo.sdfSpread : undefined;
    
    draw_set_font(_font);
    //I'd love to pull this out of the glyph data but the values we get are inaccurate
    var _spaceWidth = string_width(" ");
    __spaceWidth = _spaceWidth;
    
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
        
        __tickMethod = __Tick;
        return false;
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
                    var _glyphT = -_fontSDFSpread;
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