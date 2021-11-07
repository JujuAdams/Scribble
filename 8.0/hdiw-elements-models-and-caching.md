# Text Elements, Text Models, and Caching

&nbsp;

Scribble uses two tiers of caching, one for **text elements** and another for **text models**. Both elements and models are automatically cached by Scribble, allowing for text layout to happen _once_ and then be reused for subsequent frames. This dramatically lowers the cost of drawing text after the text layout step has been completed. This is a similar solution to pre-rendering glyphs onto a texture page, though the caching that Scribble does is performed when the game is running rather than when the game compiles. Both text elements and text models can be reused in different ways and exist in two different cache pools.

The distinction between text elements and text models is critical to Scribble:

|Text Element                                                 |Text Model                                                     |
|-------------------------------------------------------------|---------------------------------------------------------------|
|Holds variables, and a reference to a text model             |Holds vertex buffer data                                       |
|Stores text state, such as page or text wrapping width       |Uses state values from a text element to generate graphics data|
|Has [public methods](scribble-methods)                       |Has no public methods at all                                   |
|Dynamic, can be modified by calling methods                  |Static/read-only, cannot be modified once created              |
|Does no drawing itself; draw commands are passed to the model|Able to submit text to the GPU for rendering                   |
|Holds values to be sent to Scribble's shader                 |Configures Scribble's shader using values from a text element  |
|Garbage collected after both:<br>1. It hasn't been drawn for a few frames<br>2. No reference to it exists elsewhere in memory|Garbage collected when no text elements reference it|

## Text Models

Being able to cache text model results between frames means that Scribble can deliver a whole bunch of relatively expensive features without damaging performance. A new model is created by an element when the model cache contains no model with the exact desired properties. These properties are things like font size and text wrapping width, things that fundamentally change the layout of glyphs. Anything marked as a **regenerator** on the [`scribble()` methods page](scribble-methods) is modifying a text element property that would cause a new model to be needed. If a regenerator method is called on an element then the element will mark itself as "dirty". When the text element is next drawn (or a model property is requested), the text element will discard its previous reference to its old model, and try to find a new model in the cache, creating a new model if necessary. If no other elements hold references to the old model then the old model will be automatically garbage collected by Scribble after a few frames. Creating text models is easily the most demanding operation for Scribble.

## Text Elements

Models are created when an element needs them, and similarly a text element is created when _you_ need them. `scribble()` is a function that checks the cache of text elements and, if a match exists, then the already extant element is returned. If no text element exists then a new one is created and returned. The search string that is used is very simple: it's the text passed into `scribble()` plus the [unique ID](scribble-methods?id=scribblestring-uniqueid), if one is specified. This has the side effect of two calls to `scribble()` that use the same input text occasionally getting confused with each other. This is rarer than you'd think, and the unique ID option is provided to disambiguate text elements when it comes up.

Unlike models, elements are public and the developer can create and hold references to them. Developers can also **not** hold references to them! For example:

```GML
///Draw
scribble("Here's a volatile text element.").draw(x, y);
```

This line of code by itself requires an element to exist which, in turn, requires a model to be created so that the text can be drawn. There is no reference to it, however, since the return value from `scribble()` is not being assigned to a variable or placed in a data structure etc. The next frame, we don't want to create a brand new text element and a brand new text model, we want to use the element and model we created in the last frame. Since there's no reference hanging around for this element, we call it a **volatile text element**.

```GML
///Create
stash = scribble("Here's a stashed text element");

///Draw
stashed.draw(x, y);
```

In this situation, we create an element and then store a reference to it in a variable. This keeps the reference alive and, as we would expect, also keeps the text element alive too. This is called a **stashed text element**. The text element will never be garbage collected and any text model that it references will also never be garbage collected.

?> A stashed text element will still be in the global cache. Calling `scribble("Here's a stashed text element")` elsewhere will return the stashed text element. It is, unfortunately, not possible to differentiate volatile and stashed elements programmatically. It is recommended that you use unique IDs with stashed elements.

In this situation, the text model won't be generated until the Draw event because Scribble doesn't generate models until they're essential to allow for regenerator methods to be called on an element without causing lots of model creation when it's not needed. Consider:

```GML
///Create
stashed = scribble("Here's a stashed text element with lots of regenerator methods");
stashed.starting_format(fntComicSans, c_fuchsia);
stashed.wrap(400);

///Draw
statshed.draw(x, y);
```

We're calling two [regenerator methods](scribble-methods) here. If we generated a model as soon as possible, we'd have to generate three models - for `scribble()`, for `.starting_format()`, and for `.wrap()` - so it's going to require less time overall if we only generate a model once when we need it. However, sometimes it _is_ useful to build a text model up front and not wait until a Draw event to do that work. This is where the [`.build()` method](scribble-methods?id=buildfreeze) comes in:

```GML
///Create
stashed = scribble("Here's a stashed text element with lots of regenerator methods");
stashed.starting_format(fntComicSans, c_fuchsia);
stashed.wrap(400);
stashed.build(true); //Force creation of a model, and freeze it for extra FPS

///Draw
stashed.draw(x, y); //Scribble won't generate a model, one already exists
```