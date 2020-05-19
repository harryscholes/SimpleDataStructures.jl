#=
Dictionary with default values
=#

using SimpleDataStructures

str = "hello hello hello bye"
words = string.(split(str))
sdd = SimpleDefaultDict{String,Int}(0; capacity = 100)

for word in words
    sdd[word] += 1
end

sdd
