VERSION >= v"0.4.0" && __precompile__()

module Mellan

export mellanize

using Luxor, Colors
import Images

# TODO: too much flipping between Int and Float here!
function getpixel(grayimage, x, y, imagewidth)
    # get grey value of pixel at x/y from image
    # since origin is in the middle of the page,
    x1 = 1 + x + (imagewidth ÷ 2)
    y1 = 1 + y + (imagewidth ÷ 2)
    # x and y are between -imagewidth/2 and +imagewidth/2
    # convert to values between 1 (not 0!) and imagewidth
    return float(1 - grayimage[convert(Int, floor(x1)), convert(Int, floor(y1))])
end

"""
    mellanize(imagefile, side;
        linescaler       =  5.0, # multiply the grey value of a pixel [0,1] to get this width of line
        minlinethickness =  0.0,
        foregroundcolor  =  "black",
        backgroundcolor  =  "antiquewhite2",
        startradius      =  5.0,   # starting radius
        margin           =  15,
        awaystep         =  2.0,  # controls how much the radius lengthens for each step,
        chord            =  10.0, # length of each stroke
        annotation       =  false,
        outfilename      =  ""
        )

where `imagefile` is path of 8bit PNG or JPG, and `side` is the required image size.
"""
function mellanize(imagefile, side;
    # imagefile is path of 8bit PNG or JPG
    # side is the required image size of sides
    linescaler       =  5.0, # multiply the grey value of a pixel [0,1] to get this width of line
    minlinethickness =  0.0,
    foregroundcolor  =  "black",
    backgroundcolor  =  "antiquewhite2",
    startradius      =  5.0,   # starting radius
    margin           =  15,
    awaystep         =  2.0,  # controls how much the radius lengthens for each step,
    chord            =  10.0, # length of each stroke
    annotation       =  false,
    outfilename      =  ""
    )
    pageside = side
    imagewidth = pageside - margin
    if outfilename == ""
        outputfilename = splitext(imagefile)[1] * "-mellan-$(side).pdf"
    else
        outputfilename = outfilename
    end
    Drawing(pageside, pageside, outputfilename)
    img1 = Images.load(imagefile)
    img = Images.imresize(img1, (imagewidth, imagewidth))
    grayimage = convert(Images.Image{Gray}, img)

    if sizeof(img1.data) == 0
        return "no image to mellanize"
    end

    origin()
    centerX = centerY = 0
    background(backgroundcolor)
    sethue(foregroundcolor)

    setlinecap("round")
    theta = pi/2  # starting rotation relative to East (anticlockwise +ve x axis)
    radius1 = radius2 = 0
    imw2 = imagewidth/2
    sqrt2 = sqrt(2)
    imsq = imw2 * sqrt2
    while radius2 < imsq # while larger radius is less than diagonal distance from center to corner
        radius1 = startradius + (awaystep * theta)
        around1 = mod2pi(-theta)
        theta += chord/radius1
        radius2 = startradius + (awaystep * theta)
        around2 = mod2pi(-theta)
        startpoint = Point(centerX + (cos(around1) * radius1), centerY + (sin(around1) * radius1))
        endpoint   = Point(centerX + (cos(around2) * radius2), centerY + (sin(around2) * radius2))
        gsave()
            move(startpoint.x, startpoint.y)
            line(endpoint.x, endpoint.y)
            # don't look up point if x/y out of range (eg margins)
            if abs(startpoint.x) <  imw2 &&
               abs(startpoint.y) <  imw2 &&
               abs(endpoint.x)   <  imw2 &&
               abs(endpoint.y)   <  imw2
                    setline(minlinethickness + linescaler * getpixel(grayimage, startpoint.x, startpoint.y, imagewidth)) # actually should be average of start and end...
            else
                setline(0)
            end
            stroke()
        grestore()
    end

    if annotation == true
        # print the used parameter values discreetly in the left corner
        fontsize(5)
        setopacity(0.2)
        text("linescaler=$linescaler, startradius=$startradius, margin=$margin, awaystep=$awaystep, chord=$chord",
            -pageside/2 + margin , (pageside/2) - 5)
    end
    finish()
    return outputfilename
end

end
