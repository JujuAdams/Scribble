function scribble_super_clear(_target)
{
    var _font_data = global.__scribble_font_data[? _target];
    if (_font_data == undefined) __scribble_error("Font \"", _target, "\" not found");
    
    _font_data.__clear();
}