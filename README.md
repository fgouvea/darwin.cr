# Darwin.cr

A genetic algorithm Crystal library that aims to be simple, but highly customizable.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     darwin:
       github: fgouvea/darwin.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "darwin"

# This will evaluate the fitness of each genome
class HelloWorldEvaluator < Darwin::Evaluator(Char)
  def evaluate(genome : Array(Char)) : Float64
    accuracy = 0.0

    # Count how many characters in the genome match the string "hello world!"
    (0...genome.size).each do |i|
      accuracy += 1 if genome[i] == "hello world!".chars[i]
    end

    accuracy
  end
end

config = Darwin::Config.new(
  alphabet: Darwin::Alphabet::StringAlphabet.new("abcdefghijklmnopqrstuwvxyz?!,.; "),
  genome_length: 12,
  population_size: 50
) 

engine = Darwin::Engine.new(
  config: config,
  evaluation: HelloWorldEvaluator.new)

engine.run(generations: 100)

engine.population[0].dna # => The fittest individual after running
```

To use `darwin.cr` to execute the genetic algorithm (GA) you will have to:

* Code a class that extends `Darwin::Evaluator` and implements `evaluate(Array(T)) : Float64` to evaluate the fitness of a genome.
* Crate a `Darwin::Config` object that defines:
* * `alphabet` - an instance of `Darwin::Alphabet::Alphabet(T)`. You can one of the alphabets provided in this liberary such as `IntAlphabet`, `ArrayAlphabet` or `StringAlphabet` (see _Alphabet_ section below) or implement your own.
* * `genome_length` - how many genes are in each individual of the population.
* * `population_size` - how many individuals are in the population in each generation.
* Crate a `Darwin::Engine` instance with the configuration and evaluator defined above

The `engine` instance lets you run the GA. At the end of every generation the population will be sorted by fitness from highest to lowest, so the fittest individual can be accessed as `engine.population[0]`.

You may have noticed that most of the classes included in this library have a generic type parameter `T`. This refers to the type of a single gene in the algorithm. By making the classes generic for `T`, Darwin can run for arrays of any type you want.

There are more options provided in the `config` and `engine` objects, as well as various implementations of the operators used in the GA (crossover, mutation, selection), all of which will be discussed in the sections below.

Additionally, you can declare a `Darwin::PostProcessor` that will run after each generation to examine or print the results, such as:

```crystal
class Printer < Darwin::PostProcessor(Char)
  def process(engine : Darwin::Engine(Char))
    puts "[#{engine.generation} #{engine.population[0].dna.join} (fitness = #{engine.population[0].fitness})]"
  end
end

engine = Darwin::Engine.new(..., post: Printer.new)
```

### Config

The `Darwin::Config` class has the following properties:

* `alphabet : Darwin::Alphabet::Alphabet(T)` - an instance of `Darwin::Alphabet::Alphabet(T)`. You can one of the alphabets provided in this liberary such as `IntAlphabet`, `ArrayAlphabet` or `StringAlphabet` (see _Alphabet_ section below) or implement your own.
* `genome_length : Int32` - how many genes are in each individual of the population.
* `population_size : Int32` - how many individuals are in the population in each generation.
* `elitism : Int32` - number of the fittest individuals that will be carried over unchanged to the next population in every generation. This can sometimes help avoid regressions and speed up the algorithm. _(Default = 0)_

This properties can be assigned as named paremters in the constructor or changed with the setters (e.g. `config.elitism = 2`) after the object has been initialized.

### Engine

The `Darwin::Engine` object is responsible for actually carrying out the GA and accepts the following parameters on initialization:

* `config : Config(T)` - the Darwin config object.
* `evaluation : Evaluator(T)` - the evaluator object that will determine the fitness of an individual, which will in turn determine how likely it is to be selected for mating into the next generation.
*`crossover : CrossoverOperator(T)` - the crossover operator used to combine two individuals to generate another. By default this is an instance of `Darwin::Crossover::PointCrossover`. This class and its implementations are discussed in the _Crossover_ section below.
* `mutation : MutationOperator(T)` - the mutation operator used to randomly alter an individual to generate genetic diversity in the population. By default this is an instance of `Darwin::Mutation::SimpleMutator`. This class and its implementations are discussed in the _Mutation_ section below.
* `selection : SelectionOperator(T)` - the selection operator used to select two individuals for mating after their fitness has been determined. By default this is an instance of `Darwin::Selection::FitnessSelector`. his class and its implementations are discussed in the _Selection_ section below.
* `post : PostProcessor(T) | Nil` - a post processor that will be run after every generation.

The main method of the `Engine` class is `run(generations : Int32 = 1)`, which will run the operators of selection, crossover, mutation and evaluation, in this order, generating another generation. You can run 1 generation by simple calling `engine.run` or run multiple generations as `engine.run(10)` or `engine.run(generations: 10)`, for example.

The fields that can be read from the `engine` object are:

* `generation : Int32` - the generation number (starts at 1).
* `population: Array(Genome(T))` - the population, sorted from highest fitness to lowest. The `Genome` object contains:
* * `dna : Array(T)` - the gene array that defines the individual.
* * `fitness : Float64` - the fitness value calculated for the individual by the `Evaluator`.

### Alphabet

An alphabet is a collection of possible genes that can constitute the genomes in the GA.

It is important to note that the type of the genes is generic in the base `Alphabet(T)` class, and the choice of type here will determine the type `T` in all other generic classes of this library. For example, if you are working with an `Alphabet(Int32)`, your crossover operators will be an implementation of `Crossover(Int32)`.

The alphabets provided by this lib are:

* `Darwin::Alphabet::IntAlphabet` - an alphabet where any `Int32` can be a gene. Acceppts parameters `min` and `max` to control the range of integers allowed.
* `Darwin::Alphabet::ArrayAlphabet(T)` -  has an array of objects of type `T` that act as a gene in the genome.
* `Darwin::Alphabet::StringAlphabet` - an easier way of making an `ArrayAlphabet(Char)` from a string. Initialized as `StringAlphabet.new(alphabet: "abcd...").

