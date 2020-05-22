#=
Set
=#

"""
Space complexity: O(n)
"""
struct SimpleSet{T} <: AbstractSet{T}
    d::SimpleDict{T,Nothing}

    function SimpleSet{T}(; capacity::Integer = 8) where {T}
        new{T}(SimpleDict{T,Nothing}(capacity = capacity))
    end
end

#=
Constructors
=#

function SimpleSet{T}(xs::AbstractArray{T}) where T
    ss = SimpleSet{T}()
    for x in xs
        push!(ss, x)
    end
    return ss
end

SimpleSet(xs::AbstractArray{T}) where T = SimpleSet{T}(xs)

#=
Core methods
=#

"""
Time complexity: O(1)
"""
function Base.push!(ss::SimpleSet{T}, item::T) where T
    ss.d[item] = nothing
    return ss
end

"""
Time complexity: O(1)
"""
Base.in(item::T, ss::SimpleSet{T}) where T = haskey(ss.d, item)

"""
Time complexity: O(1)
"""
function Base.delete!(ss::SimpleSet{T}, item::T) where T
    delete!(ss.d, item)
    return ss
end

#=
Interface
=#

Base.length(ss::SimpleSet) = ss.d.count

Base.iterate(ss::SimpleSet, i::Integer = 1) = iterate(ss.d, i)
