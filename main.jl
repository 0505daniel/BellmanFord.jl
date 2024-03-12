using DataStructures

include("graph.jl")
include("algorithm.jl")

struct BellmanFordResult
    distances::Dict{Int64, Float64}
    paths::Dict{Int64, Array{Int64, 1}}
end

function solve_directed_graph(
    graph,
    source::Int64,
    sink::Int64=None,
    listtype::Symbol=:fifo
)
    modifiedBellmanFord(graph, source, listtype)

    return graph.vertices[sink].dist, reconstructPath(graph, sink)
end

function solve_directed_graph(
    graph,
    source::Int64,
    listtype::Symbol=:fifo
)
    modifiedBellmanFord(graph, source, listtype)

    distances = Dict{Int64, Float64}()
    paths = Dict{Int64, Array{Int64, 1}}()

    for vertex in vertices(graph)
        distances[vertex] = vertex.dist
        paths[vertex] = reconstructPath(graph, vertex)
    end

    return BellmanFordResult(distances, paths)
end