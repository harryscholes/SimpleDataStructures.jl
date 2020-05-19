#=
Dictionary with default values
=#

"""
Space complexity: O(n)
"""
struct SimpleDefaultDict{K,V} <: AbstractDict{K,V}
    d::SimpleDict{K,V}
    default::V

    function SimpleDefaultDict{K,V}(default::V; kwargs...) where {K,V}
        new{K,V}(SimpleDict{K,V}(; kwargs...), default)
    end
end

#=
Core methods
=#

"""
Time complexity: O(1)
"""
function Base.getindex(sdd::SimpleDefaultDict{K,V}, key::K) where {K,V}
    return haskey(sdd, key) ? getindex(sdd.d, key) : sdd.default
end

"""
Time complexity: O(1)
"""
function Base.setindex!(sdd::SimpleDefaultDict{K,V}, value::V, key::K) where {K,V}
    setindex!(sdd.d, value, key)
    return sdd
end

#=
Interface
=#

Base.length(sdd::SimpleDefaultDict) = sdd.d.count

Base.haskey(sdd::SimpleDefaultDict{K,V}, key::K) where {K,V} = haskey(sdd.d, key)

Base.iterate(sdd::SimpleDefaultDict, i::Integer = 1) = iterate(sdd.d, i)
