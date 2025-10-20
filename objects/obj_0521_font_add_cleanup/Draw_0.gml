// Feather disable all

var _string = "";

if (keyboard_check(ord("1")))
{
    _string = "abcdefg";
}
else if (keyboard_check(ord("2")))
{
    _string = "hijklmo";
}

scribble(_string).font(dynamicFont).draw(10, 10);