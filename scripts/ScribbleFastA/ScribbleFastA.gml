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

function ScribbleFastA(_x, _y, _string, _colour = c_white, _alpha = 1, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1)
{
    static _system = __ScribbleFastSystem();
    static _cache  = _system.__cacheTest;
    
    if (_font == undefined) _font = _system.__defaultFont;
    
    var _key = string_concat(_string, ":",
                             _hAlign + 3*_vAlign, //Pack these flags together
                             _font, ":",
                             _fontScale);
    
    var _struct = _cache[$ _key];
    if (_struct == undefined)
    {
        _struct = new __ScribbleClassFastA(_string, _hAlign, _vAlign, _font, _fontScale);
        _cache[$ _key] = _struct;
    }
    
    _struct.__drawMethod(_x, _y, _colour, _alpha);
}

function __ScribbleClassFastA(_string, _hAlign, _vAlign, _font, _fontScale) constructor
{
    static _fitSafeMode   = true;
    static _fitIterations = 6;
    
    __string = _string;
    __hAlign = _hAlign;
    __vAlign = _vAlign;
    __font   = _font;
    __scale  = _fontScale;
    
    __drawMethod = (_fontScale == 1)? __Draw : __DrawScale;
    
    __vertexBuffer  = undefined;
    __fontTexture   = font_get_texture(_font);
    __vertexBuilder = new __ScribbleClassFastABuilder(__string, __hAlign, __vAlign, _font);
    
    //Cache string width/height to handle alignment positioning
    switch(_hAlign)
    {
        case fa_left:
            __xOffset = 0;
        break;
        
        case fa_center:
            draw_set_font(_font);
            __xOffset = -__scale*string_width(_string)/2;
        break;
        
        case fa_right:
            draw_set_font(_font);
            __xOffset = -__scale*string_width(_string);
        break;
    }
    
    switch(_vAlign)
    {
        case fa_top:
            __yOffset = 0;
        break;
        
        case fa_middle:
            draw_set_font(_font);
            __yOffset = -__scale*string_height(_string)/2;
        break;
        
        case fa_bottom:
            draw_set_font(_font);
            __yOffset = -__scale*string_height(_string);
        break;
    }
    
    
    
    
    
    static __Draw = function(_x, _y, _colour, _alpha)
    {
        draw_set_font(__font);
        draw_set_colour(_colour);
        draw_set_alpha(_alpha);
        draw_set_halign(__hAlign);
        draw_set_valign(__vAlign);
        
        draw_text(_x, _y, __string);
        __BuildVertexBuffer();
    }
    
    static __DrawScale = function(_x, _y, _colour, _alpha)
    {
        draw_set_font(__font);
        draw_set_colour(_colour);
        draw_set_alpha(_alpha);
        draw_set_halign(__hAlign);
        draw_set_valign(__vAlign);
        
        draw_text_transformed(_x, _y, __string, __scale, __scale, 0);
        __BuildVertexBuffer();
    }
    
    static __BuildVertexBuffer = function()
    {
        if (__vertexBuilder != undefined) && (__vertexBuilder.__tickMethod())
        {
            __vertexBuffer  = __vertexBuilder.__vertexBuffer;
            __drawMethod    = (__vertexBuilder.__fontSDFSpread == undefined)? __DrawVertexBuffer : __DrawVertexBufferSDF;
            __vertexBuilder = undefined;
        }
    }
    
    static __DrawVertexBuffer = function(_x, _y, _colour, _alpha)
    {
        static _shdScribbleFast_u_vPositionAlphaScale = shader_get_uniform(__shdScribbleFastAB, "u_vPositionAlphaScale");
        static _shdScribbleFast_u_iColour = shader_get_uniform(__shdScribbleFastAB, "u_iColour");
        
        shader_set(__shdScribbleFastAB);
        shader_set_uniform_f(_shdScribbleFast_u_vPositionAlphaScale, _x + __xOffset, _y + __yOffset, _alpha, __scale);
        shader_set_uniform_i(_shdScribbleFast_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
    }
    
    static __DrawVertexBufferSDF = function(_x, _y, _colour, _alpha)
    {
        static _shdScribbleFastSDF_u_vPositionAlphaScale = shader_get_uniform(__shdScribbleFastAB_SDF, "u_vPositionAlphaScale");
        static _shdScribbleFastSDF_u_iColour = shader_get_uniform(__shdScribbleFastAB_SDF, "u_iColour");
        
        shader_set(__shdScribbleFastAB_SDF);
        shader_set_uniform_f(_shdScribbleFastSDF_u_vPositionAlphaScale, _x + __xOffset, _y + __yOffset, _alpha, __scale);
        shader_set_uniform_i(_shdScribbleFastSDF_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
    }
}

function __ScribbleClassFastABuilder(_string, _hAlign, _vAlign, _font) constructor
{
    static __vertexFormat = undefined;
    if (__vertexFormat == undefined)
    {
        vertex_format_begin();
        vertex_format_add_custom(vertex_type_float2, vertex_usage_position);
        vertex_format_add_texcoord();
        __vertexFormat = vertex_format_end();
    }
    
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