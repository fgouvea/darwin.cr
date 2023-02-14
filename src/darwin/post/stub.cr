require "./post"

module Darwin::Post
    class StubProcessor(T) < PostProcessor(T)
        property times_called = 0

        def initialize()
        end

        def process(engine : Darwin::Engine(T))
            @times_called += 1
        end
    end
end