require "./crossover"

module Darwin::Crossover
    class StubCrossover(T) < CrossoverOperator(T)
        property calls = [] of Tuple(Array(T), Array(T))

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