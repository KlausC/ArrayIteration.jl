using ArrayIteration
using SparseArrays

using Test
using Base.PermutedDimsArrays: PermutedDimsArray

const AI = ArrayIteration
const CCI = AI.ContigCartIterator

include("array_types.jl")  # just for testing

takebuf_string(io::IO) = String(take!(io))

@testset "ArrayIteration" begin
@testset "index" begin

A = zeros(2,3)
@test inds(A, 1) == 1:2
@test inds(A, 2) == 1:3
@test inds(A, 3) == 1:1
@test inds(A) == (1:2, 1:3)
B = ATs.OA(Array{Int}(undef,2,2), (-1,2))
@test inds(B) == (0:1, 3:4)

io = IOBuffer()
show(io, index(A))
@test takebuf_string(io) == "iteration hint over indexes of a "*summary(A)*" over the region (Base.Slice(Base.OneTo(2)), Base.Slice(Base.OneTo(3)))"
io = IOBuffer()
show(io, index(A, :, 2:3))
@test takebuf_string(io) == "iteration hint over indexes of a "*summary(A)*" over the region (Base.Slice(Base.OneTo(2)), 2:3)"
io = IOBuffer()
show(io, stored(A, 1, 2:3))
@test takebuf_string(io) == "iteration hint over stored values of a "*summary(A)*" over the region (1, 2:3)"
io = IOBuffer()
show(io, index(stored(A, 1:2, :)))
@test takebuf_string(io) == "iteration hint over indexes of stored values of a "*summary(A)*" over the region (1:2, Base.Slice(Base.OneTo(3)))"
io = IOBuffer()
show(io, stored(index(A, 1:2, :)))
@test takebuf_string(io) == "iteration hint over indexes of stored values of a "*summary(A)*" over the region (1:2, Base.Slice(Base.OneTo(3)))"

end # testset index

@testset "internal" begin include("internal.jl") end
@testset "dense" begin include("dense.jl") end
@testset "sparse" begin include("sparse.jl") end

end # testset
