scribble_font_set_default("fnt_style");
scribble_font_set_style_family("fnt_style", "fnt_style_b", "fnt_style_i", "fnt_style_bi");

text = "";
text += "# Lorem Ipsum\n";
text += "## Header 2\n";
text += "### Header 3\n";
text += "- Lorem Ipsum is simply *dummy text* of the printing and **typesetting**_industry.\n";
text += "1. _**Lorem Ipsum**_ has been the industry's \\*standard dummy\\* text ever since ***the 1500s***\n";
text += "2. [An unknown printer](url) took a galley of type and scrambled it to make a type specimen book.\n";
text += "> It has survived not only five centuries, but also the leap into electronic typesetting, remaining [spr_coin] [rainbow]essentially unchanged[/rainbow] ![spr_coin].\n";

//scribble_markdown_set_styles({
//    body: {
//        font: "fnt_style",
//    },
//    header1: {
//        font: "fnt_style_header1",
//    },
//    header2: {
//        font: "fnt_style_header2",
//    },
//    header3: {
//        font: "fnt_style_header3",
//    },
//    bullet_sprite: spr_coin,
//});

text = scribble_markdown_format(text);

element = scribble(text)
.align(fa_left, fa_middle)
.fit_to_box(700, 500);
element.origin(element.get_width()/2, 0)