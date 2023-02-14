require "./config"
require "./genome"
require "./crossover"
require "./crossover/point"
require "./mutation"
require "./mutation/simple"
require "./selection"
require "./selection/fitness"
require "./post"

class Darwin(T)
    @@DEFAULT_MUTATION_RATE = 0.1

    @post : PostProcessor(T)?
    @population : Array(Genome(T))
    @population_evaluated = false
    @generation = 1

    getter population
    getter generation

    def initialize(@config : GAConfig(T),
        @evaluation : Evaluator(T),
        @crossover : CrossoverOperator(T) = PointCrossover(T).new,
        @mutation : MutationOperator(T) = SimpleMutator.new(config.alphabet, @@DEFAULT_MUTATION_RATE),
        @selection : SelectionOperator(T) = FitnessSelector(T).new,
        @post : PostProcessor(T) | Nil = nil)

        @genome_factory = GenomeFactory(T).new(@config)

        @population = (0...@config.population_size).map { @genome_factory.random }
    end

    def run(generations = 1)
        generations.times do
            
            self.evaluate_population() unless @population_evaluated

            self.generate_new_population()

            self.evaluate_population()
        end
    end

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