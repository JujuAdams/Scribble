if (toggle)
{
    test_text = "[fa_middle][fa_center]";
    repeat(1000) test_text += chr(choose(32, irandom_range(32, 90), irandom_range(94, 126), irandom_range(94, 126)));
    counter++;
}

var _t = get_timer();
if (not keyboard_check(vk_shift))
{
    scribble(test_text)
    .font(dynamicFont)
    .max_size(500)
    .layout_wrap()
    .blend(c_white, not keyboard_check(vk_control))
    .draw(room_width div 2, room_height div 2);
}
_t = get_timer() - _t;

smoothed_time = lerp(smoothed_time, _t, 0.01);

var _system = __ScribbleSystem();

draw_set_font(fntScribbleFallback);
draw_text(10,  30, "cache array = " + string(array_length(_system.__elementWeakArray)));
draw_text(10,  50, "cache map = " + string(ds_map_size(_system.__elementCacheMap)));
draw_text(10,  90, "counter = " + string(counter));
               
draw_text(10, 130, "time taken = " + string(smoothed_time));
draw_text(10, 150, "fps_real = " + string(fps_real));

if (keyboard_check(vk_control))
{
    var _fontData = global.__Scribble.__fontDataMap[? font_get_name(dynamicFont)];
    _fontData.__EnsureDynamicSurface();
    var _surface = _fontData.__dynSurface;
    
    var _x = (room_width  div 2) - (surface_get_width( _surface) div 2);
    var _y = (room_height div 2) - (surface_get_height(_surface) div 2);
    
    draw_surface(_surface, _x, _y);
    draw_rectangle(_x, _y, _x + surface_get_width(_surface), _y + surface_get_height(_surface), true);
}