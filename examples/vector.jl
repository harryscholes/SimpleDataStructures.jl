#=
Vector
=#

using SimpleDataStructures

sv = SimpleVector{Int}()
dump(sv)
for i = 1:4
    push!(sv, i)
    @show sv.size, sv.capacity
end
sv
sv[1] = 10
resize!(sv, 3)
dump(sv)

SimpleVector([1, 2, 3])

sv = SimpleVector{Int}()
sizehint!(sv, 100)
for i = 1:100
    push!(sv, i)
    @show sv.size, sv.capacity
end

sv = SimpleVector{Int}()
push!(sv, 2.)
push!(sv, "hello")

sv = SimpleVector{Complex{Float64}}()
push!(sv, complex(7, 3))
push!(sv, 1//2)
push!(sv, π)

SimpleVector(1, 2, 3, 4)

x = SimpleVector(1:10...)
insert!(x, 3, 100)
deleteat!(x, 3)
