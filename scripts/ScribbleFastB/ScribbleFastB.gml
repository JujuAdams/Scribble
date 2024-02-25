// Feather disable all

/// @param x
/// @param y
/// @param string
/// @param [colour=white]
/// @param [alpha=1]
/// @param [hAlign=left]
/// @param [vAlign=top]
/// @param [font]
/// @param [preScale=1]
/// @param [width]
/// @param [height]
/// @param [scaleToBox=false]

function ScribbleFastB(_x, _y, _string, _colour = c_white, _alpha = 1, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _preScale = 1, _maxWidth = infinity, _maxHeight = infinity, _scaleToBox = false)
{
    static _system = __ScribbleFastSystem();
    static _cache  = _system.__cacheTest;
    
    if (_font == undefined) _font = _system.__defaultFont;
    
    if (is_infinity(_maxWidth) || ((not _scaleToBox) && is_infinity(_maxHeight)))
    {
        draw_set_font(_font);
        draw_set_colour(_colour);
        draw_set_alpha(_alpha);
        draw_set_halign(_hAlign);
        draw_set_valign(_vAlign);
        draw_text_transformed(_x, _y, _string, _preScale, _preScale, 0);
    }
    else
    {
        _maxWidth  = max(0, _maxWidth);
        _maxHeight = max(0, _maxHeight);
        
        var _key = _string + ":"
                 + string(_hAlign + 3*_vAlign + 9*_scaleToBox) //Pack these flags together
                 + string(_font)
                 + string(_preScale) + ":"
                 + string(_maxWidth) + ":"
                 + string(_maxHeight);
        
        var _struct = _cache[$ _key];
        if (_struct == undefined)
        {
            _struct = new __ScribbleClassFastB(_string, _hAlign, _vAlign, _font, _preScale, _maxWidth, _maxHeight, _scaleToBox);
            _cache[$ _key] = _struct;
        }
        
        if (_struct.__usingNative)
        {
            draw_set_font(_font);
            draw_set_colour(_colour);
            draw_set_alpha(_alpha);
            draw_set_halign(_hAlign);
            draw_set_valign(_vAlign);
        }
        
        _struct.__drawMethod(_x, _y, _colour, _alpha);
    }
}

