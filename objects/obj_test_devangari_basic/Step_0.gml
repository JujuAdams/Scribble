if (keyboard_check_pressed(vk_left))
{
    index = (index - 1 + array_length(testVectorArray)) mod array_length(testVectorArray);
    __scribble_trace("krutidev = ", UnicodeToKrutidev(testVectorArray[index].unicode));
}

if (keyboard_check_pressed(vk_right))
{
    index = (index + 1) mod array_length(testVectorArray);
    __scribble_trace("krutidev = ", UnicodeToKrutidev(testVectorArray[index].unicode));
}
