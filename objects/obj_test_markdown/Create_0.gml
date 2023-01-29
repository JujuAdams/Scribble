scribble_font_set_default("fnt_style");
scribble_font_set_style_family("fnt_style", "fnt_style_b", "fnt_style_i", "fnt_style_bi");

text = "";
text += "# Lorem Ipsum\n";
text += "## Header 2\n";
text += "- **Lorem Ipsum** is simply\n";
text += "- *dummy text* of the\n";
text += "- printing and typesetting_industry.\n";
text += "1. _**Lorem Ipsum**_ has been the industry's \\*standard dummy\\* text ever since ***the 1500s***\n";
text += "2. [An unknown printer](url) took a galley of type and scrambled it to make a type specimen book.\n";
text += "\n";
text += "### Header 3\n";
text += "> It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.\n";
text += "It was popularised in the ![spr_coin] [rainbow]1960s[/rainbow] ![spr_coin] with the release of Letraset sheets containing Lorem Ipsum passages. [wave]Wasn't that educational?[/wave]";

//scribble_markdown_set_styles({
//    body:        "[c_white][fnt_style]",
//    header1:     "[fnt_style_header1]",
//    header2:     "[fnt_style_header2]",
//    header3:     "[fnt_style_header3]",
//    bold:        "[fnt_style_b]",
//    italic:      "[fnt_style_i]",
//    bold_italic: "[fnt_style_bi]",
//    bullet:      "[spr_coin,1]",
//    quote:       "        [fnt_style_i][c_ltgray]> ",
//    list:        "    ",
//});

text = scribble_markdown_format(text);
show_message(text);

element = scribble(text)
.align(fa_left, fa_middle)
.fit_to_box(700, 500);
element.origin(element.get_width()/2, 0)