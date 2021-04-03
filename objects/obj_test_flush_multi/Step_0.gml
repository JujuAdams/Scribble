if (keyboard_check_pressed(ord("F")))
{
    //Force an edge case
    global.__scribble_ecache_list_index = 2;
    
    element1.flush();
    element2.flush();
}