class Node
  attr_reader :paths, :value
  attr_accessor :weights
  def initialize
    @value = nil
    @weights = Hash.new(0)
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

  def get_words_and_weights()
    if is_word? && paths.empty?
      words = [[value, weights]]
    else
      if is_word?
        words = [[value, weights]]
      else
        words = []
      end
      paths.each do |char,node|
        words += node.get_words_and_weights
      end
    end
    words
  end

  def get_words(substring = :default)
    wandws = get_words_and_weights()
    sorted = wandws.sort_by {|wandw| -1*wandw[1][substring]}
    sorted.map {|wandw| wandw[0]}
  end

  def traverse_to(word_arr)
    if word_arr.empty?
      self
    else
      path_key = word_arr.shift
      paths[path_key].traverse_to(word_arr)
    end
  end

  def select(substring, word)
    n = traverse_to(word.chars)
    n.weights[substring]+=1 if word.start_with?(substring)
  end

  def is_word?
    !!value
  end

end
