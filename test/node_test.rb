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

  def test_get_words_returns_the_word_for_a_single_insertion
    n = Node.new
    word_arr = "dog".chars
    n.insert(word_arr)
    assert_equal ["dog"], n.get_words
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

end
