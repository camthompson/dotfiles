begin
  IRB.conf[:AUTO_INDENT] = true

  require 'irb/ext/save-history'
  IRB.conf[:SAVE_HISTORY] = 1000
  IRB.conf[:EVAL_HISTORY] = 100
  IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

  require 'irb/completion'
  IRB.conf[:USE_READLINE] = true
  IRB.conf[:PROMPT_MODE] = :SIMPLE
  require 'pp'
rescue Object => ex
  puts "ERROR : #{ex.inspect}"
end

begin
  require 'ap'
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
rescue LoadError
end
