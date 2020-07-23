# just visual tests!

using Mellan, Luxor

function alltests()
    mellanize(dirname(@__FILE__) * "/mona.png",
        800,
        lineweight      = 5,
        output          = "mona-mellan-800.pdf",
        foregroundcolor = "gray30",
        backgroundcolor = "antiquewhite2",
        startradius     = 5,
        margin          = 10,
        tightness       = 1,
        chord           = 4)

    mellanize(dirname(@__FILE__) * "/mona.png",
        500,
        lineweight      = 5,
        output          = "mona-mellan-500.pdf",
        foregroundcolor = "gray20",
        backgroundcolor = "antiquewhite2",
        startradius     = 3,
        margin          = 10,
        tightness       = 0.8,
        chord           = 3)

    mellanize(dirname(@__FILE__) * "/mona.png",
        500,
        lineweight      = 3,
        output          = "mona-mellan.svg",
        minlineweight   = 0.1,
        foregroundcolor =  "grey5",
        backgroundcolor =  "gold",
        startradius     = 5,
        margin          = 0,
        tightness       = 0.5,
        chord           = 3,
        annotation      = true)
end

if get(ENV, "MELLAN_KEEP_TEST_RESULTS", false) == "true"
        # they changed mktempdir in v1.3
        if VERSION <= v"1.2"
            cd(mktempdir())
        else
            cd(mktempdir(cleanup=false))
        end
        @info("...Keeping the Mellan test output in: $(pwd())")
        alltests()
        @info("Mellan test images were saved in: $(pwd())")
else
    mktempdir() do tmpdir
        cd(tmpdir) do
            @info("running Mellan tests in: $(pwd())")
            @info("but not keeping the results")
            @info("because you didn't do: ENV[\"MELLAN_KEEP_TEST_RESULTS\"] = \"true\"")
            alltests()
            @info("Test images weren't saved. To see the test images, next time do this before running:")
            @info(" ENV[\"MELLAN_KEEP_TEST_RESULTS\"] = \"true\"")
        end
    end
end
