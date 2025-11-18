var _element = scribble("Here is some text laid out along a straight path");
_element.path(pth_test_straight);
_element.draw(400, 200);

var _element = scribble("Here is some text laid out along a smooth path");
_element.path(pth_test_curve, 0, 1);
_element.draw(400, 400);

var _element = scribble("Here is some text laid out along a closed path");
_element.path(pth_test_circle);
_element.draw(200, 200);