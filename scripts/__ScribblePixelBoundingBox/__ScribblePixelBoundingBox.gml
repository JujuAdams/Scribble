// Feather disable all

/// @param surface
/// @param [threshold=0]
/// @param [left]
/// @param [top]
/// @param [width]
/// @param [height]

function __ScribblePixelBoundingBox(_surfaceIn, _threshold = 0, _leftIn = 0, _topIn = 0, _widthIn = surface_get_width(_surfaceIn), _heightIn = surface_get_height(_surfaceIn))
{
    static _shdVisualBbox_u_fThreshold = shader_get_uniform(__shdScribbleVisualBbox, "u_fThreshold");
    
    static _surfaceA = -1;
    static _surfaceB = -1;
    static _surfaceC = -1;
    
    static _surfaceEnsure = function(_surface, _width, _height)
    {
        if (surface_exists(_surface) && ((surface_get_width(_surface) < _width) || (surface_get_height(_surface) < _height)))
        {
            surface_free(_surface);
        }
        
        if (not surface_exists(_surface))
        {
            _surface = surface_create(_width, _height, surface_rgba16float);
        }
        
        return _surface;
    }
    
    var _widthA  = ceil(_widthIn/2);
    var _heightA = ceil(_heightIn/2);
    _surfaceA = _surfaceEnsure(_surfaceA, _widthA, _heightA);
    _surfaceB = _surfaceEnsure(_surfaceB, ceil(_widthA/2), ceil(_heightA/2));
    _surfaceC = _surfaceEnsure(_surfaceC, 1, 1);
    
    surface_set_target(_surfaceB);
    draw_clear_alpha(#ffffff, 1);
    surface_reset_target();
    
    surface_set_target(_surfaceA);
    draw_clear_alpha(#ffffff, 1);
    
    gpu_push_state();
    gpu_set_tex_filter(false);
    gpu_set_tex_repeat(false);
    gpu_set_blendenable(true);
    gpu_set_blendmode_ext(bm_one, bm_one);
    gpu_set_blendequation(bm_eq_min);
    gpu_set_ztestenable(false);
    
    shader_set(__shdScribbleVisualBbox);
    shader_set_uniform_f(_shdVisualBbox_u_fThreshold, _threshold);
    
    var _widthRem  = _widthIn - _widthA;
    var _heightRem = _heightIn - _heightA;
    
    draw_surface_part(_surfaceIn, _leftIn,           _topIn,            _widthA,   _heightA,   0, 0);
    draw_surface_part(_surfaceIn, _leftIn + _widthA, _topIn,            _widthRem, _heightA,   0, 0);
    draw_surface_part(_surfaceIn, _leftIn,           _topIn + _heightA, _widthA,   _heightRem, 0, 0);
    draw_surface_part(_surfaceIn, _leftIn + _widthA, _topIn + _heightA, _widthRem, _heightRem, 0, 0);
    
    shader_reset();
    surface_reset_target();
    
    var _iterations = ceil(max(logn(2, _widthIn), logn(2, _heightIn)));
    if (_iterations < 2)
    {
        _surfaceFrom = _surfaceA;
    }
    else
    {
        var _widthFrom   = _widthA;
        var _heightFrom  = _heightA;
        var _surfaceFrom = _surfaceA;
        var _surfaceTo   = _surfaceB;
        
        repeat(_iterations-1)
        {
            surface_set_target(_surfaceTo);
            
            var _widthTo   = ceil(_widthFrom/2);
            var _heightTo  = ceil(_heightFrom/2);
            var _widthRem  = _widthFrom  - _widthTo;
            var _heightRem = _heightFrom - _heightTo;
            
            draw_surface_part(_surfaceFrom, 0,        0,         _widthTo,  _heightTo,  0, 0);
            draw_surface_part(_surfaceFrom, _widthTo, 0,         _widthRem, _heightTo,  0, 0);
            draw_surface_part(_surfaceFrom, 0,        _heightTo, _widthTo,  _heightRem, 0, 0);
            draw_surface_part(_surfaceFrom, _widthTo, _heightTo, _widthRem, _heightRem, 0, 0);
            
            surface_reset_target();
            
            var _temp = _surfaceFrom;
            _surfaceFrom = _surfaceTo;
            _surfaceTo   = _temp;
            
            _widthFrom  = _widthTo;
            _heightFrom = _heightTo;
        }
    }
    
    gpu_pop_state();
    
    surface_copy_part(_surfaceC, 0, 0, _surfaceFrom, 0, 0, 1, 1);
    
    static _buffer = buffer_create(8, buffer_fixed, 1);
    buffer_get_surface(_buffer, _surfaceC, 0);
    buffer_seek(_buffer, buffer_seek_start, 0);
    
    var _u0 = buffer_read(_buffer, buffer_f16);
    var _v0 = buffer_read(_buffer, buffer_f16);
    var _u1 = 1 - buffer_read(_buffer, buffer_f16);
    var _v1 = 1 - buffer_read(_buffer, buffer_f16);
    
    var _widthSurf  = surface_get_width(_surfaceIn);
    var _heightSurf = surface_get_height(_surfaceIn);
    
    static _result = {
        left:   0,
        top:    0,
        right:  0,
        bottom: 0,
    };
    
    if ((_u0 > _u1) || (_v0 > _v1))
    {
        with(_result)
        {
            valid  = false;
            left   = 0;
            top    = 0;
            right  = 0;
            bottom = 0;
        }
    }
    else
    {
        with(_result)
        {
            valid  = true;
            left   = floor(_widthSurf  * _u0) - _leftIn;
            top    = floor(_heightSurf * _v0) - _topIn;
            right  = floor(_widthSurf  * _u1) - _leftIn;
            bottom = floor(_heightSurf * _v1) - _topIn;
        }
    }
    
    return _result;
}