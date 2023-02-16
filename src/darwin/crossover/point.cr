require "./crossover"

module Darwin::Crossover

    # A point crossover implementation for `CrossoverOperator`.
    #
    # A point crossover selects a random point in the genome and copies everything before this point from one parent and everything after from the other
    #
    # Ex: combining `AAAAA` and `BBBBB` may result in `AABBB`.
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    class PointCrossover(T) < CrossoverOperator(T)

        # Default constructor.
        #
        # A custom `Random` object can be passed as the `rng` parameter.
        def initialize(@rng : Random = Random.new)
        end
        
        def crossover(genome1 : Array(T), genome2 : Array(T)) : Array(T)
            index = @rng.rand(0...genome2.size)

            genome1[...index] + genome2[index...]
        end
    end
end