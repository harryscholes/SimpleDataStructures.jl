#=
Stack
=#

using SimpleDataStructures

ss = SimpleStack{Int}()

push!(ss, 1)
push!(ss, 2)
push!(ss, 3)
pop!(ss)
pop!(ss)
pop!(ss)
pop!(ss)
