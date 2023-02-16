require "./config"
require "./crossover"
require "./crossover/point"
require "./evaluation"
require "./genome"
require "./mutation"
require "./mutation/simple"
require "./post"
require "./selection"
require "./selection/fitness"

module Darwin

    # The main class that runs the GA.
    # Shuold be initialized with at minimum a `Darwin::Config` object and a `Darwin::Evaluator` implementation.
    # The generic `T` type refers to the type of a gene in the implementation.
    class Engine(T)
        include Darwin
        include Alphabet
        include Crossover
        include Evaluation
        include Mutation
        include Selection
        include Post

        # 10% mutation rate used by default in the `Darwin::Mutation::SimlpeMutator` if no other `Darwin::Mutation::Mutator` is provided at initialization.
        # If you wish to use a different mutation rate, simply instantiate another `SimpleMuatator` when initializing the engine object:
        # ```
        # my_mutator = Darwin::Mutation::SimpleMutator.new(alphabet: my_config.alphabet, probability: 0.05) # 5% probability of mutation for each gene
        # engine = Darwin::Engine.new(config: my_config, evaluator: my_evaluator, mutator: my_mutator)
        # ```
        @@DEFAULT_MUTATION_RATE = 0.1

        # Post processor that will be run after each generation has been evaluated.
        #
        # The post processor must extend the `Darwin::PostProcessor` class and implement the `process(engine `Darwin::Engine`)` method, which receives the engine to do any relevant post processing, such as calculating stats, outputting the fittest individuals etc.
        @post : PostProcessor(T)?
        @population : Array(Genome(T))

        # Tracks if the current `@population` has already been evaluated. For internal use only.
        @population_evaluated = false

        # Number of the generation currently in the `population` property.
        # Starts at 1 and is incremented each time a new population is generated.
        @generation = 1

        # The current population of the GA, sorted by fitness from highest to lowest.
        #
        # Each `Darwin::Genome(T)` object contains the DNA (array of genes) and the fitness calculated for that individual.
        # After evaluating a population, the engine will sort the population by fitness, from highest to lowest, so the fittest individuals are always at the beginning of the array.
        getter population

        # Number of the generation currently in the `population` property.
        # Starts at 1 and is incremented each time a new population is generated.
        getter generation

        # Custructor that initializes the engine object with at minimum a config object and a evaluator implementation, but can receive custom GA operators as optional parameters.
        # 
        # Different implementations of the GA operators can be passed in the `crossover`, `mutation` and `selection` named parameters, as well as a post processor as `post`.
        #
        # Ex:
        # ```
        # my_alphabet = Darwin::Alphabet::StringAlphabet("qwerty")
        # engine = Darwin::Engine.new(
        #     config: Darwin::Config.new(alphabet: my_alphabet, genome_length: 10, population_size: 50),
        #     evaluation: MyCustomEvaluator.new,
        #     crossover: Darwin::Crossover:UniformCrossover.new,
        #     mutation: Darwin::Mutation::SimpleMutator(my_alphabet, probability: 0.01),
        #     selection: MyCustomSelector.new,
        #     post: MyPostProcessor.new 
        # )
        # ```
        def initialize(@config : Config(T),
            @evaluation : Evaluator(T),
            @crossover : CrossoverOperator(T) = PointCrossover(T).new,
            @mutation : MutationOperator(T) = SimpleMutator.new(config.alphabet, @@DEFAULT_MUTATION_RATE),
            @selection : SelectionOperator(T) = FitnessSelector(T).new,
            @post : PostProcessor(T) | Nil = nil)

            @genome_factory = GenomeFactory(T).new(@config)

            @population = (0...@config.population_size).map { @genome_factory.random }
        end

        # Runs N generations of the GA.
        #
        # `engine.run` will run 1 generation, but can run multiple (e.g. 10) using the `generations` parameter as in `engine.run(10)` or `engine.run(generations: 10)`.
        # 
        # The resulting population after `run()` will already have been evaluated and sorted.
        # 
        # This method evaluates the current population first if it hasn't yet been evaluated, either because it is the initial population or because you have been using the `generate_new_population()` method (not recommended).
        def run(generations = 1)
            generations.times do
                
                self.evaluate_population() unless @population_evaluated

                self.generate_new_population()

                self.evaluate_population()
            end
        end

        # Runs the evaluator for every member of the population and then sorts it by fitness from highest to lowest.
        def evaluate_population()
            @population.each do |genome|
                fitness = @evaluation.evaluate(genome.dna)
                genome.fitness = fitness
            end

            @population_evaluated = true
            @population.sort_by! {|genome| -genome.fitness} # Sorts from highest fitness to lowest
            
            p = @post
            p.process(self) if p
        end

        # Generates a new population from the current one (highly discouraged, prioritize using `run()` instead).
        #
        # Generates a new population from the current one by running the `selection` operator to choose two parents,
        # then the `crossover` operator to combine those two parents in a new genome, then the `mutation` operator to alter the resulting genome.
        # 
        # This method expects the current population to already be evaluated.
        # 
        # It is intended mostly for internal usage within the engine and its usage is highly discouraged, unless you have very specific needs. Use`run()` instead.
        def generate_new_population()
            new_population = (0...@config.population_size).map do
                parent1, parent2 = @selection.select_mates(@population)

                offspring_dna = @crossover.crossover(parent1.dna, parent2.dna)

                Genome.new @mutation.mutate(offspring_dna)
            end

            # Carry over best N individuals based on the elitism parameter
            @config.elitism.times do |i|
                new_population[i] = @population[i]
                new_population[i].fitness = 0.0
            end

            @population = new_population

            @generation += 1

            @population_evaluated = false
        end

    end
end