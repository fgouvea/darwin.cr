module Darwin::Mutation

    # The mutation operator is responsible for altering a genome before it is added to the next generation.
    #
    # This is extremely important for the GA to add diversity to the population and making sure that it doesn't get stuck
    # in a local maximum because a relevant gene doesn't exist in the population. For exmple, if the genome ABCDE is the optimal
    # solution for the problem at hand, but no genome in the population contains the gene C as the third gene, then no amount
    # of selection and crossovers would ever yield the optimal solution without a mutation to generate that feature in the population.
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    abstract class MutationOperator(T)

        # Receives the array of genes and returns a new one after mutation.
        abstract def mutate(genome : Array(T)) : Array(T)
    end
end