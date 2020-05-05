
# Space complexity: O(n)
mutable struct SimpleDict{K,V} <: AbstractDict{K,V}
    keys::Vector{K}
    values::Vector{V}
    filled::BitArray
    count::Int

    function SimpleDict{K,V}(; capacity::Integer = 8) where {K,V}
        new{K,V}(
            Vector{K}(undef, capacity),
            Vector{V}(undef, capacity),
            falses(capacity),
            0,
        )
    end
end




#=
Getting and setting
=#

# Time complexity: O(1)
hash_index(key, capacity::Integer) = ((hash(key) % Int) & (capacity - 1)) + 1

# Time complexity: O(1)
# TODO collision policy
function Base.setindex!(sd::SimpleDict{K,V}, value::V, key::K) where {K,V}
    index = hash_index(key, length(sd.keys))
    sd.keys[index] = key
    sd.values[index] = value
    if !sd.filled[index]
        sd.filled[index] = true
        sd.count += 1
    end
    return sd
end

# Time complexity: O(1)
# TODO collision policy
function Base.getindex(sd::SimpleDict{K,V}, key::K) where {K,V}
    haskey(sd, key) || throw(KeyError(key))
    index = hash_index(key, length(sd.keys))
    return sd.values[index]
end

# Time complexity: O(n)
# function rehash!(sd::SimpleDict{K,V}, newsz::Integer) where {K,V}
#     old_keys = sd.keys
#     old_values = sd.values
#     old_filled = sd.filled
#     sz = length(old_keys)
#
#     keys = Vector{K}(undef, newsz)
#     values = Vector{V}(undef, newsz)
#     filled = zeros(UInt8, newsz)
#     count = 0
#
#     for i in 1:sz
#         if old_filled[i]
#             key = old_keys[i]
#             value = old_values[i]
#             index = hash_index(key, newsz)
#             keys[index] = key
#             values[index] = value
#             filled[index] = true
#             count += 1
#         end
#     end
#
#     sd.keys = keys
#     sd.values = values
#     sd.filled = filled
#     sd.count = count
#
#     return sd
# end

#=
Interface methods
=#

Base.length(sd::SimpleDict) = sd.count

function Base.haskey(sd::SimpleDict{K,V}, key::K) where {K,V}
    index = hash_index(key, length(sd.keys))
    return sd.filled[index] && sd.keys[index] == key
end

function Base.iterate(sd::SimpleDict{K,V}, i::Integer = 1) where {K,V}
    i = findnext(sd.filled, i) # find index of next filled, else return nothing
    if isnothing(i)
        return nothing
    else
        return (
            Pair{K,V}(sd.keys[i], sd.values[i]),
            i == typemax(Int) ? 0 : i + 1,
        )
    end
end

#=
# Examples
d = SimpleDict{String,String}()
d["a"] = "1"
haskey(d, "b")
d["b"] = "2"
d
=#

#=
Dictionaries with default values
=#

# Space complexity: O(n)
struct SimpleDefaultDict{K,V} <: AbstractDict{K,V}
    d::SimpleDict{K,V}
    default::V

    function SimpleDefaultDict{K,V}(default::V; kwargs...) where {K,V}
        new{K,V}(SimpleDict{K,V}(; kwargs...), default)
    end
end

# Time complexity: O(1)
function Base.getindex(sdd::SimpleDefaultDict{K,V}, key::K) where {K,V}
    return haskey(sdd, key) ? getindex(sdd.d, key) : sdd.default
end

# Time complexity: O(1)
function Base.setindex!(sdd::SimpleDefaultDict{K,V}, value::V, key::K) where {K,V}
    setindex!(sdd.d, value, key)
    return sdd
end

#=
Interface methods
=#

Base.length(sdd::SimpleDefaultDict) = sdd.d.count

Base.haskey(sdd::SimpleDefaultDict{K,V}, key::K) where {K,V} = haskey(sdd.d, key)

Base.iterate(sdd::SimpleDefaultDict, i::Integer = 1) = iterate(sdd.d, i)

#=
# Examples
str = "hello hello hello bye"
words = string.(split(str))
sdd = SimpleDefaultDict{String,Int}(0; capacity = 100)

for word in words
    sdd[word] += 1
end

sdd
#=
