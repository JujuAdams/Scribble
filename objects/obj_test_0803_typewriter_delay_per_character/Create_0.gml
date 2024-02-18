if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) __scribble_error("SCRIBBLE_ALLOW_GLYPH_DATA_GETTER must be set to <true> for this test case");

typist = scribble_typist_legacy();
typist.in(0.1, 3);
typist.character_delay_add(".", 1000);

test_string = "Abc. Abcdefghijklmnop. Qrstuvwxyz... Abc.Def.Ghi.Jkl.Mno.";