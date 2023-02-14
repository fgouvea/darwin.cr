require "./evaluation"

module Darwin::Evaluation
    class StubEvaluator(T) < Evaluator(T)
        property calls = [] of Array(T)
        property evaluations : Array(Float64)

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