typist = scribble_typist();
typist.in(0.3, 0);

scribble_typewriter_add_event("sdm", function(_element, _parameters)
{
    show_debug_message(_parameters);
});