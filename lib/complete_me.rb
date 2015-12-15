require_relative 'node'

class CompleteMe
  attr_reader :root, :count
  def initialize
    @root = Node.new
    @count = 0
  end

  def insert(word)
    word = word.chars
    root.insert(word)
    @count += 1
  end

  

end
