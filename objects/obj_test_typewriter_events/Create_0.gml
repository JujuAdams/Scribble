typist = scribble_typist();
typist.in(0.01, 0);
typist.__use_lines = true;

scribble_typists_add_event("sdm", function(_element, _parameters)
{
    show_debug_message(_parameters);
});