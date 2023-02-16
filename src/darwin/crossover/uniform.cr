require "./crossover"

module Darwin::Crossover

    # An uniform crossover implementation for `CrossoverOperator`.
    #
    # Uniform crossover randomly selects each gene from either parent.
    #
    # Ex: combining `AAAAA` and `BBBBB` may result in `ABAAB`.
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    class UniformCrossover(T) < CrossoverOperator(T)

        # Default constructor.
        #
        # A custom `Random` object can be passed as the `rng` parameter.
        def initialize(@rng : Random = Random.new)
        end

        def crossover(genome1 : Array(T), genome2 : Array(T)) : Array(T)
            (0...genome1.size).map do |i|
                if @rng.next_bool 
                    genome1[i] 
                else 
                    genome2[i]
                end
            end
        end
    end
end