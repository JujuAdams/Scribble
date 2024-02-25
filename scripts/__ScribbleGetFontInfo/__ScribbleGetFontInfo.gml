function __ScribbleGetFontInfo(_font)
{
    static _system = __ScribbleFastSystem();
    static _cache  = _system.__cacheFontInfo;
    
    var _name = font_get_name(_font);
    
    var _data = _cache[$ _name];
    if (_data == undefined)
    {
        _data = font_get_info(_font);
        _cache[$ _name] = _data;
    }
    
    return _data;
}