using Mellan, Luxor

function alltests()
    mellanize(dirname(@__FILE__) * "/obama.jpg",
        800,
        linescaler      = 5,
        outfilename     = "thanks-obama-mellan-800.pdf",
        foregroundcolor = "gray30",
        backgroundcolor = "antiquewhite2",
        startradius     = 5,
        margin          = 10,
        awaystep        = 1,
        chord           = 4)

    mellanize(dirname(@__FILE__) * "/steve-jobs.jpg",
        800,
        outfilename     = "think-different-mellan-800.pdf",
        linescaler      = 4,
        foregroundcolor = "gray25",
        backgroundcolor = "antiquewhite3",
        startradius     = 5,
        margin          = 20,
        awaystep        = 0.75,
        chord           = 3,
        annotation      = true
        )

    mellanize(dirname(@__FILE__) * "/obama.jpg",
        400,
        linescaler      = 5,
        outfilename     = "thanks-obama-mellan-400.pdf",
        foregroundcolor = "gray20",
        backgroundcolor = "antiquewhite2",
        startradius     = 3,
        margin          = 10,
        awaystep        = 0.8,
        chord           = 3)

    mellanize(dirname(@__FILE__) * "/steve-jobs.jpg",
        400,
        linescaler      = 4,
        outfilename     = "think-different-mellan-400.pdf",
        minlinethickness = 0.2,
        foregroundcolor =  "gray20",
        backgroundcolor =  "antiquewhite3",
        startradius     = 5,
        margin          = 20,
        awaystep        = 0.5,
        chord           = 3,
        annotation      = true
        )
end

if get(ENV, "MELLAN_KEEP_TEST_RESULTS", false) == "true"
        cd(mktempdir())
        info("...Keeping the results")
        alltests()
        info("Test images saved in: $(pwd())")
else
    mktempdir() do tmpdir
        cd(tmpdir)
        info("running tests in: $(pwd())")
        info("but not keeping the results")
        alltests()
        info("Test images not saved. To see the images, next time do this before running")
        info(" ENV[\"MELLAN_KEEP_TEST_RESULTS\"] = \"true\"")
    end
end
