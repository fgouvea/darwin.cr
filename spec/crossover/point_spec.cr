require "../spec_helper"

describe PointCrossover do
    describe "#crossover" do
        it "should copy from one parent 1 to the random point and then from parent 2" do
            crossover = PointCrossover(Int32).new(
                rng: MockRandom.new(random_ints: [2])
            )

            result = crossover.crossover([0, 0, 0, 0, 0], [1, 1, 1, 1, 1])

            result.should eq [0, 0, 1, 1, 1]
        end
    end
end