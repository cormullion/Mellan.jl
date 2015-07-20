#!/Applications/Julia-0.3.10.app/Contents/Resources/julia/bin/julia

using Mellan
using Base.Test

result = mellanize("obama.jpg",
    800,
    linescaler      = 5,
    foregroundcolor = Color.color("gray30"),
    backgroundcolor = Color.color("antiquewhite2"),
    startradius     = 5,
    margin          = 10,
    awaystep        = 1,
    chord           = 4)

@test 0.1 < result < 10 # tests whether process took a reasonable amount of time...

result = mellanize("steve-jobs.jpg",
    800,
    linescaler=4,
    foregroundcolor = Color.color("gray25"),
    backgroundcolor = Color.color("antiquewhite3"),
    startradius=5,
    margin=20,
    awaystep=0.75,
    chord=3
    )

@test 0.1 < result < 10

result = mellanize("obama.jpg",
    400,
    linescaler      = 5,
    foregroundcolor = Color.color("gray20"),
    backgroundcolor = Color.color("antiquewhite2"),
    startradius     = 3,
    margin          = 10,
    awaystep        = 0.8,
    chord           = 3)

@test 0.1 < result < 10

result = mellanize("steve-jobs.jpg",
    400,
    linescaler=4,
    foregroundcolor = Color.color("gray20"),
    backgroundcolor = Color.color("antiquewhite3"),
    startradius=5,
    margin=20,
    awaystep=0.5,
    chord=3
    )

@test 0.1 < result < 10

exit()
