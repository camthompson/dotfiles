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
  require 'interactive_editor'
  alias v vim
rescue LoadError
end

begin
  require 'ap'
  alias p ap
rescue LoadError
end

class Array
  def self.toy(i=10)
    (1..i).to_a
  end
end

class Hash
  def self.toy(i=10)
    h = {}
    (1..i).each { |x| h[(x+96).chr.to_sym] = x }
    h
  end
end

alias q exit

def time(&block)
  require 'benchmark'
  result = nil
  timing = Benchmark.measure do
    result = block.()
  end
  puts "It took: #{timing}"
  result
end
