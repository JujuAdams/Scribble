// Feather disable all

/// Draws plain text without formatting. The text is shrunk down to within the given maximum width
/// and height by reflowing the text at a smaller size. Text will appear immediately using
/// GameMaker's native text rendering. Over a few frames and in the background, Scribble will build
/// a vertex buffer in the background that replaces the native text rendering and is faster to draw.
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

function ScribbletDrawFit(_x, _y, _string, _colour = c_white, _alpha = 1, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1, _maxWidth = infinity, _maxHeight = infinity)
{
    static _system = __ScribbletSystem();
    static _cache  = _system.__cacheTest;
    
    if (_string == "") return;
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
        _struct = new __ScribbletClassFit(_string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight);
        _cache[$ _key] = _struct;
    }
    
    _struct.__drawMethod(_x, _y, _colour, _alpha);
    return _struct;
}

function __ScribbletClassFit(_string, _hAlign, _vAlign, _font, _fontScale, _maxWidth, _maxHeight) constructor
{
    static _system = __ScribbletSystem();
    
    __string    = _string;
    __hAlign    = _hAlign;
    __vAlign    = _vAlign;
    __font      = _font;
    __wrapWidth = undefined;
    
    __drawMethod = __Draw;
    
    __wrapped = true;
    __width   = undefined;
    __height  = undefined;
    
    
    
    
    
    if (is_infinity(_maxWidth))
    {
        //No limits!
        __wrapped = false;
        __scale = _fontScale;
        if (_fontScale != 1) __drawMethod = __DrawScale;
    }
    else if (is_infinity(_maxHeight))
    {
        //No height limit, just draw wrapped as usual
        if (_fontScale == 1)
        {
            __scale      = 1;
            __wrapWidth  = _maxWidth;
            __drawMethod = __DrawWrap;
        }
        else
        {
            __scale      = _fontScale;
            __wrapWidth  = _maxWidth/_fontScale;
            __drawMethod = __DrawReflow;
        }
    }
    else
    {
        draw_set_font(__font);
        
        var _height = _fontScale*string_height_ext(_string, -1, _maxWidth/_fontScale);
        if (_height <= _maxHeight)
        {
            //Height limit is enough, just draw wrapped as usual
            if (_fontScale == 1)
            {
                __scale      = 1;
                __wrapWidth  = _maxWidth;
                __drawMethod = __DrawWrap;
            }
            else
            {
                __scale      = _fontScale;
                __wrapWidth  = _maxWidth/_fontScale;
                __drawMethod = __DrawReflow;
            }
        }
        else
        {
            var _upperScale = _fontScale;
            var _lowerScale = 0;
            
            //Perform a binary search to find the best fit
            repeat(SCRIBBLET_FIT_ITERATIONS)
            {
                //Bias scale search very slighty to be larger
                //This usually finds the global maxima rather than narrowing down on a local maxima
                var _tryScale = lerp(_lowerScale, _upperScale, 0.51);
                
                var _adjustedWidth  = _maxWidth/_tryScale;
                var _adjustedHeight = _maxHeight/_tryScale;
                
                if (SCRIBBLET_FIT_SAFE)
                {
                    //Subtract 1 here to fix on off-by-one in GameMaker's text layout
                    var _width  = string_width_ext( _string, -1, _adjustedWidth-1);
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
            
            __width  = _width;
            __height = _height;
            
            __scale      = _lowerScale;
            __wrapWidth  = _maxWidth/_lowerScale;
            __drawMethod = __DrawReflow;
        }
    }
    
    __vertexBuffer  = undefined;
    __fontTexture   = font_get_texture(_font);
    __vertexBuilder = new __ScribbletClassBuilderFit(__string, _font, __hAlign, __vAlign, __wrapWidth);
    
    if (SCRIBBLET_VERBOSE) __ScribbletTrace("Created ", self);
    
    
    
    
    
    static GetWidth = function()
    {
        if (__width == undefined)
        {
            var _oldFont = draw_get_font();
            draw_set_font(__font);
            
            if (__wrapped)
            {
                //Subtract 1 here to fix on off-by-one in GameMaker's text layout
                __width = __scale*string_width_ext(__string, -1, __wrapWidth);
            }
            else
            {
                __width = __scale*string_width(__string);
            }
            
            draw_set_font(_oldFont);
        }
       
        return __width;
    }
    
    static GetHeight = function()
    {
        if (__height == undefined)
        {
            var _oldFont = draw_get_font();
            draw_set_font(__font);
            
            if (__wrapped)
            {
                //Subtract 1 here to fix on off-by-one in GameMaker's text layout
                __height = __scale*string_height_ext(__string, -1, __wrapWidth);
            }
            else
            {
                __height = __scale*string_height(__string);
            }
            
            draw_set_font(_oldFont);
        }
       
        return __height;
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
        
        if (SCRIBBLET_RESET_DRAW_STATE) ScribbletResetFontState();
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
        
        if (SCRIBBLET_RESET_DRAW_STATE) ScribbletResetFontState();
    }
    
    static __DrawWrap = function(_x, _y, _colour, _alpha)
    {
        draw_set_font(__font);
        draw_set_colour(_colour);
        draw_set_alpha(_alpha);
        draw_set_halign(__hAlign);
        draw_set_valign(__vAlign);
        
        draw_text_ext(_x, _y, __string, -1, __wrapWidth);
        __BuildVertexBuffer();
        
        if (SCRIBBLET_RESET_DRAW_STATE) ScribbletResetFontState();
    }
    
    static __DrawReflow = function(_x, _y, _colour, _alpha)
    {
        draw_set_font(__font);
        draw_set_colour(_colour);
        draw_set_alpha(_alpha);
        draw_set_halign(__hAlign);
        draw_set_valign(__vAlign);
        
        draw_text_ext_transformed(_x, _y, __string, -1, __wrapWidth, __scale, __scale, 0);
        __BuildVertexBuffer();
        
        if (SCRIBBLET_RESET_DRAW_STATE) ScribbletResetFontState();
    }
    
    
    
    
    
    static __BuildVertexBuffer = function()
    {
        if (_system.__budgetUsed >= _system.__budget) return;
        var _timer = get_timer();
        
        if (__vertexBuilder != undefined) && (__vertexBuilder.__tickMethod())
        {
            if (SCRIBBLET_VERBOSE) __ScribbletTrace("Compiled ", self);
            __vertexBuffer  = __vertexBuilder.__vertexBuffer;
            __drawMethod    = (__vertexBuilder.__fontSDFSpread == undefined)? __DrawVertexBuffer : __DrawVertexBufferSDF;
            __vertexBuilder = undefined;
        }
        
        _system.__budgetUsed += get_timer() - _timer;
    }
    
    static __DrawVertexBuffer = function(_x, _y, _colour, _alpha)
    {
        static _shdScribblet_u_vPositionAlphaScale = shader_get_uniform(__shdScribblet, "u_vPositionAlphaScale");
        static _shdScribblet_u_iColour = shader_get_uniform(__shdScribblet, "u_iColour");
        
        shader_set(__shdScribblet);
        shader_set_uniform_f(_shdScribblet_u_vPositionAlphaScale, _x, _y, _alpha, __scale);
        shader_set_uniform_i(_shdScribblet_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
    }
    
    static __DrawVertexBufferSDF = function(_x, _y, _colour, _alpha)
    {
        static _shdScribbletSDF_u_vPositionAlphaScale = shader_get_uniform(__shdScribbletSDF, "u_vPositionAlphaScale");
        static _shdScribbletSDF_u_iColour = shader_get_uniform(__shdScribbletSDF, "u_iColour");
        
        shader_set(__shdScribbletSDF);
        shader_set_uniform_f(_shdScribbletSDF_u_vPositionAlphaScale, _x, _y, _alpha, __scale);
        shader_set_uniform_i(_shdScribbletSDF_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
    }
}