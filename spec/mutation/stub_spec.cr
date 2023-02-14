require "../spec_helper"

describe StubMutator do
    describe "#mutate" do
    
        it "should give results in order they are given" do
            mutator = StubMutator(Int32).new([[0, 0, 0], [1, 1, 1], [2, 2, 2]])

            result1 = mutator.mutate([1, 2, 3])
            result2 = mutator.mutate([4, 5, 6])
            result3 = mutator.mutate([7, 8, 9])

            result1.should eq [0, 0, 0]
            result2.should eq [1, 1, 1]
            result3.should eq [2, 2, 2]
        end
    
        it "should return unchanged genome if results run out" do
            mutator = StubMutator(Int32).new([[0, 0, 0]])

            result1 = mutator.mutate([1, 2, 3])
            result2 = mutator.mutate([4, 5, 6])
            result3 = mutator.mutate([7, 8, 9])

            result1.should eq [0, 0, 0]
            result2.should eq [4, 5, 6]
            result3.should eq [7, 8, 9]
        end
    
        it "should record number of calls" do
            expected_calls = [[1, 2, 3], [4, 5, 6]]

            mutator = StubMutator(Int32).new()

            mutator.calls.size.should eq 0

            mutator.mutate(expected_calls[0])

            mutator.calls.size.should eq 1
            
            mutator.mutate(expected_calls[1])

            mutator.calls.size.should eq 2
            mutator.calls.should eq expected_calls
        end
    end
end