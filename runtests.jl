#using BellmanFord
using Test, Statistics
include("main.jl")


@testset verbose = true "modifiedBellmanFord tests" begin
    
    @testset verbose = true "negative cycle detection" begin
        # Create a graph with a known negative cycle
        vertices = [Vertex(i, [], Inf, 0, 0) for i in 1:3]
        addEdge!(vertices[1], 2, 1)
        addEdge!(vertices[2], 3, 1)
        addEdge!(vertices[3], 1, -3)
        graph = Graph(vertices)

        @test_throws Exception modifiedBellmanFord(graph, 1)
    end

    @testset verbose = true "fifo and deque results comparison" begin
        n = 10000
        successful_tests = 0
        total_time_fifo = 0
        total_time_deque = 0

        while successful_tests < 10
            graph = generateConnectedGraph(n; density=:dense, NEGATIVE_WEIGHT=true)
            @show graph

            try
                time_fifo = @elapsed result_fifo_dist, result_fifo_path = solve_directed_graph(graph, 1, n, :fifo)
                time_deque = @elapsed result_deque_dist, result_deque_path = solve_directed_graph(graph, 1, n, :deque)
                # @show result_fifo_dist, result_fifo_path
                # @show result_deque_dist, result_deque_path
    
                @test isapprox(result_fifo_dist, result_deque_dist)
                @test result_fifo_path == result_deque_path

                successful_tests += 1
                total_time_fifo += time_fifo
                total_time_deque += time_deque

            catch e
                if isa(e, ErrorException)
                    @info "Skipping iteration due to negative cycle"
                    @show e
                    continue
                else
                    rethrow(e)
                end
            end
        end

        avg_time_fifo = total_time_fifo / successful_tests
        avg_time_deque = total_time_deque / successful_tests
        print("Average time for fifo: ", avg_time_fifo, " seconds\n")
        print("Average time for deque: ", avg_time_deque, " seconds\n")

    end
end