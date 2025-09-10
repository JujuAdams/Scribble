element = scribble_unique("Abc._Abc[delay]defghijklmnop. Qrstuvwxyz... Abc.Def.Ghi.Jkl.Mno.")
element.allow_glyph_data_getter();
element.in(0.1, 2);
element.character_delay_add(".", 2000);