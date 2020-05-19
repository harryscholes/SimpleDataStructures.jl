#=
Queue
=#

using SimpleDataStructures

sq = SimpleQueue{Int}()

enqueue!(sq, 1)
enqueue!(sq, 2)
dequeue!(sq)
enqueue!(sq, 3)
enqueue!(sq, 4)
dequeue!(sq)
dequeue!(sq)
dequeue!(sq)
dequeue!(sq)
