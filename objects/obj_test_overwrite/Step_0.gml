if (keyboard_check_pressed(vk_space))
{
    test_value++;
    
    var _string = "[rainbow][wave]";
    repeat(test_value) _string += string(test_value);
    
    element.overwrite(_string);
}