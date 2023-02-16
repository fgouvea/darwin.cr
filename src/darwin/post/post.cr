require "../engine"

module Darwin::Post

    # A `PostProcessor` should implement the `process(engine : Engine(T))` method that receives the whole
    # Darwin engine to do additional processing after a generation has been evaluated and sorted.
    #
    # The post processor is a good place to conduct any analysis of the GA population, such as computing
    # stats (highest/agerage/medium fitness etc.), printing or outputting the results and more.
    #
    # The `Engine`object received has a `Engine#population` property is array of `Genome`, each of which
    # will contain the `Genome#dna` property with the array of genes of that specific individual, as well as
    # the `Genome#property` property with its fitness score.
    #
    # The `population` array received by the `PostProcessor` is sorted by fitness from highest to lowest.
    # As such, the fittest individual can be accessed as:
    # ```
    # fittest = engine.population[0]
    # ```
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    abstract class PostProcessor(T)

        # Executes additional processing after the population of a generation has been evaluated and sorted.
        abstract def process(engine : Engine(T))
    end
end