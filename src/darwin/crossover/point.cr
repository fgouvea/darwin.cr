require "./crossover"

module Darwin::Crossover
    class PointCrossover(T) < CrossoverOperator(T)
        def initialize(@rng : Random = Random.new)
        end

        def crossover(genome1 : Array(T), genome2 : Array(T)) : Array(T)
            index = @rng.rand(0...genome2.size)

            genome1[...index] + genome2[index...]
        end
    end
end