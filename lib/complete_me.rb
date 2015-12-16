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

  def suggest(word_begin)
    substring_node = find_node_to_search(word_begin)
    substring_node.get_words(word_begin)
  end

  def find_node_to_search(word_begin)
    node = root
    word_begin.chars.each do |c|
      node = node.paths[c]
    end
    node
  end

  def populate(dictionary)
    dictionary.split("\n").each do |word|
      insert(word)
    end
  end

  def select(substring, word_to_select)
    root.select(substring, word_to_select)
  end
end
