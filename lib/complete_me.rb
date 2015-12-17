require_relative 'trie'

class CompleteMe
  attr_reader :root, :count
  def initialize
    @root = Trie.new
    @count = 0
  end

  def insert(word)
    word = word.chars
    inserted = root.insert(word)
    @count += 1 if inserted
  end

  def suggest(word_begin)
    root.suggest(word_begin)
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
