#=
Dictionary
=#

using SimpleDataStructures

d = SimpleDict{String,String}()
d["a"] = "1"
haskey(d, "b")
d["b"] = "2"
haskey(d, "b")
d
