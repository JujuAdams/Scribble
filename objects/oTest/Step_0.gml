if (mouse_check_button(mb_left))
{
    width  = mouse_x - x;
    height = mouse_y - y;
}

if (keyboard_check_pressed(vk_left)) width--;
if (keyboard_check_pressed(vk_right)) width++;

if (keyboard_check_pressed(ord("1"))) mode = 1;
if (keyboard_check_pressed(ord("2"))) mode = 2;
if (keyboard_check_pressed(ord("3"))) mode = 3;

initialTimer++;
if (initialTimer > 120)
{
    if (fps_real > 60)
    {
        stressCount++;
    }
    else if (fps < 58)
    {
        stressCount -= 0.1;
    }
}