class Node
  attr_reader :paths
  attr_reader :value
  def initialize
    @value = nil
    @paths = {}
  end

  def insert(word_arr, word = '')
    if word_arr.empty?
      @value=word unless word.empty?
    else
      current_char = word_arr.shift
      @paths[current_char] = Node.new if @paths[current_char].nil?
      word << current_char
      paths[current_char].insert(word_arr, word)
    end
  end

  def get_words()
    if is_word? && paths.empty?
      words = [value]
    else
      if is_word?
        words = [value]
      else
        words = []
      end
      paths.each do |char,node|
        words += node.get_words()
      end
    end
    words
  end

  def is_word?
    !!value
  end

end
