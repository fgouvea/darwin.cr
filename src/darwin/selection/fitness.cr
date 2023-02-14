require "./selection"
require "../genome"

module Darwin::Selection
    
    class FitnessSelector(T) < SelectionOperator(T)
        
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