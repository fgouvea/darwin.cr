require "./evaluation"

module Darwin::Evaluation

    # An `Evaluator` stub to be used for testing purposes.
    class StubEvaluator(T) < Evaluator(T)

        # All the calls received by the stub, with each element being the array of genes received by the `evaluate()` method.
        property calls = [] of Array(T)
        property evaluations : Array(Float64)

        # Constructor that receives an array of fitness scores to be returned in order by the stub, and a default score to be returned if the array runs out.
        def initialize(@evaluations = [] of Float64, @default_evaluation = 1.0)
        end

        def evaluate(dna : Array(T)) : Float64
            @calls.push dna

            evaluation = @default_evaluation

            if @evaluations.size > 0
                evaluation = @evaluations.shift
            end

            evaluation
        end
    end
end