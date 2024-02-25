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

function ScribbleFastD(_x, _y, _string, _colour = c_white, _alpha = 1, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1)
{
    static _system = __ScribbleFastSystem();
    static _cache  = _system.__cacheTest;
    
    if (_font == undefined) _font = _system.__defaultFont;
    
    var _key = _string + ":"
                + string(_hAlign + 3*_vAlign) //Pack these flags together
                + string(_font)
                + string(_fontScale);
    
    var _struct = _cache[$ _key];
    if (_struct == undefined)
    {
        _struct = new __ScribbleClassFastC(_string, _hAlign, _vAlign, _font, _fontScale);
        _cache[$ _key] = _struct;
    }
    
    if (_struct.__usingNative)
    {
        draw_set_font(_font);
        draw_set_alpha(_alpha);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
    
    _struct.__drawMethod(_x, _y, _colour, _alpha);
}

function __ScribbleClassFastD(_string, _hAlign, _vAlign, _font, _fontScale) constructor
{
    static _colourDict = __ScribbleFastSystem().__colourDict;
    
    static _fitSafeMode   = true;
    static _fitIterations = 6;
    
    __string    = _string;
    __hAlign    = _hAlign;
    __vAlign    = _vAlign;
    __scale     = _fontScale;
    __wrapWidth = undefined;
    
    __usingNative   = true;
    __fontSDFSpread = undefined;
    __drawMethod    = __DrawNative;
    
    var _substringArray = string_split(__string, "[");
    if (array_length(_substringArray) <= 1)
    {
        //No square brackets, fall back on simple rendering
        __drawMethod = __DrawSimple;
    }
    else
    {
        __fragArray   = [];
        __spriteArray = [];
        __xOffset = 0;
        __yOffset = 0;
        
        __vertexBuffer  = undefined;
        __vertexBuilder = new __ScribbleClassFastCBuilder(__fragArray, _font, __scale);
        __fontTexture   = font_get_texture(_font);
        
        var _lineHeight = string_height(" ");
        
        //Handle the first text fragment
        var _textString = _substringArray[0];
        if (_textString != "")
        {
            array_push(__fragArray, {
                __colour: -1,
                __string: _textString,
                __x: 0,
            });
            
            var _x = __scale*string_width(_textString);
        }
        else
        {
            var _x = 0;
        }
        
        var _colour = -1;
        
        //Then iterate other command tag + text fragment combos, splitting as necessary
        var _i = 1;
        repeat(array_length(_substringArray)-1)
        {
            var _tagSplitArray = string_split(_substringArray[_i], "]", false, 1);
            if (array_length(_tagSplitArray) == 2)
            {
                //Handle the contents of the tag
                var _tagString = _tagSplitArray[0];
                
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
                        
                        array_push(__spriteArray, {
                            __sprite: _sprite,
                            __image: _spriteImage,
                            __x: _spriteX + _x + sprite_get_xoffset(_sprite),
                            __y: _spriteY + 0.5*(__scale*_lineHeight - sprite_get_height(_sprite)) + sprite_get_yoffset(_sprite),
                        });
                        
                        _x += sprite_get_width(_sprite);
                    }
                    else
                    {
                        Trace("Command tag \"", _tagString, "\" not recognised");
                    }
                }
                
                //Then we handle the next text fragment
                var _textString = _tagSplitArray[1];
                if (_textString != "")
                {
                    array_push(__fragArray, {
                        __colour: _colour,
                        __string: _tagSplitArray[1],
                        __x: _x,
                    });
                    
                    _x += __scale*string_width(_textString);
                }
            }
            
            ++_i;
        }
        
        if (__hAlign == fa_center) __xOffset = -_x/2;
        if (__hAlign == fa_right ) __xOffset = -_x;
        if (__vAlign == fa_middle) __yOffset = -_lineHeight/2;
        if (__vAlign == fa_bottom) __yOffset = -_lineHeight;
    }
    
    
    
    
    
    static __DrawSimple = function(_x, _y)
    {
        draw_set_halign(__hAlign);
        draw_set_valign(__vAlign);
        draw_text(_x, _y, __string);
        //__BuildVertexBuffer();
    }
    
    static __DrawNative = function(_x, _y, _colour)
    {
        var _scale = __scale;
        
        _x += __xOffset;
        _y += __yOffset;
        
        var _i = 0;
        repeat(array_length(__fragArray))
        {
            with(__fragArray[_i])
            {
                draw_set_colour((__colour >= 0)? __colour : _colour);
                draw_text_transformed(_x + __x, _y, __string, _scale, _scale, 0);
            }
            
            ++_i;
        }
        
        __DrawSprites();
        
        //__BuildVertexBuffer();
    }
    
    static __DrawSprites = function()
    {
        var _i = 0;
        repeat(array_length(__spriteArray))
        {
            with(__spriteArray[_i])
            {
                draw_sprite(__sprite, __image, _x + __x, _y + __y);
            }
            
            ++_i;
        }
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
        
        if (__fontSDFSpread == undefined)
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
        
        //Lean into GameMaker's native renderer for sprites
        __DrawSprites();
    }
}

