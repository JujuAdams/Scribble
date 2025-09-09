element = scribble_unique("Abc. Abcdefghijklmnop. Qrstuvwxyz... Abc.Def.Ghi.Jkl.Mno.")
element.allow_glyph_data_getter();
element.in(0.1, 10);
element.character_delay_add(".", 300);