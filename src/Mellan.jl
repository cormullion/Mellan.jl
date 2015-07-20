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
    # x and y are between -pageside/2 and pageside/2
    # convert to values between 1 to pageside
    global pageside
    x1 = x + 1 + pageside/2 # off-by-one errors...
    y1 = y + 1 + pageside/2
    # can probably remove this once bugs are out
    try
        return float(1 - grayimage[floor(x1), floor(y1)])
    catch e
        println(e)
        println("$x $y $x1 $y1 $(int(x1)) $(int(y1))")
    end
end

function mellanize(imagefile, side;
        linescaler      = 5, # multiply the grey value of a pixel [0,1] to get this width of line
        foregroundcolor = color("black"),
        backgroundcolor = color("antiquewhite2"),
        startradius     = 5,   # starting radius
        margin          = 20,
        awaystep        = 2, # controls how much the radius lengthens for each step,
        chord           = 10 # length of each stroke
        )
    tic()
    global pageside = side
    outputfilename = splitext(imagefile)[1] * "-mellan-$(side).pdf"
    Drawing(pageside + margin, pageside + margin, outputfilename)
    img1 = imread(imagefile)
    img = Images.imresize(img1, (pageside, pageside))
    grayimage = convert(Image{Gray}, img)
    origin()
    centerX = centerY = 0
    background(backgroundcolor)
    sethue(foregroundcolor)
    setlinecap("round")
    theta = pi/2  # starting rotation relative to East (anticlockwise +ve x axis)
    radius1 = 0
    while radius1 < pageside/2
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
            setline(linescaler * getpixel(grayimage, startpoint.x, startpoint.y))
            stroke()
        restore()
        startpoint = endpoint
    end

    # print the used parameter values discreetly
    fontsize(5)
    setopacity(0.2)
    text("linescaler=$linescaler, startradius=$startradius, margin=$margin, awaystep=$awaystep, chord=$chord",
        -pageside/2 + 10 , (pageside/2) - 5)
    finish()
    preview()
    return toc()
end

end

