module Darwin::Crossover

    # The crossover operator is responsible for combining two parent genomes to generate a new genome that will be carried over the next population.
    #
    # The idea behind the crossover is that if the genes represent different features of a solution to the problem being optimized,
    # then combining features of two different solutions could yield a better solution, by selecting the "good parts" of each solution.
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    abstract class CrossoverOperator(T)

        # Generates a new genome from the two parent genomes received.
        abstract def crossover(genome1 : Array(T), genome2 : Array(T)) : Array(T)
    end
end