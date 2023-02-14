require "../spec_helper"

describe StubSelector do
    describe "#select_mates" do

        it "should select based on given ids" do
            genomes = [Genome.new([0, 0, 0]), Genome.new([1, 1, 1]), Genome.new([2, 2, 2])]

            selector = StubSelector(Int32).new([{2, 0}, {1, 2}, {1, 0}])

            result1 = selector.select_mates(genomes)
            result2 = selector.select_mates(genomes)
            result3 = selector.select_mates(genomes)

            result1.should eq Tuple.new(genomes[2], genomes[0])
            result2.should eq Tuple.new(genomes[1], genomes[2])
            result3.should eq Tuple.new(genomes[1], genomes[0])
        end

        it "should select first and second parents if it runs out of results" do
            genomes = [Genome.new([0, 0, 0]), Genome.new([1, 1, 1]), Genome.new([2, 2, 2])]

            selector = StubSelector(Int32).new([{2, 0}])

            result1 = selector.select_mates(genomes)
            result2 = selector.select_mates(genomes)
            result3 = selector.select_mates(genomes)

            result1.should eq Tuple.new(genomes[2], genomes[0])
            result2.should eq Tuple.new(genomes[0], genomes[1])
            result3.should eq Tuple.new(genomes[0], genomes[1])
        end

        it "should register calls" do
            expected_calls = [[Genome.new([0, 0, 0]), Genome.new([1, 1, 1]), Genome.new([2, 2, 2])],
                            [Genome.new([3, 3, 3]), Genome.new([4, 4, 4]), Genome.new([5, 5, 5])]]

            selector = StubSelector(Int32).new()

            selector.calls.size.should eq 0

            result1 = selector.select_mates(expected_calls[0])

            selector.calls.size.should eq 1

            result1 = selector.select_mates(expected_calls[1])

            selector.calls.size.should eq 2
            selector.calls.should eq expected_calls
        end
    end
end