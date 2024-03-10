var _string = @"[fa_center][fa_middle][fnt_riffic_sdf][rainbow][wave]Welcome to Scribble 9![/]

Scribble is a multi-effects text engine designed to be fast, easy, and fun.

It supports[scale,2][spr_sprite_font] in-line font changes (and spritefonts!) [/]as well as in-line sprites[nbsp][spr_large_coin]. Scribble can do a [wheel]bunch[/wheel] of [jitter]effects[/jitter] without slowing down your game.

Other examples and test cases in this project file will show you what else Scribble can do including an in-built typewriter, the events system, SDF fonts, and more!";



//Draw our string with wrapping, and using a typist for the typewriter effect
scribble(_string)
.wrap(850)
.draw(room_width div 2, room_height div 2, typist);