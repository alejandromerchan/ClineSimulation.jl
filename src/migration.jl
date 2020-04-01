#= 
Binomial migration model from Mallet & Barton 1989
max_migration: the maximum number of demes that get migration from the source (n in Mallet & Barton 1989)
migration_distance: distance (in demes) between the source and the receiving deme (i in MAllet & BArton 1989)
α is a coefficient that control for symmetry in the migration (both sides of demes)
α = 0.5 is the default and ensures symmetric migration
The function produces the probability of migration that a deme receives from
itself (migration_distance = 0, offspring does not migrate), and neighboring demes (-migration_distance to +migration_distance)
The sum of binomial_migration(-migration_distance to +migration_distance) should = 1.
The larger max_migration is, the lowest binomial_migration with the same migration_distance
=#
function binomial_migration(max_migration, migration_distance, α = 0.5)
    # Binomial distribution with n = 2 * max_migration and p = α
    prob = Binomial(2 * max_migration, α)
    # Distance of the binomial migration a deme located at migration_distance demes from the source deme.
    # Values larger than max_migration get evaluated at 0.0
    dist = max_migration - migration_distance
    return(pdf(prob, dist))
end

function migration(migration_distance, cline)
    # Object to catch results
    migration_matrix = zeros(length(cline), length(cline))

    # Produces the matrix with the initial structure for migration
    for i in 1:length(cline)               # row
        for j in 1:length(cline)           # column
            if -migration_distance <= (i - j) <= migration_distance
                migration_matrix[i, j] = binomial_migration(migration_distance, i-j)
            end
        end
    end

    next_generation = (cline * migration_matrix) + correction(migration_distance, cline)

    return(next_generation)
end

function correction(migration_distance, cline)
    #= 
    Correct for borders (imaginary demes beyond the studied ones that contribute to
    migration)
    =#
    correction = zeros(1, length(cline))
    correction_right = map(sum, correction_vector(migration_distance, cline) * last(cline))
    for i = 1:migration_distance
        correction[i] = correction_right[i]
    end
    correction = reverse(correction; dims = 2)
    correction_left = map(sum, correction_vector(migration_distance, cline) * first(cline))
    for i = 1:migration_distance
        correction[i] = correction_left[i]
    end
    return(correction)
end

function correction_vector(migration_distance, cline)
    correction_vec = fill(Float64[], 1, migration_distance)
    n = length(cline)
    deme_vec = []

    for i in reverse(1:migration_distance)
        deme_vec = push!(deme_vec, binomial_migration(migration_distance, i))    
        correction_vec[i] = deme_vec
    end
    return(correction_vec)
end