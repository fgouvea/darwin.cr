require "./crossover"

module Darwin::Crossover

    # A stub `CrossoverOperator` intended for testing.
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    class StubCrossover(T) < CrossoverOperator(T)
        
        # All the calls received by the stub, with each element being a tuple of the parents received in the call.
        property calls = [] of Tuple(Array(T), Array(T))

        # Constructor that receives an array of results the stub will return.
        #
        # If the array runs out, the stub will simply return the first parent received.
        def initialize(@crossover_results = [] of Array(T))
        end

        def crossover(genome1 : Array(T), genome2 : Array(T)) : Array(T)
            @calls.push ({genome1, genome2})

            if @crossover_results.size > 0
                @crossover_results.shift
            else
                genome1
            end
        end
    end
end