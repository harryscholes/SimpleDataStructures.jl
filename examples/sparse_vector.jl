#=
Sparse vector
=#

using SimpleDataStructures

ssv = SimpleSparseVector(
    100,
    [1, 10, 50],
    rand(3),
)

ssv[1]
ssv[10]

ssv[2]

ssv[101]

ssv[3] = rand()

insert!(
    ssv,
    10,
    rand(),
)

deleteat!(ssv, 20)
deleteat!(ssv, 3)

ssv = SimpleSparseVector{Float64}(100)
ssv[50] = rand()
