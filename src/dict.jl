using Missings

#=
Dictionary
=#

"""
Space complexity: O(n)
"""
mutable struct SimpleDict{K,V} <: AbstractDict{K,V}
    keys::Vector{Union{K, Missing}}
    values::Vector{Union{V, Missing}}
    count::Int

    function SimpleDict{K,V}(; capacity::Integer = 8) where {K,V}
        new{K,V}(missings(K, capacity), missings(V, capacity), 0)
    end
end

#=
Core methods
=#

# TODO collision policy

"""
Time complexity: O(1)
"""
function Base.setindex!(sd::SimpleDict{K,V}, value::V, key::K) where {K,V}
    index = hash_index(key, length(sd.keys))
    filled = !ismissing(sd.keys[index])
    sd.keys[index] = key
    sd.values[index] = value
    if !filled
        sd.count += 1
    end
    return sd
end

# TODO collision policy

"""
Time complexity: O(1)
"""
function Base.getindex(sd::SimpleDict{K,V}, key::K) where {K,V}
    haskey(sd, key) || throw(KeyError(key))
    index = hash_index(key, length(sd.keys))
    return sd.values[index]
end

hash_index(key, capacity::Integer) = ((hash(key) % Int) & (capacity - 1)) + 1

#=
Interface
=#

Base.length(sd::SimpleDict) = sd.count

function Base.haskey(sd::SimpleDict{K,V}, key::K) where {K,V}
    index = hash_index(key, length(sd.keys))
    k = sd.keys[index]
    if !ismissing(k)
        return k == key
    end
    return false
end

function Base.iterate(sd::SimpleDict{K,V}, i::Integer = 1) where {K,V}
    i = findnext(!ismissing, sd.keys, i) # find index of next filled, else return nothing
    if !isnothing(i)
        return (
            Pair{K,V}(sd.keys[i], sd.values[i]),
            i == typemax(Int) ? 0 : i + 1,
        )
    end
    return nothing
end
