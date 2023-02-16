require "../genome"

module Darwin::Selection

    # The selection operator is responsible for, given population of genomes, choosing two parents to be combined into the next generation.
    #
    # Ideally, the selector should take into account the `fitness` score of each genome when determining
    # the probability of a genome being selected as a parent. This is important because theoretically the
    # genomes with high fitness have better features for the solution of the problem than the ones with
    # lower fitness, so it is better to maximize the chance of those features being carried to the next
    # generation.
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    abstract class SelectionOperator(T)

        # Receives an array of `Genome` and returns a tuple with two genomes chosen to act as parents in the GA.
        abstract def select_mates(genomes : Array(Darwin::Genome(T))) : Tuple(Darwin::Genome(T), Darwin::Genome(T))
    end
end