require "./spec_helper"

describe Darwin do
    describe "#initialize" do
        it "should generate random population of the size specified in the config" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3)

            engine = Darwin.new(config: config, evaluation: StubEvaluator(Int32).new())

            expected_dnas = [[1, 2, 3],
                            [4, 5, 6],
                            [7, 8, 9]]

            engine.population.size.should eq 3

            (0...3).each do |i|
                engine.population[i].dna.should eq expected_dnas[i]
            end
        end

        it "shouldn't eval population on new" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3)

            engine = Darwin.new(config: config, evaluation: StubEvaluator(Int32).new())

            engine.population.each do |genome|
                genome.fitness.should eq 0.0
            end
        end
    end

    describe "#evaluate_population" do
        it "should call evaluator for every individual on the population" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3)
            evaluator = StubEvaluator(Int32).new(default_evaluation: 80.0)
            engine = Darwin.new(config: config, evaluation: evaluator)

            engine.evaluate_population()

            evaluator.calls.size.should eq 3

            engine.population.each do |genome|
                genome.fitness.should eq 80.0
            end
        end

        it "should sort population based on fitness from highest to lowest" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3)
            evaluator = StubEvaluator(Int32).new(evaluations: [45.6, 7.89, 123.0])
            engine = Darwin.new(config: config, evaluation: evaluator)

            engine.evaluate_population()

            evaluator.calls.size.should eq 3

            expected_fitness = [123.0, 45.6, 7.89]

            (0...3).each { |i| engine.population[i].fitness.should eq expected_fitness[i]}
        end
    end

    describe "#generate_new_population" do
        it "should call the selector for every member of the new population" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3)
            evaluator = StubEvaluator(Int32).new(default_evaluation: 80.0)
            selector = StubSelector(Int32).new
            crossover = StubCrossover(Int32).new
            mutator = StubMutator(Int32).new
            engine = Darwin.new(config: config, evaluation: evaluator, selection: selector, crossover: crossover, mutation: mutator)
            
            engine.evaluate_population
            engine_population = engine.population

            engine.generate_new_population

            selector.calls.should eq [engine_population, engine_population, engine_population]
        end

        it "should call crossover with the results from the selector" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3)
            evaluator = StubEvaluator(Int32).new(default_evaluation: 80.0)
            crossover = StubCrossover(Int32).new
            mutator = StubMutator(Int32).new

            selector = StubSelector(Int32).new(selection_ids: [{1, 2}, {2, 0}, {1, 0}])

            engine = Darwin.new(config: config, evaluation: evaluator, selection: selector, crossover: crossover, mutation: mutator)
            engine.evaluate_population

            engine.generate_new_population

            expected_calls = [{[4, 5, 6], [7, 8, 9]},
                            {[7, 8, 9], [1, 2, 3]},
                            {[4, 5, 6], [1, 2, 3]}]

            crossover.calls.should eq expected_calls
        end

        it "should call mutation with the results from the crossover" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3)
            evaluator = StubEvaluator(Int32).new(default_evaluation: 80.0)
            selector = StubSelector(Int32).new
            mutator = StubMutator(Int32).new

            crossover = StubCrossover(Int32).new(crossover_results: [[0, 0, 0], [1, 1, 1], [2, 2, 2]])
            
            engine = Darwin.new(config: config, evaluation: evaluator, selection: selector, crossover: crossover, mutation: mutator)
            engine.evaluate_population

            engine.generate_new_population

            mutator.calls.should eq [[0, 0, 0], [1, 1, 1], [2, 2, 2]]
        end

        it "should preserve fittest individuals when elitism is on" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3, elitism: 1)
            selector = StubSelector(Int32).new
            crossover = StubCrossover(Int32).new
            
            evaluator = StubEvaluator(Int32).new(evaluations: [1.0, 9.0, 1.0]) # Genome [4, 5, 6] with a higher fitness
            mutator = StubMutator(Int32).new(mutation_results: [[0, 0, 0], [0, 0, 0], [0, 0, 0]])
            
            engine = Darwin.new(config: config, evaluation: evaluator, selection: selector, crossover: crossover, mutation: mutator)
            engine.evaluate_population

            engine.generate_new_population

            engine.population[0].dna.should eq [4, 5, 6]
        end

        it "should preserve multiple fittest individuals when elitism is > 1" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3, elitism: 2)
            selector = StubSelector(Int32).new
            crossover = StubCrossover(Int32).new
            
            evaluator = StubEvaluator(Int32).new(evaluations: [3.0, 9.0, 1.0]) # Genome [4, 5, 6] > Genome [1, 2, 3] > Genome [7, 8, 9]
            mutator = StubMutator(Int32).new(mutation_results: [[0, 0, 0], [0, 0, 0], [0, 0, 0]])
            
            engine = Darwin.new(config: config, evaluation: evaluator, selection: selector, crossover: crossover, mutation: mutator)
            engine.evaluate_population

            engine.generate_new_population

            engine.population[0].dna.should eq [4, 5, 6]
            engine.population[1].dna.should eq [1, 2, 3]
        end
    end

    describe "#run" do
        it "should call the operators and evaluate population afterwards" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3)
            evaluator = StubEvaluator(Int32).new(default_evaluation: 80.0)
            selector = StubSelector(Int32).new
            crossover = StubCrossover(Int32).new
            
            mutator = StubMutator(Int32).new(mutation_results: [[1, 1, 1], [2, 2, 2], [3, 3, 3]])
            
            engine = Darwin.new(config: config, evaluation: evaluator, selection: selector, crossover: crossover, mutation: mutator)
            engine.evaluate_population
            evaluator.calls = [] of Array(Int32) # Reset evaluator calls so we only have to assert the ones we want
            evaluator.evaluations = [13.0, 21.0, 12.3]

            engine.run

            selector.calls.size.should eq 3
            crossover.calls.size.should eq 3
            mutator.calls.size.should eq 3
            evaluator.calls.size.should eq 3

            expected_evaluations = [21.0, 13.0, 12.3]

            evaluator.calls.should eq [[1, 1, 1], [2, 2, 2], [3, 3, 3]]
            (0...3).each { |i| engine.population[i].fitness.should eq expected_evaluations[i] }
        end

        it "should evaluate population first if it hasn't been evaluated yet" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3)
            evaluator = StubEvaluator(Int32).new(default_evaluation: 80.0)
            selector = StubSelector(Int32).new
            crossover = StubCrossover(Int32).new
            
            mutator = StubMutator(Int32).new(mutation_results: [[1, 1, 1], [2, 2, 2], [3, 3, 3]])

            engine = Darwin.new(config: config, evaluation: evaluator, selection: selector, crossover: crossover, mutation: mutator)

            engine.run

            evaluator.calls.size.should eq 6 # 3 from the first evaluation (which we want to test) and 3 from evaluating the new population

            evaluator.calls.should eq [[1, 2, 3], [4, 5, 6], [7, 8, 9], # Initial population
                                        [1, 1, 1], [2, 2, 2], [3, 3, 3]] # New population
        end

        it "should increment generation counter" do
            alphabet = StubAlphabet.new([1, 2, 3, 4, 5, 6, 7, 8, 9])
            config = GAConfig.new(alphabet: alphabet, genome_length: 3, population_size: 3)
            evaluator = StubEvaluator(Int32).new(default_evaluation: 80.0)
            selector = StubSelector(Int32).new
            crossover = StubCrossover(Int32).new
            mutator = StubMutator(Int32).new()
            engine = Darwin.new(config: config, evaluation: evaluator, selection: selector, crossover: crossover, mutation: mutator)

            engine.generation.should eq 1

            engine.run

            engine.generation.should eq 2

        end
    end
end