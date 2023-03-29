# How does Scribble work?

&nbsp;

?> The information on this page refers to using `scribble()`. For very new users, or those transitioning from GameMaker's native `draw_text()` functions, you may want to stick with the [quick functions](quick-functions) to take advantage of Scribble's power without getting into the weeds.

Scribble isn't all that different to GameMaker's native text renderer. Every string is broken down into individual symbols, called "glyphs". You can think about a "glyph" as a generalisation of the concept of a "letter" - a glyph could be the letter `J`, or a sprite, or some punctuation, or individual components of the compound Thai character `นี`. Each glyph is drawn to the screen in the same way as a sprite: two triangles that form a rectangle where each corner is given some texture coordinates. The texture coordinates reference a font texture that GameMaker creates for us, effectively a spritesheet that contains all of the shapes we need. A word is a series of these glyphs organised in a row, a line of text is a few words separated by some horizontal spaces, and so on. There's a lot of variation between languages )(Thai doesn't put spaces between words in the same sentence) but the basic idea remains the same: A string is drawn as a collection of glyphs arranged to form lines of text.

The way a GPU renders these collections of glyphs is by using something called a "vertex buffer". A vertex buffer is a way of storing the instructions for all the triangles we need to draw our string. The actual format of vertex buffers is beyond the scope of this lightweight discussion, but suffice to say that they contain a lot of information. Vertex buffers aren't *slow* to build per se, but they're not *free* either. When GameMaker draws text, it builds a vertex buffer that contains all of the required triangles, sends that off to the GPU for rendering, and then discards the vertex buffer. If we're drawing text every frame, this means GameMaker needs to rebuild the vertex buffer every frame. This is simple to build and reliable, but not especially efficient.

Scribble opts for a different approach using "vertex buffer caching". Instead of rebuilding vertex buffers every single time you draw a piece of text, Scribble will instead cache a vertex buffer for the text you're trying to draw. Subsequent draw commands for the same piece of text (with the exact same settings) causes Scribble to grab the vertex buffer that already exists and draws that. The logic here is that if you need to draw text on one frame then it's likely you're going to need to draw it on the next frame too. We shouldn't discard vertex buffers unless they're no longer needed because this wastes precious time, and Scribble handles this automatically for you.

Since we're making our own vertex buffer, we can add in a bunch of additional data whilst we're building it. We use this data to embed information about each glyph; for example, Scribble stores an index per glyph that indicates its position in the string. We use this value to efficiently control how text is revealed when using a typewriter effect. Most of Scribble's animated effects are calculated in a vertex shader using this extra contextual data, leading to far more efficient rendering than would be possible if you were to handle the calculations yourself.

I'm skipping over a **lot** of implementation details. Scribble is complicated, but the bits that you need to learn to get up and running are simple. When you start to combine these individual bits of functionality together, you'll find that Scribble is very powerful and can support a wide variety of use cases.

&nbsp;

## Using Scribble

Scribble uses the string you're trying to draw as the primary means of pulling data out of the cache. Scribble stores information in the case by using a thing called a "text element". This will be your main point of call for interacting with Scribble's renderer. We can pull a vertex buffer out of the cache by using the `scribble()` function like so:

```gml
var _element = scribble("Hello"); //Pull a text element out of the cache
```

Because the text element - what `scribble()` returns - is implemented as a struct, we can call methods on that struct. The most common method that you'll be calling is, naturally, the method that draws the text to the screen.

```gml
var _element = scribble("Hello"); //Pull a text element out of the cache
_element.draw(10, 10);            //Draw the text
```

We can call other text element methods, such as `.colour()`, by

```gml
var _element = scribble("Hello"); //Pull a text element out of the cache
_element.colour(c_lime);          //Makes the text bright green
_element.draw(10, 10);            //Draw the text
```

Most text element methods return the text element itself. This seems like a minor detail on the surface, but in reality this is massively useful as it allows us to chain methods together. This sort of design pattern is called a "fluent interface". The above three lines of code can be ompressed into a single line:

```gml
scribble("Hello").colour(c_lime).draw(10, 10);
```

There are a **ton** of methods that Scribble has available for use. These are organised by feature and can be found by clicking around on the sidebar. Scribble also has numerous **command tags** that can be used to insert and control text. Again, details on these can be found from the sidebar, but here are a few examples:

```gml
scribble("This text is [c_red]red[/c].").draw(10, 10);
scribble("[c_center]Text can be aligned via command tags too.").draw(room_width/2, 30);
scribble("Scribble can fake [slant]italics[/slant].").draw(10, 50);
scribble("[rainbow][wave]And we have some attractive text animations as well.").draw(10, 70);
```

&nbsp;

## Cache Collisions

This "vertex buffer caching" behaviour does have one noticeable downside: it's possible to pull the same text element out of the cache twice even though you intend to use it for two different purposes. This is uncommon but does come up every now and again so we'll discuss some solutions. Consider the following:

```gml
scribble("Hello").draw(10, 10);
scribble("Hello").colour(c_lime).draw(10, 30);
```

This code should draw two lines of text, one in the default colour (white) and one in a bright green colour just below it. However, Scribble can't differentiate between the two uses because the string `"Hello"` is the same for both. This means that on the first frame we get the expected result. However, on the second frames and all subsequent frames, the first line of text is drawn in a bright green colour. This is not what we want so we need to find a way to differentiate the two calls of `scribble("Hello")`.

The easiest solution is to use `scribble_unique()` instead of `scribble()`. This function operates in basically the same way as `scribble()` only the first argument allows you to provide a "unique ID" to disambiguate different calls that would otherwise be identical. The unique ID will not be visible when drawing text, it is purely an internal Scribble value.

```gml
scribble_unique(1, "Hello").draw(10, 10);
scribble_unique(2, "Hello").colour(c_lime).draw(10, 30);
```

This code will draw the two lines of text in two different colours as we wanted.

There is an alternative solution that may be useful in some other situations. Remembering that Scribble chooses text elements from the cache based on the string that is being drawn, if we change the `.colour()` text element method into a `[c_lime]` command tag then we will generate two different text elements.

```gml
scribble("Hello").draw(10, 10);
scribble("[c_lime]Hello").draw(10, 30);
```

This is a more direct way of ensuring the two text elements are stored as two unique items in the cache, but you can hopefully see how this becomes impractical when there are a large number of properties, or you're calling methods on text elements that cannot be converted into command tags.