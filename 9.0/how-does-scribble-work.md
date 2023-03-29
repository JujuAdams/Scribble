# How does Scribble work?

&nbsp;

Scribble isn't all that different to GameMaker's native text renderer. Each glyph (you can think about a "glyph" as a generalisation of the concept of a "letter") is drawn to the screen in the same way as a sprite: two triangles that form a rectangle where each corner is given some texture coordinates. The texture coordinates reference an image that GameMaker creates for us that contains all of the shapes needed to draw each glyph. A word is a series of these glyph sprites organised in a row, a line of text is a few words separated by some horizontal space, and so on. There's a lot of variation between languages - some don't put spaces between words! - but the basic idea remains the same: Text is drawn as a collection of glyph sprites.

The way a graphic chips renders these collections of sprites by using something called a "vertex buffer". A vertex buffer is a way of storing the instructions for all the triangles we need to draw our glyphs. The actual format of vertex buffers is beyond the scope of this lightweight discussion, but suffice to say that they contain a lot of information. Vertex buffers aren't *slow* to build per se, but they're not *free* either. When GameMaker draws text, it builds a vertex buffer that contains all of the required triangles, send that off to the GPU for rendering, and then discards the vertex buffer. If we're drawing text every frame, this means GameMaker needs to rebuild the vertex buffer every frame.

Scribble opts for a different approach using "vertex buffer caching". Instead of rebuilding vertex buffers every single time you draw a piece of text, Scribble will instead cache a vertex buffer for the text you're trying to draw so that subsequent times you draw the same piece of text with the exact same settings, Scribble grabs the vertex buffer that already exists and draws that. The logic here is that if you need to draw text on one frame then it's likely you're going to need to draw it on the next frame too. We shouldn't discard vertex buffers unless they're no longer needed, and Scribble does this automatically.

Since we're making our own vertex buffer, we can add in a bunch of additional data whilst we're building it. We use this data to embed information about each glyph in the block of text; for example, Scribble stores an index per glyph that indicates its position in the string. We use this value to more efficiently control how text is revealed when using a typewriter effect. Most of Scribble's animated effects are calculated in a vertex shader using this extra contextual data, leading to far more efficient rendering than would be possible if you were to handle the calculations yourself.

Scribble uses the string you're trying to draw as the primary means of pulling data out of the cache. Scribble wraps vertex buffers in a thing called a "text element" which is the main point of call for interacting with Scribble's renderer. We can pull a vertex buffer out of the cache by using the `scribble()` function like so:

```gml
var _element = scribble("Hello"); //Pull a text element out of the cache
_element.draw(10, 10);            //Draw the text element
```

This "vertex buffer caching" behaviour does have one noticeable downside: it's possible to accidentally pull a vertex buffer out of the cache when you didn't mean to. Consider the following:

```gml
scribble("Hello").draw(10, 10);
scribble("Hello").colour(c_lime).draw(10, 30);
```

This code should draw two lines of text, one in the default colour (white) and one in a bright green colour just below it. However, Scribble can't differentiate between the two uses because the string `"Hello"` is the same for both. This means that on the first frame we get the expected result. However, on the second frames and all subsequent frames, the first line of text is drawn in a bright green colour.