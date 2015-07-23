module Mellan

export mellanize

println("loading Luxor")
using Luxor
println("loading Color")
using Color
println("loading Images")
using Images
println("finished loading") # looking forward to version 0.4 when this isn't required...

function getpixel(grayimage, x, y)
    # get grey value of pixel at x/y from image
    # since origin is in the middle of the page,
    # x and y are between -imagewidth/2 and +imagewidth/2
    # convert to values between 1 (not 0) to pageside
    global imagewidth
    x1 = 1 + x + (imagewidth/2)
    y1 = 1 + y + (imagewidth/2)
    return float(1 - grayimage[floor(x1), floor(y1)])
end

# imagefile is path of 8bit PNG or JPG
# side is the required image size of sides
function mellanize(imagefile, side;
        linescaler      = 5, # multiply the grey value of a pixel [0,1] to get this width of line
        foregroundcolor = color("black"),
        backgroundcolor = color("antiquewhite2"),
        startradius     = 5,   # starting radius
        margin          = 15,
        awaystep        = 2, # controls how much the radius lengthens for each step,
        chord           = 10, # length of each stroke
        annotation      = false
        )
    tic()
    pageside = side
    global imagewidth = pageside - margin
    outputfilename = splitext(imagefile)[1] * "-mellan-$(side).pdf"
    Drawing(pageside, pageside, outputfilename)
    img1 = imread(imagefile)
    img = Images.imresize(img1, (imagewidth, imagewidth))
    grayimage = convert(Image{Gray}, img)
    origin()
    centerX = centerY = 0
    background(backgroundcolor)
    sethue(foregroundcolor)

    setlinecap("round")
    theta = pi/2  # starting rotation relative to East (anticlockwise +ve x axis)
    radius1 = radius2 = 0
    imw2 = imagewidth/2
    sqrt2 = sqrt(2)
    while radius2 < (imw2 * sqrt2) # while larger radius is less than diagonal distance from center to corner
        radius1 = startradius + (awaystep * theta)
        around1 = mod2pi(-theta)
        theta += chord/radius1
        radius2 = startradius + (awaystep * theta)
        around2 = mod2pi(-theta)
        startpoint = Point(centerX + (cos(around1) * radius1), centerY + (sin(around1) * radius1))
        endpoint   = Point(centerX + (cos(around2) * radius2), centerY + (sin(around2) * radius2))
        save()
            move(startpoint.x, startpoint.y)
            line(endpoint.x, endpoint.y)
            # don't look up point if x/y out of range (eg margins)
            if abs(startpoint.x) <  imw2 &&
               abs(startpoint.y) <  imw2 &&
               abs(endpoint.x)   <  imw2 &&
               abs(endpoint.y)   <  imw2
                    setline(linescaler * getpixel(grayimage, startpoint.x, startpoint.y)) # actually should be average of start and end
            else
                setline(0)
            end
            stroke()
        restore()
    end

    if annotation == true
        # print the used parameter values discreetly
        fontsize(5)
        setopacity(0.2)
        text("linescaler=$linescaler, startradius=$startradius, margin=$margin, awaystep=$awaystep, chord=$chord",
            -pageside/2 + margin , (pageside/2) - 5)
    end
    finish()
    preview()
    return toc()
end

end
