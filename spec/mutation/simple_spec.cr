require "../spec_helper"

describe SimpleMutator do
    describe "#mutate" do
    
        it "should mutate gene if RNG generates a float bigger than the mutation rate" do
            mutator = SimpleMutator(Int32).new(
                alphabet: StubAlphabet.new([1]),
                probability: 0.2,
                rng: MockRandom.new(random_floats: [0.9, 0.1, 0.5])
            )

            result = mutator.mutate([0, 0, 0])

            result.should eq [0, 1, 0]
        end

        it "should mutate multiple genes if needed" do
            mutator = SimpleMutator(Int32).new(
                alphabet: StubAlphabet.new([1, 2]),
                probability: 0.2,
                rng: MockRandom.new(random_floats: [0.9, 0.1, 0.05])
            )

            result = mutator.mutate([0, 0, 0])

            result.should eq [0, 1, 2]
        end
    end
end