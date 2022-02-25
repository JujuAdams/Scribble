if (keyboard_check(vk_up)) animation_speed = min(2, animation_speed + 0.01);
if (keyboard_check(vk_down)) animation_speed = max(0, animation_speed - 0.01);