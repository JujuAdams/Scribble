scribble("The Quick [rainbow]Brown[/c] [grad,c_red]Fox[/grad] [ol,c_red]Jumps[/ol] Over The Lazy Dog!")
.scale(3)
.outline(c_navy)
.shadow(c_dkgray, 1, 0, 0, 0)
.max_size(room_width - 20)
.layout_wrap()
.draw(10, 10);

scribble("[spr_sprite_font]The Quick Brown Fox Jumps Over The Lazy Dog!")
.scale(3)
.max_size(room_width - 20)
.layout_wrap()
.draw(10, 300);