Examples:

```crystal
i_alph = Darwin::Alphabet::IntAlphabet.new(min: 0, max: 9) # IntAlphabet < Alphabet(Int32)

a_alph = Darwin::Alphabet::ArrayAlphabet(String).new(genes: ["gene1", "gene2", "gene3"]) # ArrayAlphabet(String) < Alphabet(String)

s_alph = Darwin::Alphabet::StringAlphabet.new(alphabet: "qwerty") # StringAlphabet < ArrayAlphabet(Char) < Alphabet(Char)


i_alph.random_gene #=> ex: 5
a_alph.random_gene #=> ex: "gene3"
s_alph.random_gene #=> ex: 'w'
```

However, you may also implement your own `Alphabet` and pass it when instantiating the `config` file. You can do this by implementing:

```crystal
abstract class Alphabet(T)
    abstract def random_gene() : T
end
```

This `random_gene()` method is used by the `Engine` to instantiate the initial population, as well as by the mutator to alter genes in a genome.

### Selection

The selection operator is responsible for - given a population of individual genomes - selecting two genomes to be combined to produce a new genome for the next population.

The implementation of the selection operator provided by this lib is the `Darwin::Selection::FitnessSelector` class, which selects two individuals at random, weighted by the fitness of the individual in relation to the total fitness of the population. In this implementation an individual of fitness `2.0` will be twice as likely to be selected as an individual with a fitness of `1.0`.

However, you may also implement your own `Selector` and pass it when instantiating the `engine`.

A `Selector` has to implement:

```crystal
abstract class SelectionOperator(T)
    abstract def select_mates(genomes : Array(Darwin::Genome(T))) : Tuple(Darwin::Genome(T), Darwin::Genome(T))
end
```

Please note that unlike the other operators, the selection operator receives the `Darwin::Genome` object (described in the _Engine_ section above), so that it can have access to the fitness of the individuals, which is important for this operation.

### Crossover

The crossover operator is responsible for combining two parent genomes to generate a new genome that will be carried over the next population.

The implementations provided out of the box by this library are:

* `Darwin::Crossover::PointCrossover` - selects a random point in the genome and copies everything before this point from one parent and everything after from the other (e.g. combining `AAAAA` and `BBBBB` may result in `AABBB`).
* `Darwin::Crossover::UniformCrossover` - randomly selects each gene from either parent (e.g. combining `AAAAA` and `BBBBB` may result in `ABAAB`).

If no crossover operator is passed to the `engine` object, it will use `PointCrossover`.

However, you may also implement your own `Crossover` by implementing:

```crystal
abstract class CrossoverOperator(T)
    abstract def crossover(genome1 : Array(T), genome2 : Array(T)) : Array(T)
end
```

### Mutation

The mutation operator is responsible for randomly altering the genomes generated in the crossover step before adding them to the next generation. This is extremely important for the GA to add diversity to the population and making sure that it doesn't get stuck in a local maximum because a relevant gene doesn't exist in the population.

The implementation provided by this library is `Darwin::Mutation::SimpleMutator`, which has a X% chance of mutating each gene for a random gene provided by the `Alphabet` used.

The default mutator in the engine object is a `SimpleMutator` with the alphabet provided in the `Config` object and a mutatin rate of `0.1` (10%). If you wish to change the mutation rate, simply instantiate another `SimpleMutator` when initializing the `Engine` object, as in:

```crystal
mutator = Darwin::Mutation::SimpleMutator(alphabet: config.alphabet, probability: your_probability_here)
engine = Darwin::Engine.new(..., mutation: mutator)
```

However, you may also implement your own `Mutator` by implementing:
```crystal
abstract class MutationOperator(T)
    abstract def mutate(genome : Array(T)) : Array(T)
end
```

## Development

Different operator implementations should be added to their respective folders and namespaces. For example, a new `Mutator` should go inside the `src/darwin/mutation` folder and be declared inside the `Darwin::Mutation` namespace.

As many things in the GA involve randomness, a mock of sorts of the `Random` class is provided in `spec/spec_helper.cr`, allowing us to define a sequence of results for the random methods:

```crystal
  rng = MockRandom(random_ints: [3, 2, 0])

  rng.rand(0...10) #=> 3
  rng.rand(0...10) #=> 2
  rng.rand(0...10) #=> 0
  rng.rand(0...10) #=> IndexError
```

Every class that has a random operation receives an optional `rng` parameter on initialization, which we can use to pass the `MockRandom` instance.

Also, every operator has a `Stub` class that will return static results passed to it, as well as recording the parameters of the calls it received. Example:

```crystal
m = Darwin::Mutation::StubMutator(mutation_results: [[0, 0 ,0], [1, 1, 1], [2, 2, 2]])

m.mutate([1, 2, 3]) #=> [0, 0, 0]
m.mutate([4, 5, 6]) #=> [1, 1, 1]

m.calls #=> [[1, 2, 3], [4, 5, 6]]
```

## Contributing

1. Fork it (<https://github.com/fgouvea/darwincr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Fernando Gouvêa](https://github.com/fgouvea) - creator and maintainer
