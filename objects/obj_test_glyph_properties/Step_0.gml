if (keyboard_check_pressed(vk_anykey))
{
    scribble_super_create("target_font");
    scribble_super_glyph_copy_all("target_font", "fnt_test_1", true);
    
    var _range = [];
    if (keyboard_check_pressed(ord("1"))) _range = all;
    if (keyboard_check_pressed(ord("2"))) _range = "acegikmo";
    if (keyboard_check_pressed(ord("3"))) _range = ["bdfh", "jlnp"];
    if (keyboard_check_pressed(ord("4"))) _range = ["j", "p"];
    if (keyboard_check_pressed(ord("5"))) _range = [97, 103];
    if (keyboard_check_pressed(ord("6"))) _range = [98, 99, 104, 105];
    if (keyboard_check_pressed(ord("7"))) _range = [[98, 105], 109];
    if (keyboard_check_pressed(ord("8"))) _range = [97, 97, 97, 97];
    if (keyboard_check_pressed(ord("9"))) _range = [["a", "c"], ["e", "g"], ["i", "l"]];
    if (keyboard_check_pressed(ord("0"))) _range = [[32, 127], 9981];
    
    scribble_glyph_set("target_font", _range, SCRIBBLE_GLYPH.Y_OFFSET, 5, true);
    scribble_refresh_everything();
}