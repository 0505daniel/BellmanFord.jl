function reconstructPath(graph::Graph, target::Int)
    path = []
    current = target

    while current != 0
        # if graph.vertices[current].predecessor != 0
        #     # Add the distance from the predecessor to the current vertex
        #     pred = graph.vertices[current].predecessor
        #     edgeIndex = findfirst(e -> e.to == current, graph.vertices[pred].edges)
        #     edge = graph.vertices[pred].edges[edgeIndex]
        # end
        pushfirst!(path, current)
        current = graph.vertices[current].predecessor
    end
    return path
end

function modifiedBellmanFord(graph::Graph, source::Int, listType::Symbol=:fifo)
    # for vertex in graph.vertices
    #     vertex.dist = Inf
    #     vertex.predecessor = 0
    #     vertex.edgeCount = 0
    # end
    graph.vertices[source].dist = 0
    # graph.vertices[source].edgeCount = 0

    list = (listType == :fifo) ? Queue{Int}() : Deque{Int}()
    if listType != :fifo
        pushfirst!(list, source)
    else
        enqueue!(list, source)
    end

    while !isempty(list)
        if listType == :fifo
            i = dequeue!(list)
        else
            i = popfirst!(list)
        end
        for edge in graph.vertices[i].edges
            if graph.vertices[i].dist + edge.weight < graph.vertices[edge.to].dist
                graph.vertices[edge.to].dist = graph.vertices[i].dist + edge.weight
                graph.vertices[edge.to].predecessor = i
                graph.vertices[edge.to].edgeCount = graph.vertices[i].edgeCount + 1

                #TODO: Check if this approach is right
                # In the original paper for the Bellman-Ford algorithm it was proven that in a directed weighted graph with no negative cycles, the shortest path has length at most |V|-1 edges.
                # See https://en.wikipedia.org/wiki/Bellman%E2%80%93Ford_algorithm
                if graph.vertices[edge.to].edgeCount >= length(graph.vertices)
                    cycle = [(i, edge.to)]
                    current = graph.vertices[edge.to].predecessor
                    while current != edge.to
                        pushfirst!(cycle, (graph.vertices[current].predecessor, current))
                        current = graph.vertices[current].predecessor
                    end
                    throw(ErrorException("Graph contains a negative cycle: $cycle"))
                end

                #TODO: Check if this heuristic approach is right
                # Small Label First (SLF) technique. Instead of always pushing vertex v to the end of the queue, compare d(v) to d(front(Q)), and insert v to the front of the queue if d(v) is smaller
                # See https://en.wikipedia.org/wiki/Shortest_path_faster_algorithm
                if listType != :fifo
                    if !isempty(list) && graph.vertices[edge.to].dist < graph.vertices[first(list)].dist
                        pushfirst!(list, edge.to)
                    else
                        push!(list, edge.to)
                    end
                else
                    enqueue!(list, edge.to)
                end
            end
        end
    end
end