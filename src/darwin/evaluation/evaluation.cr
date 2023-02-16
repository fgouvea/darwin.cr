module Darwin::Evaluation

    # An `Evaluator` determine a genome's fitness score.
    #
    # This is the main class to be implemented before using `Darwin`, as this implementation is what optimizes the GA towards the solution of the problem.
    abstract class Evaluator(T)

        # Receives a genome's DNA (an array of genes) and returns its fitness score.
        #
        # The fitness score should always be positive.
        abstract def evaluate(dna : Array(T)) : Float64
    end
end