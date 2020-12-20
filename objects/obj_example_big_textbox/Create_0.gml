scribble_font_set_default("fnt_test_0");
scribble_font_add_all();
scribble_font_set_style_family("fnt_style", "fnt_style_b", "fnt_style_i", "fnt_style_bi");

scribble_typewriter_add_event("portrait", example_dialogue_set_portrait);
scribble_typewriter_add_event("name", example_dialogue_set_name);
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_font_add_from_sprite("spr_sprite_font", _mapstring, 0, 3);

textbox_conversation = ["[portrait,spr_portrait][name,Juju]Hi! Welcome to [wave][rainbow]Scribble " + __SCRIBBLE_VERSION + "![/rainbow][/wave]\n\n\n[slant]Please press space to advance the conversation[/slant]",
                        "This example will show you how to make a simple dialogue system.[delay] This won't be an exhaustive demo but it should show you enough to get excited about what you can achieve with [rainbow]Scribble[/rainbow].",
                        "Let's try changing this font to something more gamey\n[spr_sprite_font][delay].[delay].[delay].[delay]\nMuch better![delay] [rainbow]Scribble[/rainbow] lets you change font in the middle of a string using simple tags.[delay] In this case, we switched to a spritefont (which work the same way as GM's font_add_ext, more or less)",
                        "Switching colours is easy too. Check this out:\n[delay][c_red]Richard [c_orange]Of [c_yellow]York [c_lime]Gave [c_blue]Battle [c_fuchsia]In [c_purple]Vain[/][delay]\n\nThis is all done using in-line tags!\n[spr_sprite_font]it's super easy c:",
                        "You might have noticed that we can [delay,200]d[delay,200]e[delay,200]l[delay,200]a[delay,200]y[delay,200] text as it appears. We can also pause and wait for user input... [pause]...whenever we want as well.",
                        "Here're some in-line sprites: [spr_coin][spr_large_coin][spr_coin]. Sprites can be thrown in [spr_coin,0] wherever [spr_coin,1] you [spr_coin,2] like [spr_coin,3]. There's no performance penalty to using them!",
                        "Here's a quick demonstration of some animated effects:\n\n[wave]waaaaaaave![/wave]   [shake]oh no i'm scared =c[/shake]   [wobble]Jiggle jelly on a plate[/wobble]   [rainbow]All the colours of the rainbow[/rainbow]   [pulse]PULSE[/pulse]   [wheel]You spin me right round baby[/wheel]   [cycle,60,70,80,70]Colour cycling[/cycle] [jitter]nEeD cOFfeE[/jitter]",
                        "These can of course be combined together:\n\n[fnt_style][wave][wheel][cycle,100,110,150,200]wooo[b]ooooo[bi]ooooo[i]oooo[r]oooow[/]",
                        "But that's enough about formatting, what about events?[delay] Events can be used for a ton of different things, but here we use them to change portrait sprite and portrait name.",
                        "[portrait,spr_portrait_2][name,You][fnt_dialogue_2]Oh! Am I talking now?",
                        "[portrait,spr_portrait][name,Juju]You sure are! With a slightly different font too.",
                        "[portrait,spr_portrait_2][name,You][fnt_dialogue_2][shake]How exciting!![/shake] How is this done?",
                        "[portrait,spr_portrait][name,Juju]Well, it's quite easy really, you set up a couple scripts that change the portrait and the speaker's name, and you bind them to [rainbow]Scribble[/rainbow] as an \"event\".[delay] You can then call those events like you would any other in-line command tag.",
                        "[portrait,spr_portrait_2][name,You][fnt_dialogue_2]Oh hey, that's neat; sounds like a whole lot less work than other methods. [delay]Say[delay,100].[delay,100].[delay,100].[delay] D'ya think we could try something?",
                        "[portrait,spr_portrait][name,Juju]Sure, what's on your mind?[pause]\n[portrait,spr_portrait_2][name,You][fnt_dialogue_2]- Could we try talking on alternate lines?[/font][pause]\n[portrait,spr_portrait][name,Juju]I don't see why not![pause][portrait,spr_portrait_2][name,You][fnt_dialogue_2]\n- Haaaaa this is cool! What happens if we overrun the end of the textbox? Does [rainbow]Scribble[/rainbow] handle that ok? It seems like automatic pagination would be useful for handling things like localisation.[/font]",
                        "[portrait,spr_portrait][name,Juju][rainbow]Scribble[/rainbow] does all the pagination for you. It's super super nice. Handling text overflow can be a real pain if you're not careful.",
                        "[portrait,spr_portrait_2][name,You][fnt_dialogue_2]Ah jeez, look at the time. I need to go.\n\nSee you soon!",
                        "[portrait,spr_portrait][name,Juju]See ya!\n\n[slant]Press space to restart the conversation[/slant]"];

textbox_width              = 400;
textbox_height             = 100;
textbox_portrait           = -1;
textbox_name               = undefined;
textbox_conversation_index = 0;
textbox_skip               = false;
textbox_element            = SCRIBBLE_NULL_ELEMENT;