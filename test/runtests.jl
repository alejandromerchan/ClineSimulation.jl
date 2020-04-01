using ClineSimulation
using Test

# Tests for the initialfreqs function
@testset "initial frequencies function" begin
    @test_throws "Total number of demes must be even and positive" initialfreqs(-1, 0, 1)
    @test_throws "Total number of demes must be even and positive" initialfreqs(0, 0, 1)
    @test_throws "Total number of demes must be even and positive" initialfreqs(1, 0, 1)
    @test_throws "Allelic frequencies must be different" initialfreqs(2, 0, 0)
    @test_throws "Allelic frequencies must be different" initialfreqs(2, 0.51, 0.51)
    @test_throws "Allelic frequencies must be different" initialfreqs(2, 1, 1)
    @test_throws "Allelic frequencies must be between 0 and 1" initialfreqs(2, 0, 1.1)
    @test_throws "Allelic frequencies must be between 0 and 1" initialfreqs(2, -0.1, 1)
    @test initialfreqs(4, 0, 1) == [0 0 1 1]
    @test initialfreqs(2, 0.51, 0.52) == [0.51 0.52]
    @test length(initialfreqs(100, 0, 1)) == 100
end
