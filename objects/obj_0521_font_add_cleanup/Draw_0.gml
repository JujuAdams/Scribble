// Feather disable all

var _string = "";

if (keyboard_check(ord("1")))
{
    _string = "ab";
}
else if (keyboard_check(ord("2")))
{
    _string = "cd";
}


scribble(_string).font(dynamicFont).draw(10, 10);

var _x = 100;
var _y = 0;
var _fontData = global.__Scribble.__fontDataMap[? font_get_name(dynamicFont)];
_fontData.__EnsureDynamicSurface();
var _surface = _fontData.__dynSurface;
draw_surface(_surface, _x, _y);
draw_rectangle(_x, _y, _x + surface_get_width(_surface), _y + surface_get_height(_surface), true);