module ClineSimulation

export binomial_migration,
       migration,
       correction

using Distributions: Binomial,  pdf

include("migration.jl")

end # module
