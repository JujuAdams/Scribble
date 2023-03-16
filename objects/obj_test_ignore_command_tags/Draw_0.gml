scribble("Click mouse to ignore command tags\n\n[c_red][spr_white_coin] <-- red coin![/]\n[rainbow][spr_white_coin] <-- rainbow coin![/]\n[cycle, 60, 100, 0, 200][spr_white_coin] <-- colour cycle coin!")
.ignore_command_tags(mouse_check_button(mb_left), mouse_check_button(mb_right))
.draw(x, y);