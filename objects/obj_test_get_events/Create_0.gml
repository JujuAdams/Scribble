scribble_font_set_default("fnt_test_2");
scribble_font_add_all();

scribble_typewriter_add_event("sdm", function(_element, _parameters)
{
    show_debug_message(_parameters);
});

element = scribble("[sdm,first]abc[sdm,end]");
show_debug_message(element.events_get(0));
show_debug_message(element.events_get(1));
show_debug_message(element.events_get(2));
show_debug_message(element.events_get(3));