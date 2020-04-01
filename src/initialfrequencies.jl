#=
This function creates the initial cline with two allelic frequencies at each
extreme.
=#
function initialfreqs(totaldemes, left_frequency, right_frequency)
    # Make sure allelic frequencies are between 0 and 1
    if left_frequency ∉ (0:0.01:1) || right_frequency ∉ (0:0.01:1)
        throw("Allelic frequencies must be between 0 and 1")
    end

    if left_frequency == right_frequency
        throw("Allelic frequencies must be different")
    end

    if isodd(totaldemes) || totaldemes <= 0
        throw("Total number of demes must be even and positive")
    end

    left = fill(left_frequency, (1, Int(totaldemes/2)))
    right =  fill(right_frequency, (1, Int(totaldemes/2)))

    return(hcat(left, right))
end
