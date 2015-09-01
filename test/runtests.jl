using Mellan
using Base.Test

result = mellanize("obama.jpg",
    800,
    linescaler      = 5,
    foregroundcolor = "gray30",
    backgroundcolor = "antiquewhite2",
    startradius     = 5,
    margin          = 10,
    awaystep        = 1,
    chord           = 4)

@test 0.1 < result < 15 # tests whether process took a reasonable amount of time...

result = mellanize("steve-jobs.jpg",
    800,
    linescaler=4,
    foregroundcolor = "gray25",
    backgroundcolor = "antiquewhite3",
    startradius=5,
    margin=20,
    awaystep=0.75,
    chord=3,
    annotation=true
    )

@test 0.1 < result < 15

result = mellanize("obama.jpg",
    400,
    linescaler      = 5,
    foregroundcolor = "gray20",
    backgroundcolor = "antiquewhite2",
    startradius     = 3,
    margin          = 10,
    awaystep        = 0.8,
    chord           = 3)

@test 0.1 < result < 15

result = mellanize("steve-jobs.jpg",
    400,
    linescaler=4,
    foregroundcolor = "gray20",
    backgroundcolor = "antiquewhite3",
    startradius=5,
    margin=20,
    awaystep=0.5,
    chord=3,
    annotation=true
    )

@test 0.1 < result < 15 # took too long! ;)

exit()
