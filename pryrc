begin
  require 'ap'
  Pry.config.print = proc do |output, value|
    Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)
  end
rescue LoadError
end

def Array.toy(n = 10, &block)
  block_given? ? Array.new(n, &block) : Array.new(n) { |i| i+1 }
end

def Hash.toy(n = 10)
  Array.toy(n).each_with_object({}) { |x, acc| acc[x] = (96 + (x + 1)).chr }
end

def time(&block)
  require 'benchmark'
  result = nil
  timing = Benchmark.measure do
    result = block.()
  end
  puts "It took: #{timing}"
  result
end

begin
  require 'clipboard'
rescue LoadError
end

begin
  require 'interactive_editor'
  alias v vim
rescue LoadError
end
