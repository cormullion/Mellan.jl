
| **Build Status**                          | **Code Coverage**               |
|:-----------------------------------------:|:-------------------------------:|
| [![Build Status][ci-img]][ci-url]         | [![][codecov-img]][codecov-url] |
| [![Build Status][appvey-img]][appvey-url] |                                 |

# Mellan

Claude Mellan (1598 to 1688) was a French artist and engraver, remembered today (if at all) only for his virtuosic engravings, in which the image consists of a single spiral groove starting at the centre and winding outwards (like a vinyl record). The different tones are obtained by the slight swelling and shrinking of the line as it proceeds on its spiral outward course. Here's what Leonardo da Vinci's Mona Lisa would have looked like if rendered by Mellan.

![mellanized Mona Lisa](images/mona.svg)

Today's computers don't find these images difficult to produce, but the effect is pleasing. This little Julia package will 'Mellanize' images and output a PNG/SVG/PDF file.

# Requirements

Julia v1, and the packages Luxor, Colors, and Images.

The image should be square (obviously!), and a JPG or 8 bit PNG.

# Usage

```
using Mellan

mellanize(dirname(dirname(pathof(Mellan))) * "/test/mona.png", output="/tmp/mona.svg")
```

draws the image above. There are plenty of options to play with:

```
mellanize("Mellan/test/mona.png",
           500, # default side length
           lineweight      = 3,
           output          = "mona-mellan.svg",
           minlineweight   = 0.1,
           foregroundcolor = "black",
           backgroundcolor = "gold2",
           startradius     = 5,
           margin          = 0,
           tightness       = 0.5,
           chord           = 2,
           annotation      = true)
```

![another mellanized Mona Lisa](images/mona-mellan.svg)

Use the `mellanize` function and supply a path name of an image and optionally the required side length. The keyword parameters are all optional, but the ones of interest are:

- lineweight

	a number greater than 0 (defaults to 3). The value of a pixel is multiplied by this number to give the width of the line. So with a value of 5, a 50% gray pixel is drawn with a width of 2.5 pixels, and a black pixel with a width of 5 pixels.

- minlineweight

    By default, if the image has white areas, no lines are drawn there. While the effect is good, it means that the image is no longer a true spiral. If you want to force a line to appear even if the image is white, specify a minimum line thickness greater than the default of 0.

- startradius

	the distance away from the centre (default 5). This shouldn't be zero, because the lines don't work when they're too close to the centre, particularly if the chord length is long.

- tightness

    this value determines the spacing of the groove (default 0.5).

- chord

	the length of each line segment (default 2.0). This is constant for the entire image, although the radius changes. Shorter lines provide more detail.

- annotation

    add annotation at the bottom of the image showing current settings (default false). This is useful when experimenting.

- output

    the pathname for the output image. If not supplied, the name is constructed with `splitext(imagefile)[1] * "-mellan-$(side).pdf"`.


[pkgeval-link]: http://pkg.julialang.org/?pkg=Mellan

[ci-img]: https://github.com/cormullion/Mellan.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/cormullion/Mellan.jl/actions?query=workflow%3ACI

[appvey-img]: https://ci.appveyor.com/api/projects/status/jfa9e54lv92rqd3m?svg=true
[appvey-url]: https://ci.appveyor.com/project/cormullion/Mellan-jl/branch/master

[codecov-img]: https://codecov.io/gh/cormullion/Mellan.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/cormullion/Mellan.jl