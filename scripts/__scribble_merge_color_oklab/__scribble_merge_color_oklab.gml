// Feather disable all

function __scribble_merge_color_oklab(_color0, _color1, _amount)
{
    static _struct0 = {};
    static _struct1 = {};
    static _struct2 = {};
    
    __scribble_srgb_to_oklab(_color0, _struct0);
    __scribble_srgb_to_oklab(_color1, _struct1);
    __scribble_merge_oklab(_struct0, _struct1, _amount, _struct2);
    return __scribble_oklab_to_srgb(_struct2);
}

function __scribble_merge_oklab(_structA, _structB, _amount, _structOut = undefined)
{
    static _result = {
        l: 0,
        a: 0,
        b: 0,
    };
    
    if (_structOut == undefined)
    {
        _structOut = _result;
    }
    
    with(_structOut)
    {
        l = lerp(_structA.l, _structB.l, _amount);
        a = lerp(_structA.a, _structB.a, _amount);
        b = lerp(_structA.b, _structB.b, _amount);
    }
    
    return _structOut;
}

function __scribble_srgb_to_oklab(_color, _struct = undefined)
{
    static _result = {
        l: 0,
        a: 0,
        b: 0,
    };
    
    if (_struct == undefined)
    {
        _struct = _result;
    }
    
    var _linear = __scribble_srgb_to_linear(_color);
    with(_linear)
    {
        var _l = 0.4121656120*r + 0.5362752080*g + 0.0514575653*b;
        var _m = 0.2118591070*r + 0.6807189584*g + 0.1074065790*b;
        var _s = 0.0883097947*r + 0.2818474174*g + 0.6302613616*b;
    }
    
    _l = power(_l, 1/3);
    _m = power(_m, 1/3);
    _s = power(_s, 1/3);
    
    with(_struct)
    {
        l = 0.2104542553*_l + 0.7936177850*_m - 0.0040720468*_s;
        a = 1.9779984951*_l - 2.4285922050*_m + 0.4505937099*_s;
        b = 0.0259040371*_l + 0.7827717662*_m - 0.8086757660*_s;
    }
    
    return _struct;
}

function __scribble_oklab_to_srgb(_struct)
{
    with(_struct)
    {
        var _l = l + 0.3963377774*a + 0.2158037573*b;
        var _m = l - 0.1055613458*a - 0.0638541728*b;
        var _s = l - 0.0894841775*a - 1.2914855480*b;
    }
    
    _l = _l*_l*_l;
    _m = _m*_m*_m;
    _s = _s*_s*_s;
    
    with(_struct)
    {
        r =  4.0767416621*_l - 3.3077115913*_m + 0.2309699292*_s;
        g = -1.2684380046*_l + 2.6097574011*_m - 0.3413193965*_s;
        b = -0.0041960863*_l - 0.7034186147*_m + 1.7076147010*_s;
    }
    
    return __scribble_linear_to_srgb(_struct);
}

function __scribble_srgb_to_linear(_color, _struct = undefined)
{
    static _result = {
        r: 0,
        g: 0,
        b: 0,
    };
    
    if (_struct == undefined)
    {
        _struct = _result;
    }
    
    var _r = color_get_red(  _color) / 255;
    var _g = color_get_green(_color) / 255;
    var _b = color_get_blue( _color) / 255;
    
    with(_struct)
    {
        if (_r < 0.04045)
        {
            r = _r / 12.92;
        }
        else
        {
            r = power((_r + 0.055) / 1.055, 2.4);
        }
        
        if (_g < 0.04045)
        {
            g = _g / 12.92;
        }
        else
        {
            g = power((_g + 0.055) / 1.055, 2.4);
        }
        
        if (_b < 0.04045)
        {
            b = _b / 12.92;
        }
        else
        {
            b = power((_b + 0.055) / 1.055, 2.4);
        }
    }
    
    return _struct;
}

function __scribble_linear_to_srgb(_struct)
{
    with(_struct)
    {
        if (r < 0.0031308)
        {
            var _r = r * 12.92;
        }
        else
        {
            var _r = (1.055*power(r, 1/2.4)) - 0.055;
        }
        
        if (g < 0.0031308)
        {
            var _g = g * 12.92;
        }
        else
        {
            var _g = (1.055*power(g, 1/2.4)) - 0.055;
        }
        
        if (b < 0.0031308)
        {
            var _b = b * 12.92;
        }
        else
        {
            var _b = (1.055*power(b, 1/2.4)) - 0.055;
        }
    }
    
    return make_color_rgb(255*clamp(_r, 0, 1), 255*clamp(_g, 0, 1), 255*clamp(_b, 0, 1));
}