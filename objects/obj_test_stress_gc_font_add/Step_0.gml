if (keyboard_check_pressed(vk_space)) toggle = !toggle;
if (keyboard_check_pressed(ord("F"))) scribble_flush_everything();
if (keyboard_check_pressed(ord("G"))) gc_collect();

if (keyboard_check_pressed(ord("C")))
{
    var _fontData = global.__Scribble.__fontDataMap[? font_get_name(dynamicFont)].__DebugFlushDynamicSurface();
}