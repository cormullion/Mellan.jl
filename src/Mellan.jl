module Mellan

export mellanize

using Luxor, Colors

import Images

# TODO: too much flipping between Int and Float here surely ?!

function getpixel(grayimage, x, y, imagewidth)
    # get grey value of pixel at x/y from image
    # since origin is in the middle of the page,
    x1 = 1 + x + (imagewidth / 2)
    y1 = 1 + y + (imagewidth / 2)
    # x and y are between -imagewidth/2 and +imagewidth/2
    # convert to values between 1 (not 0!) and imagewidth
    return float(1 - grayimage[convert(Int, floor(x1)), convert(Int, floor(y1))])
end

"""
    mellanize(imagefile, side=500;
        lineweight       =  5.0, # multiply the grey value of a pixel [0,1] to get this width of line
        minlineweight    =  0.0,
        foregroundcolor  =  "black",
        backgroundcolor  =  "antiquewhite2",
        startradius      =  5.0,   # starting radius
        margin           =  5,
        tightness         =  2.0,  # controls how much the radius lengthens for each step,
        chord            =  10.0, # length of each stroke
        annotation       =  false,
        output           =  ""
        )

where `imagefile` is path of 8bit PNG or JPG, and `side` is the required image size.
"""
function mellanize(imagefile, side=500;
        # imagefile is path of 8bit PNG or JPG
        # side is the required image size of sides
        lineweight       =  3.0, # multiply the grey value of a pixel [0,1] to get this width of line
        minlineweight    =  0.0,
        foregroundcolor  =  "black",
        backgroundcolor  =  "antiquewhite2",
        startradius      =  5.0,   # starting radius
        margin           =  5,
        tightness        =  0.5,  # controls how much the radius lengthens for each step,
        chord            =  5.0, # length of each stroke
        annotation       =  false,
        output           =  ""
        )
    pageside = side
    imagewidth = pageside - margin
    if output      == ""
        outputfilename = splitext(imagefile)[1] * "-mellan-$(side).pdf"
    else
        outputfilename = output
    end
    img1 = Images.load(imagefile)
    if isnothing(img1)
        error("Can't find a suitable image in \"$(imagefile)\"")
    end
    img1 = permutedims(img1, (2, 1))
    img = Images.imresize(img1, (imagewidth, imagewidth))
    grayimage = Gray.(img)
    d = Drawing(pageside, pageside, outputfilename)
    origin()
    centerX = centerY = 0
    background(backgroundcolor)
    sethue(foregroundcolor)
    setlinecap("round")
    theta = pi/2  # starting rotation relative to East (anticlockwise +ve x axis)
    radius1 = radius2 = 0
    imw2 = imagewidth/2
    sqrt2 = sqrt(2)
    imsq = ceil(imw2 * sqrt2)
    while radius2 < imsq # while larger radius is less than diagonal distance from center to corner
        radius1 = startradius + (tightness * theta)
        around1 = mod2pi(-theta)
        theta += chord/radius1
        radius2 = startradius + (tightness * theta)
        around2 = mod2pi(-theta)
        startpoint = Point(centerX + (cos(around1) * radius1), centerY + (sin(around1) * radius1))
        endpoint   = Point(centerX + (cos(around2) * radius2), centerY + (sin(around2) * radius2))
        gsave()
        move(startpoint)
        line(endpoint)
        # don't look up point if x/y out of range (eg margins)
        if abs(startpoint.x) <  imw2 &&
           abs(startpoint.y) <  imw2 &&
           abs(endpoint.x)   <  imw2 &&
           abs(endpoint.y)   <  imw2
              setline(minlineweight + lineweight * getpixel(grayimage, startpoint.x, startpoint.y, imagewidth))
              # TODO although actually this should be the average of start and end points...
            strokepath()
        end
        grestore()
    end

    if annotation == true
        # print the used parameter values discreetly
        fontsize(5)
        setopacity(0.4)
        text("lineweight=$lineweight, minlineweight=$minlineweight, startradius=$startradius, margin=$margin, tightness=$tightness, chord=$chord",
            centerX , pageside/2 - 5, halign=:center)
    end
    finish()
    return d
end

end # module
