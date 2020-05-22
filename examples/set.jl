#=
Set
=#

using SimpleDataStructures

ss = SimpleSet{Int}()
push!(ss, 1)
1 in ss
2 in ss
push!(ss, 2)
2 in ss

delete!(ss, 1)
delete!(ss, 2)

SimpleSet([1,2,3,1,2,3])
