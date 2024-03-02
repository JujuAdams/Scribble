fpsRealSmoothed = lerp(fpsRealSmoothed, fps_real, 0.05);

if (keyboard_check_pressed(vk_f1)) showHelp = not showHelp;

if (mouse_check_button(mb_left))
{
    width  = mouse_x - x;
    height = mouse_y - y;
}

if (mouse_check_button(mb_right))
{
    x = mouse_x;
    y = mouse_y;
}

if (keyboard_check_pressed(ord("1"))) mode = 1;
if (keyboard_check_pressed(ord("2"))) mode = 2;
if (keyboard_check_pressed(ord("3"))) mode = 3;
if (keyboard_check_pressed(ord("4"))) mode = 4;
if (keyboard_check_pressed(ord("5"))) mode = 5;
if (keyboard_check_pressed(ord("6"))) mode = 6;
if (keyboard_check_pressed(ord("7"))) mode = 7;

if (keyboard_check_pressed(vk_space)) ScribbletSetBudget((ScribbletGetBudget() < 0)? 1000 : -1);

if (keyboard_check_pressed(ord("F")))
{
    font = (font == fntTest)? fntTestSDF : fntTest;
}

if (keyboard_check(vk_shift))
{
    if (keyboard_check_pressed(vk_left))
    {
        switch(hAlign)
        {
            case fa_left:   hAlign = fa_center; break;
            case fa_center: hAlign = fa_right;  break;
        }
    }
    
    if (keyboard_check_pressed(vk_right))
    {
        switch(hAlign)
        {
            case fa_center: hAlign = fa_left;   break;
            case fa_right:  hAlign = fa_center; break;
        }
    }
    
    if (keyboard_check_pressed(vk_up))
    {
        switch(vAlign)
        {
            case fa_top:    vAlign = fa_middle; break;
            case fa_middle: vAlign = fa_bottom; break;
        }
    }
    
    if (keyboard_check_pressed(vk_down))
    {
        switch(vAlign)
        {
            case fa_bottom: vAlign = fa_middle; break;
            case fa_middle: vAlign = fa_top;    break;
        }
    }
}
else if (keyboard_check(vk_control))
{
    if (keyboard_check_pressed(vk_left )) width--;
    if (keyboard_check_pressed(vk_right)) width++;
    if (keyboard_check_pressed(vk_up   )) height--;
    if (keyboard_check_pressed(vk_down )) height++;
}
else
{
    if (keyboard_check_pressed(ord("Q"))) fontScale += 0.1;
    if (keyboard_check_pressed(ord("A"))) fontScale = max(0.2, fontScale - 0.1);
        
    if (keyboard_check(vk_up)) stressCount += 10;
    if (keyboard_check(vk_down)) stressCount = max(1, stressCount - 10);
}

if (keyboard_check(vk_enter))
{
    if (current_time - startTime > 2000)
    {
        if (fps >= 60)
        {
            if (fps_real >= 70)
            {
                stressCount++;
            }
            else
            {
                stressCount += 0.25;
            }
        }
        else if (fps < 60)
        {
            if (fps < 30)
            {
                stressCount -= max(20, 166667/delta_time);
            }
            else if (fps < 50)
            {
                stressCount--;
            }
            else
            {
                stressCount -= 0.25;
            }
        }
        
        stressCount = max(1, stressCount);
    }
}