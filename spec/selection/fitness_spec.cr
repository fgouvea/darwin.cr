require "../spec_helper"

describe FitnessSelector do
    describe "#select_mates" do

        it "should select mates proportionally to fitness" do
            genomes = [Genome.new(["first"]), Genome.new(["second"]), Genome.new(["third"])]
            genomes[0].fitness = 1.0
            genomes[1].fitness = 2.0
            genomes[2].fitness = 3.0

            # These should fall in the range of the third genome (3-6 range) and 1 (0-1 range) respectively
            rng = MockRandom.new(random_floats: [(5.5/6), (0.5/6)])

            selector = FitnessSelector(String).new(rng: rng)

            parents = selector.select_mates(genomes)

            expected = {genomes[2], genomes[0]}
            parents.should eq expected
        end
    end
end