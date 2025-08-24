var _string = "His manner was not effusive[sdm,effusive]. It seldom was; but he was glad, I think, to see me. With hardly a word spoken, but with a kindly eye, he waved me to an armchair, threw across his case of cigars, and indicated a spirit[sdm,spirit] case and a gasogene[sdm,gasogene] in the corner. Then he stood before the fire[sdm,fire] and looked me over in his singular introspective fashion.";

element = scribble_unique(_string)
.reveal_type(SCRIBBLE_REVEAL_PER_LINE)
.in(0.02, 1)
.wrap(room_width/2);

scribble_typists_add_event("sdm", function(_element, _parameters)
{
    show_debug_message($"{current_time}    {_parameters}");
});