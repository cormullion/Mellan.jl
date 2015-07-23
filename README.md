# Mellan

Claude Mellan (1598 to 1688) was a French artist and engraver, remembered today (if at all) only for his virtuosic engravings, in which the image consists of a single spiral groove starting at the centre and winding outwards (like a vinyl record). The different tones are obtained by the slight swelling and shrinking of the line as it proceeds on its spiral outward course. Here's what Steve Jobs might have looked like in Mellan's hands:

![mellanized Steve Jobs](test/steve-jobs-mellan-400.jpg)

Today's computers don't find these images difficult to produce, but the effect is pleasing. This Julia package will 'Mellanize' images and output a PDF file. I want to investigate laser-cutting an image this way one day...

![mellanized Obama](test/obama-mellan-400.jpg)

# Requirements

Julia v0.3.

You also need the Luxor (a simple Cairo wrapper, also on my GitHub page), Color, and Images packages.

The image should be square (obviously), and a JPG or 8 bit PNG.

# Usage

    using Mellan

    mellanize("obama.jpg",
	    800,
	    linescaler      = 5,
	    foregroundcolor = Color.color("gray30"),
	    backgroundcolor = Color.color("antiquewhite2"),
	    startradius     = 5,
	    margin          = 10,
	    awaystep        = 1,
	    chord           = 4,
	    annotation      = true)

Use the `mellanize` function and supply a path name of an image and the required sidelength. The keyword parameters are all optional, but the ones of interest are:

-	linescaler

	a number greater than 0 (defaults to 5). The value of a pixel is multiplied by this number to give the width of the line. So with a value of 5, a 50% gray pixel is drawn with a width of 2.5 pixels, and a black pixel with a width of 5 pixels.

- start radius

	the distance away from the centre (default 5). This shouldn't be zero, because the lines don't work when they're too close to the centre, particularly if the chord length is long.

- awaystep

    this value determines the spacing of the groove (default 2).

- chord

	the length of each line (default 10). This is constant for the entire image, although the line width changes. Shorter lines provide more detail.

- annotation

    add annotation at the bottom of the image showing current settings (default false). This is useful when experimenting.
