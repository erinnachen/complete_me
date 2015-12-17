class Trie
  attr_reader :paths, :value, :weights

  def initialize
    @value = nil
    @weights = Hash.new(0)
    @paths = {}
  end

  def insert(word_chars, word = '')
    if word_chars.empty? && (word.empty? || !value.nil?)
      false
    elsif word_chars.empty? && value.nil?
      @value=word
    else
      current_char = word_chars.shift
      @paths[current_char] = Trie.new if @paths[current_char].nil?
      word << current_char
      paths[current_char].insert(word_chars, word)
    end
  end

  def get_words_and_weights
    words_and_weights = []
    if is_word?
      words_and_weights << [value, weights]
    end
    paths.each do |char, path|
      words_and_weights += path.get_words_and_weights
    end
    words_and_weights
  end

  def get_words_sorted_by_weight(word_begin)
    sorted_by_weight = get_words_and_weights.sort_by do |wandw|
      -1*wandw[1][word_begin]
    end
    sorted_by_weight.map {|wandw| wandw[0]}
  end

  def suggest(word_begin)
    sub_trie = traverse_to(word_begin.chars)
    if sub_trie
      sub_trie.get_words_sorted_by_weight(word_begin)
    else
      []
    end
  end

  def is_word?
    !!value
  end

  def traverse_to(word_arr)
    if word_arr.empty?
      self
    else
      path_key = word_arr.shift
      if paths.keys.include?(path_key)
        paths[path_key].traverse_to(word_arr)
      end
    end
  end

  def select(substring, word)
    sub_trie = traverse_to(word.chars)
    sub_trie.weights[substring]+=1 if word.start_with?(substring)
  end

end