function __ScribbleClassFastB(_string, _hAlign, _vAlign, _font, _preScale, _maxWidth, _maxHeight, _scaleToBox) constructor
{
    static _fitSafeMode   = true;
    static _fitIterations = 6;
    
    __string    = _string;
    __hAlign    = _hAlign;
    __vAlign    = _vAlign;
    __scale     = 1;
    __wrapWidth = undefined;
    
    __usingNative   = true;
    __fontSDFSpread = undefined;
    __drawMethod    = __Draw;
    
    if (is_infinity(_maxWidth))
    {
        //No limits!
        
        if (_preScale != 1)
        {
            __scale = _preScale;
            __drawMethod = __DrawScale;
        }
    }
    else if (_scaleToBox)
    {
        //Scale down as appropriate
        var _width = string_width(_string);
        if (is_infinity(_maxHeight))
        {
            __scale = min(_preScale, _maxWidth / _width);
        }
        else
        {
            var _height = string_height(_string);
            __scale = min(_preScale, _maxWidth / _width, _maxHeight / _height);
        }
        
        __drawMethod = __DrawScale;
    }
    else if (is_infinity(_maxHeight))
    {
        //No height limit, just draw wrapped as usual
        
        if (_preScale == 1)
        {
            __wrapWidth  = _maxWidth;
            __drawMethod = __DrawWrap;
        }
        else
        {
            __scale      = _preScale;
            __wrapWidth  = _maxWidth/_preScale;
            __drawMethod = __DrawFit;
        }
    }
    else
    {
        var _height = _preScale*string_height_ext(_string, -1, _maxWidth/_preScale);
        if (_height <= _maxHeight)
        {
            //Height limit is enough, just draw wrapped as usual
        
            if (_preScale == 1)
            {
                __wrapWidth  = _maxWidth;
                __drawMethod = __DrawWrap;
            }
            else
            {
                __scale      = _preScale;
                __wrapWidth  = _maxWidth/_preScale;
                __drawMethod = __DrawFit;
            }
        }
        else
        {
            var _upperScale = _preScale;
            var _lowerScale = 0;
            
            //Perform a binary search to find the best fit
            repeat(_fitIterations)
            {
                //Bias scale search very slighty to be larger
                //This usually finds the global maxima rather than narrowing down on a local maxima
                var _tryScale = 0.51*(_lowerScale + _upperScale);
                
                var _adjustedWidth  = _maxWidth/_tryScale;
                var _adjustedHeight = _maxHeight/_tryScale;
                
                if (_fitSafeMode)
                {
                    var _width  = string_width_ext( _string, -1, _adjustedWidth);
                    var _height = string_height_ext(_string, -1, _adjustedWidth-1);
                    if ((_width > _adjustedWidth) || (_height > _adjustedHeight))
                    {
                        _upperScale = _tryScale;
                    }
                    else
                    {
                        _lowerScale = _tryScale;
                    }
                }
                else
                {
                    //Subtract 1 here to fix on off-by-one in GameMaker's text layout
                    var _height = string_height_ext(_string, -1, _adjustedWidth-1);
                    if (_height > _adjustedHeight)
                    {
                        _upperScale = _tryScale;
                    }
                    else
                    {
                        _lowerScale = _tryScale;
                    }
                }
            }
            
            __scale      = _lowerScale;
            __wrapWidth  = _maxWidth/_lowerScale;
            __drawMethod = __DrawFit;
        }
    }
    
    __vertexBuffer  = undefined;
    __vertexBuilder = new __ScribbleClassFastBBuilder(__string, __hAlign, __vAlign, _font, __scale, __wrapWidth);
    __fontTexture   = font_get_texture(_font);
    
    
    
    
    
    static __Draw = function(_x, _y)
    {
        draw_text(_x, _y, __string);
        __BuildVertexBuffer();
    }
    
    static __DrawScale = function(_x, _y)
    {
        draw_text_transformed(_x, _y, __string, __scale, __scale, 0);
        __BuildVertexBuffer();
    }
    
    static __DrawWrap = function(_x, _y)
    {
        draw_text_ext(_x, _y, __string, -1, __wrapWidth);
        __BuildVertexBuffer();
    }
    
    static __DrawFit = function(_x, _y)
    {
        draw_text_ext_transformed(_x, _y, __string, -1, __wrapWidth, __scale, __scale, 0);
        __BuildVertexBuffer();
    }
    
    static __BuildVertexBuffer = function()
    {
        if (__vertexBuilder.__tickMethod())
        {
            __vertexBuffer  = __vertexBuilder.__vertexBuffer;
            __fontSDFSpread = __vertexBuilder.__fontSDFSpread;
            __usingNative   = false;
            __drawMethod    = __DrawVertexBuffer;
            __vertexBuilder = undefined;
        }
    }
    
    static __DrawVertexBuffer = function(_x, _y, _colour, _alpha)
    {
        static _shdScribbleFast_u_vPositionAlphaScale = shader_get_uniform(__shdScribbleFastAB, "u_vPositionAlphaScale");
        static _shdScribbleFast_u_iColour = shader_get_uniform(__shdScribbleFastAB, "u_iColour");
        
        static _shdScribbleFastSDF_u_vPositionAlphaScale = shader_get_uniform(__shdScribbleFastAB_SDF, "u_vPositionAlphaScale");
        static _shdScribbleFastSDF_u_iColour = shader_get_uniform(__shdScribbleFastAB_SDF, "u_iColour");
        
        if (__fontSDFSpread == undefined) //TODO - Optimise
        {
            shader_set(__shdScribbleFastAB);
            shader_set_uniform_f(_shdScribbleFast_u_vPositionAlphaScale, _x, _y, _alpha, __scale);
            shader_set_uniform_i(_shdScribbleFast_u_iColour, _colour);
            vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
            shader_reset();
        }
        else
        {
            shader_set(__shdScribbleFastAB_SDF);
            shader_set_uniform_f(_shdScribbleFastSDF_u_vPositionAlphaScale, _x, _y, _alpha, __scale);
            shader_set_uniform_i(_shdScribbleFastSDF_u_iColour, _colour);
            vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
            shader_reset();
        }
    }
}

function __ScribbleClassFastBBuilder(_string, _hAlign, _vAlign, _font, _scale, _wrapWidth) constructor
{
    static __vertexFormat = undefined;
    if (__vertexFormat == undefined)
    {
        vertex_format_begin();
        vertex_format_add_custom(vertex_type_float2, vertex_usage_position);
        vertex_format_add_texcoord();
        __vertexFormat = vertex_format_end();
    }
    
    __string    = _string;
    __hAlign    = _hAlign;
    __vAlign    = _vAlign;
    __font      = _font;
    __scale     = _scale;
    __wrapWidth = _wrapWidth;
    
    __spaceWidth     = undefined;
    __spaceHeight    = undefined;
    __stringArray    = undefined;
    __nextLineBreak  = infinity;
    __lineBreakIndex = 0;
    __lineBreakArray = undefined;
    __tickMethod     = __Decompose;
    
    var _fontInfo = __ScribbleGetFontInfo(_font);
    __fontGlyphStruct = _fontInfo.glyphs;
    __fontSDFSpread   = _fontInfo.sdfEnabled? _fontInfo.sdfSpread : undefined;
    
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
        
        var _wordArray   = string_split(__string, " ");
        var _spaceWidth  = string_width(" ");
        var _spaceHeight = string_height(" ");
        
        __spaceWidth     = _spaceWidth;
        __spaceHeight    = _spaceHeight;
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
                _x = 0;
                _y += _spaceHeight;
                
                array_push(__lineBreakArray, _index);
            }
            
            _index += string_length(_word) + 1;
            _x += _width + _spaceWidth;
            ++_i;
        }
        
        array_push(__lineBreakArray, infinity);
        __nextLineBreak = __lineBreakArray[0];
        
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
                __glyphX  = 0;
                __glyphY += __spaceHeight;
                
                __lineBreakIndex++;
                __nextLineBreak = __lineBreakArray[__lineBreakIndex];
            }
            
            if (__glyph >= __glyphCount-1)
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