function __ScribbleClassFastDBuilder(_fragArray, _font, _scale) constructor
{
    static __vertexFormat = undefined;
    if (__vertexFormat == undefined)
    {
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_texcoord();
        __vertexFormat = vertex_format_end();
    }
    
    __fragArray = _fragArray;
    __font      = _font;
    __scale     = _scale;
    
    __spaceWidth  = undefined;
    __spaceHeight = undefined;
    __tickMethod  = __Decompose;
    
    var _fontInfo = __ScribbleGetFontInfo(_font);
    __fontGlyphStruct = _fontInfo.glyphs;
    __fontSDFSpread   = _fontInfo.sdfEnabled? _fontInfo.sdfSpread : 0;
    
    var _fontTexture = font_get_texture(_font);
    __texTexelW = texture_get_texel_width(_fontTexture);
    __texTexelH = texture_get_texel_height(_fontTexture);
        
    __vertexBuffer = vertex_create_buffer();
    vertex_begin(__vertexBuffer, __vertexFormat);
    vertex_position_3d(__vertexBuffer, 0, 0, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_position_3d(__vertexBuffer, 0, 0, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    vertex_position_3d(__vertexBuffer, 0, 0, 0); vertex_texcoord(__vertexBuffer, 0, 0);
    
    __fragment      = 0;
    __fragmentCount = array_length(__fragArray);
    __stringArray   = undefined;
    __glyphX        = 0;
    __glyphY        = 0;
    
    static __DecomposeFragment = function()
    {
        var _fragmentString = __fragArray[__fragment];
        __glyph      = 0;
        __glyphCount = string_length(_fragmentString);
        
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
                    
                    var _glyphL = __glyphX + _glyphData.offset - __fontSDFSpread;
                    var _glyphT = __glyphY - __fontSDFSpread;
                    var _glyphR = _glyphL + _glyphData.w;
                    var _glyphB = _glyphT + _glyphData.h;
                    
                    vertex_position_3d(__vertexBuffer, _glyphL, _glyphT, 0); vertex_texcoord(__vertexBuffer, _texL, _texT);
                    vertex_position_3d(__vertexBuffer, _glyphR, _glyphT, 0); vertex_texcoord(__vertexBuffer, _texR, _texT);
                    vertex_position_3d(__vertexBuffer, _glyphL, _glyphB, 0); vertex_texcoord(__vertexBuffer, _texL, _texB);
                    vertex_position_3d(__vertexBuffer, _glyphR, _glyphT, 0); vertex_texcoord(__vertexBuffer, _texR, _texT);
                    vertex_position_3d(__vertexBuffer, _glyphR, _glyphB, 0); vertex_texcoord(__vertexBuffer, _texR, _texB);
                    vertex_position_3d(__vertexBuffer, _glyphL, _glyphB, 0); vertex_texcoord(__vertexBuffer, _texL, _texB);
                    
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
                __fragment++;
                if (__fragment < __fragmentCount)
                {
                    __tickMethod = __DecomposeFragment;
                }
                else
                {
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