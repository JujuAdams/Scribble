scribble("A Puella Magi Madoka Magica DVD costs ¥3,000").draw(x, y);

draw_text(x, y + 30, "scribble_font_has_character = " + string(scribble_font_has_character("fnt_test_0", "¥")));

scribble("\"Juju\" is 猪猪 in Chinese").draw(x, y + 60);

draw_text(x, y + 90, "scribble_font_has_character = " + string(scribble_font_has_character("fnt_test_0", "猪")));