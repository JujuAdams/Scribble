// Feather disable all

/// Draws plain text without formatting or layout. Text will appear immediately using GameMaker's
/// native text rendering. Over a few frames and in the background, Scribble will build a vertex
/// buffer in the background that replaces the native text rendering and is faster to draw.
/// 
/// This function relies on internal caching for performance gains. If you change any of the
/// following arguments, Scribble will have to do extra work to recache the new text data. Try to
/// limit how often you change these variables to get the best performance.
///     - string
///     - hAlign
///     - vAlign
///     - font
///     - fontScale
/// 
/// N.B. This function should not be used for extremely fast changing text such as a stopwatch.
///      You should use ScribbletDrawNative() instead if you plan for the drawn text to only show for
///      a few frames at a time.
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

function ScribbletDraw(_x, _y, _string, _colour = c_white, _alpha = 1, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1)
{
    static _system = __ScribbletSystem();
    static _cache  = _system.__elementsCache;
    static _array  = _system.__elementsArray;
    
    if (_string == "") return;
    if (_font == undefined) _font = _system.__defaultFont;
    
    var _key = string_concat(_string, ":",
                             _hAlign + 3*_vAlign, ":", //Pack these flags together
                             _font, ":",
                             _fontScale, ":A");
    
    var _struct = _cache[$ _key];
    if (_struct == undefined)
    {
        _struct = new __ScribbletClass(_key, _string, _hAlign, _vAlign, _font, _fontScale);
        _cache[$ _key] = _struct;
        array_push(_array, _struct);
    }
    
    _struct.__drawMethod(_x, _y, _colour, _alpha);
    _struct.__lastDraw = current_time;
    return _struct;
}

function __ScribbletClass(_key, _string, _hAlign, _vAlign, _font, _fontScale) constructor
{
    static _system = __ScribbletSystem();
    
    __key    = _key;
    __string = _string;
    __hAlign = _hAlign;
    __vAlign = _vAlign;
    __font   = _font;
    __scale  = _fontScale;
    
    __drawMethod = (_fontScale == 1)? __Draw : __DrawScale;
    
    __vertexBuffer  = undefined;
    __fontTexture   = font_get_texture(_font);
    __vertexBuilder = new __ScribbletClassBuilder(__string, _font);
    
    __width  = undefined;
    __height = undefined;
    
    
    if (SCRIBBLET_RESET_DRAW_STATE) var _oldFont = draw_get_font();
    draw_set_font(__font);
    
    //Cache string width/height to handle alignment positioning
    switch(_hAlign)
    {
        case fa_left:
            __xOffset = 0;
        break;
        
        case fa_center:
            __width = __scale*string_width(_string);
            __xOffset = -__width/2;
        break;
        
        case fa_right:
            __width = __scale*string_width(_string);
            __xOffset = -__width;
        break;
    }
    
    switch(_vAlign)
    {
        case fa_top:
            __yOffset = 0;
        break;
        
        case fa_middle:
            __height = __scale*string_height(_string);
            __yOffset = -__height/2;
        break;
        
        case fa_bottom:
            __height = __scale*string_height(_string);
            __yOffset = -__height;
        break;
    }
    
    if (SCRIBBLET_RESET_DRAW_STATE) draw_set_font(_oldFont);
    if (SCRIBBLET_VERBOSE) __ScribbletTrace("Created ", self);
    
    
    
    
    
    static GetWidth = function()
    {
        if (__width == undefined)
        {
            var _oldFont = draw_get_font();
            draw_set_font(__font);
            __width = __scale*string_width(__string);
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
            __height = __scale*string_height(__string);
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
        
        if (SCRIBBLET_RESET_DRAW_STATE) __SCRIBBLET_RESET_FORMATTING
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
        
        if (SCRIBBLET_RESET_DRAW_STATE) __SCRIBBLET_RESET_FORMATTING
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
        shader_set_uniform_f(_shdScribblet_u_vPositionAlphaScale, _x + __xOffset, _y + __yOffset, _alpha, __scale);
        shader_set_uniform_i(_shdScribblet_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
    }
    
    static __DrawVertexBufferSDF = function(_x, _y, _colour, _alpha)
    {
        static _shdScribbletSDF_u_vPositionAlphaScale = shader_get_uniform(__shdScribbletSDF, "u_vPositionAlphaScale");
        static _shdScribbletSDF_u_iColour = shader_get_uniform(__shdScribbletSDF, "u_iColour");
        
        shader_set(__shdScribbletSDF);
        shader_set_uniform_f(_shdScribbletSDF_u_vPositionAlphaScale, _x + __xOffset, _y + __yOffset, _alpha, __scale);
        shader_set_uniform_i(_shdScribbletSDF_u_iColour, _colour);
        vertex_submit(__vertexBuffer, pr_trianglelist, __fontTexture);
        shader_reset();
    }
    
    
    
    
    
    static __Destroy = function()
    {
        if (__vertexBuilder != undefined)
        {
            __vertexBuilder.__Destroy();
            __vertexBuilder = undefined;
        }
        
        if (__vertexBuffer != undefined)
        {
            vertex_delete_buffer(__vertexBuffer);
            __vertexBuffer = undefined;
        }
    }
}