require "./post"

class StubProcessor(T) < PostProcessor(T)
    property times_called = 0

    def initialize()
    end

    def process(engine : Darwin(T))
        @times_called += 1
    end
end