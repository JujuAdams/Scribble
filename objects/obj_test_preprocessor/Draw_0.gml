var _x = 10;
var _y = 10;

var _element = scribble("Text that doesn't specify a pre-processor");
_element.draw(_x, _y);

_y += _element.get_height() + 20;

var _element = scribble("Text that sets <undefined> for its pre-processor")
.preprocessor(undefined);
_element.draw(_x, _y);

_y += _element.get_height() + 20;

var _element = scribble("Text that forces SCRIBBLE_NO_PREPROCESS")
.preprocessor(SCRIBBLE_NO_PREPROCESS);
_element.draw(_x, _y);

_y += _element.get_height() + 20;

var _elementRefresh = scribble("Text that uses a custom pre-processor")
.preprocessor(__test_preprocessor_func_red);
_elementRefresh.draw(_x, _y);

_y += _element.get_height() + 20;

_elementRefresh.preprocessor(__test_preprocessor_func_blue);
_elementRefresh.draw(_x, _y);

_y += _elementRefresh.get_height() + 20;

var _element = scribble("Text that updates when you click the mouse")
.preprocessor(__test_preprocessor_func_mouse);
_element.draw(_x, _y);

_y += _elementRefresh.get_height() + 20;