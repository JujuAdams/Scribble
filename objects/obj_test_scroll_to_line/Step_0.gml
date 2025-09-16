// Feather disable all

if (mouse_check_button(mb_left))
{
    maxWidth  = mouse_x - 10;
    maxHeight = mouse_y - 10;
}

if (keyboard_check_pressed(vk_up))
{
    targetLine = max(0, targetLine-1);
    scribble(text).scroll_to_line(targetLine);
}

if (keyboard_check_pressed(vk_down))
{
    targetLine = min(targetLine+1, scribble(text).get_line_count()-1);
    scribble(text).scroll_to_line(targetLine);
}