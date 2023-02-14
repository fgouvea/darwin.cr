require "../spec_helper"

include Darwin::Crossover

describe UniformCrossover do
    describe "#crossover" do
        it "should copy from either parent according to RNG" do
            crossover = UniformCrossover(Int32).new(
                rng: MockRandom.new(random_bools: [true, true, false, true, false])
            )

            result = crossover.crossover([0, 0, 0, 0, 0], [1, 1, 1, 1, 1])

            result.should eq [0, 0, 1, 0, 1]
        end
    end
end