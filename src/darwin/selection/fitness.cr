require "./selection"
require "../genome"

module Darwin::Selection
    
    # A basic implementation of the `SelectionOperator` in which the probability of a genome being selected
    # is its fitness in relation to the total fitness of the population (fitness / total_fitness)
    #
    # Ex:
    # ```markdown
    # | Genome | Fitness | Probability |   Calculation    |
    # |--------|---------|-------------|------------------|
    # |   A    |   1.0   |     17%     | 1.0 / 6.0 = 0.17 |
    # |   B    |   3.0   |     50%     | 3.0 / 6.0 = 0.5  |
    # |   C    |   2.0   |     33%     | 2.0 / 6.0 = 0.33 |
    # ```
    #
    # The generic `T` type refers to the type of a gene in the implementation.
    class FitnessSelector(T) < SelectionOperator(T)
        
        # Default constructor.
        #
        # A custom `Random` object can be passed as the `rng` parameter.
        def initialize(@rng : Random = Random.new)
        end

        def select_mates(genomes : Array(Darwin::Genome(T))) : Tuple(Darwin::Genome(T), Darwin::Genome(T))
            total_fitness = 0.0
            genomes.each {|genome| total_fitness += genome.fitness}

            selected_genomes = (0...2).map do 
                random = total_fitness * @rng.rand #Result will be a Float64 from 0 to total_fitness
                
                # Subtract fitness from random until we fall in a genomes fitness range
                idx = 0
                (0...genomes.size).each do |i|
                    idx = i
                    break if random < genomes[i].fitness
                    random -= genomes[i].fitness
                end

                genomes[idx]
            end

            {selected_genomes[0], selected_genomes[1]}
        end
    end
end