require 'minitest'
require_relative '../lib/node'

class NodeTest < Minitest::Test
  def test_new_node_has_no_value_and_no_paths
    n = Node.new
    assert_nil n.value
    assert_equal 0, n.paths.length
  end

  def test_insert_an_empty_array
    n = Node.new
    n.insert([])
    assert_nil n.value
    assert_equal 0, n.paths.length
  end

  def test_insert_a_single_character_word
    n = Node.new
    n.insert(["a"])
    assert_equal 1, n.paths.length
    assert_equal "a", n.paths["a"].value
  end

  def test_insert_a_two_character_word
    n = Node.new
    word_arr = "do".chars
    n.insert(word_arr)
    assert_equal 1, n.paths.length
    assert_nil n.value
    assert_nil n.paths["d"].value
    assert_equal "do", n.paths["d"].paths["o"].value
  end

  def test_insert_two_words_with_a_single_overlapping_character
    n = Node.new
    word_arr = "do".chars
    n.insert(word_arr)
    word_arr2 = "dare".chars
    n.insert(word_arr2)

    assert_equal 1, n.paths.length
    refute_nil n.paths["d"].paths["o"]
    refute_nil n.paths["d"].paths["a"]
    assert_equal "do", n.paths["d"].paths["o"].value
    assert_equal "dare", n.paths["d"].paths["a"].paths["r"].paths["e"].value
  end

  def test_insert_two_words_with_mulitple_overlapping_characters
    n = Node.new
    word_arr = "do".chars
    n.insert(word_arr)
    word_arr2 = "dog".chars
    n.insert(word_arr2)

    assert_equal 1, n.paths.length
    assert_nil n.value
    assert_nil n.paths["d"].value
    assert_equal "do", n.paths["d"].paths["o"].value
    assert_equal "dog", n.paths["d"].paths["o"].paths["g"].value

  end

  def test_is_word_returns_true_at_the_end_of_a_word
    n = Node.new
    word_arr = "dog".chars
    n.insert(word_arr)
    refute n.paths["d"].is_word?
    refute n.paths["d"].paths["o"].is_word?
    assert n.paths["d"].paths["o"].paths["g"].is_word?
  end

  def test_get_words_and_weights_returns_an_array_of_arrays_containing_words_and_their_weights
    n = Node.new
    word_arr = "dog".chars
    n.insert(word_arr)
    n.insert("cat".chars)
    assert_equal [["dog", 0],["cat",0]], n.get_words_and_weights
  end

  def test_get_words_returns_all_words_on_an_overlapping_branch
    n = Node.new
    words = ["dog","dot","doppler","docile"]
    words.each do |word|
      n.insert(word.chars)
    end
    assert_equal words.sort, n.get_words.sort
  end

  def test_get_words_returns_all_words_on_a_branch_that_has_multiple_words_along_it
    n = Node.new
    words = ["bat","batch","batches", "batchesesss", "batchelor"]
    words.each do |word|
      n.insert(word.chars)
    end
    assert_equal words.sort, n.get_words.sort
  end

  def test_get_words_returns_all_words_on_multiple_overlapping_branches
    n = Node.new
    words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
    words.each do |word|
      n.insert(word.chars)
    end
    assert_equal words.sort, n.get_words.sort
  end

  def test_traverse_to_a_single_word
    n = Node.new
    words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
    words.each do |word|
      n.insert(word.chars)
    end
    word_node = n.traverse_to("doppler".chars)
    assert word_node.is_word?
    assert_equal "doppler", word_node.value
    assert_equal 0, word_node.weight
  end

  def test_change_weight_on_specific_word
    n= Node.new
    words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
    words.each do |word|
      n.insert(word.chars)
    end

    n.select("doppler")
    n.select("doppler")
    word_node = n.traverse_to("doppler".chars)
    assert_equal "doppler", word_node.value
    assert_equal 2, word_node.weight
  end

  def test_get_words_returns_words_sorted_by_weight_two_elements
    n= Node.new
    words = ["apple", "dog"]
    words.each do |word|
      n.insert(word.chars)
    end
    assert_equal ["apple","dog"], n.get_words
    n.select("dog")
    n.select("dog")
    assert_equal ["dog","apple"], n.get_words
  end

  def test_get_words_returns_words_sorted_by_weight_three_elements
    n= Node.new
    words = ["apple", "dog", "rhino"]
    words.each do |word|
      n.insert(word.chars)
    end
    assert_equal ["apple","dog","rhino"], n.get_words
    4.times {n.select("dog")}
    2.times {n.select("apple")}
    assert_equal ["dog","apple","rhino"], n.get_words
  end

end
