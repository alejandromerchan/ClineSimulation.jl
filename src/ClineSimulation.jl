module ClineSimulation

export binomial_migration,
       migration,
       correction,
       initialfreqs

using Distributions: Binomial,  pdf

include("migration.jl")
include("initialfrequencies.jl")

end # module
