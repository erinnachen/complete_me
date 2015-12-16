require_relative 'test_helper'
require 'minitest'
require_relative '../lib/trie'

class TrieTest < Minitest::Test
  def test_new_trie_has_no_value_and_no_paths
    t = Trie.new
    assert_nil t.value
    assert_equal 0, t.paths.length
  end

  #
  # def test_is_word_returns_true_at_the_end_of_a_word
  #   n = Node.new
  #   word_arr = "dog".chars
  #   n.insert(word_arr)
  #   refute n.paths["d"].is_word?
  #   refute n.paths["d"].paths["o"].is_word?
  #   assert n.paths["d"].paths["o"].paths["g"].is_word?
  # end
  #
  # def test_get_words_and_weights_returns_an_array_of_arrays_containing_words_and_their_weights
  #   n = Node.new
  #   word_arr = "dog".chars
  #   n.insert(word_arr)
  #   n.insert("cat".chars)
  #   assert_equal [["dog", {}],["cat",{}]], n.get_words_and_weights
  # end
  #
  # def test_get_words_returns_all_words_on_an_overlapping_branch
  #   n = Node.new
  #   words = ["dog","dot","doppler","docile"]
  #   words.each do |word|
  #     n.insert(word.chars)
  #   end
  #   assert_equal words.sort, n.get_words.sort
  # end
  #
  # def test_get_words_returns_all_words_on_a_branch_that_has_multiple_words_along_it
  #   n = Node.new
  #   words = ["bat","batch","batches", "batchesesss", "batchelor"]
  #   words.each do |word|
  #     n.insert(word.chars)
  #   end
  #   assert_equal words.sort, n.get_words.sort
  # end
  #
  # def test_get_words_returns_all_words_on_multiple_overlapping_branches
  #   n = Node.new
  #   words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
  #   words.each do |word|
  #     n.insert(word.chars)
  #   end
  #   assert_equal words.sort, n.get_words.sort
  # end
  #
  #
  # def test_traverse_to_a_single_word
  #   n = Node.new
  #   words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
  #   words.each do |word|
  #     n.insert(word.chars)
  #   end
  #   word_node = n.traverse_to("doppler".chars)
  #   assert word_node.is_word?
  #   assert_equal "doppler", word_node.value
  #   assert_equal 0, word_node.weights[:default]
  # end
  #
  # def test_change_weight_on_specific_word
  #   n= Node.new
  #   words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
  #   words.each do |word|
  #     n.insert(word.chars)
  #   end
  #   n.select("","doppler")
  #   n.select("","doppler")
  #   word_node = n.traverse_to("doppler".chars)
  #   assert_equal "doppler", word_node.value
  #   assert_equal 2, word_node.weights[""]
  # end
  #
  # def test_does_not_change_the_weight_on_a_word_not_in_the_subtree
  #   n= Node.new
  #   words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
  #   words.each do |word|
  #     n.insert(word.chars)
  #   end
  #   n.select("b","doppler")
  #   n.select("d","doppler")
  #   word_node = n.traverse_to("doppler".chars)
  #   assert_equal "doppler", word_node.value
  #   assert_equal 0, word_node.weights["b"]
  #   assert_equal 1, word_node.weights["d"]
  # end
  #
  # def test_word_has_different_weights_when_selected_with_different_substrings
  #   n= Node.new
  #   words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
  #   words.each do |word|
  #     n.insert(word.chars)
  #   end
  #   n.select("b","doppler")
  #   n.select("d","doppler")
  #   n.select("d","doppler")
  #   n.select("do","doppler")
  #   n.select("dopp","doppler")
  #   n.select("dop","doppler")
  #   word_node = n.traverse_to("doppler".chars)
  #   assert_equal 2, word_node.weights["d"]
  #   assert_equal 1, word_node.weights["do"]
  #   assert_equal 1, word_node.weights["dopp"]
  # end
  #
  # def test_get_words_returns_words_sorted_by_weight_two_elements
  #   n= Node.new
  #   words = ["apple", "dog"]
  #   words.each do |word|
  #     n.insert(word.chars)
  #   end
  #   assert_equal ["apple","dog"], n.get_words
  #   n.select("","dog")
  #   n.select("","dog")
  #   h = {''=>2}
  #   assert_equal h, n.traverse_to("dog".chars).weights
  #   assert n.traverse_to("apple".chars).weights.empty?
  #   assert_equal ["dog","apple"], n.get_words("")
  # end
  #
  # def test_get_words_returns_words_sorted_by_weight_three_elements
  #   n= Node.new
  #   words = ["apple", "dog", "rhino"]
  #   words.each do |word|
  #     n.insert(word.chars)
  #   end
  #   assert_equal ["apple","dog","rhino"], n.get_words
  #   4.times {n.select("","dog")}
  #   2.times {n.select("","apple")}
  #   assert_equal ["dog","apple","rhino"], n.get_words("")
  # end
  #
  # def test_get_words_returns_words_sorted_by_weight_if_selected_with_different_substrings
  #   n= Node.new
  #   words = ["do","dog","doppler"]
  #   words.each do |word|
  #     n.insert(word.chars)
  #   end
  #   4.times {n.select("d","do")}
  #   2.times {n.select("d","doppler")}
  #   3.times {n.select("do","dog")}
  #   2.times {n.select("do","do")}
  #   n.select("do","doppler")
  #   assert_equal ["do","doppler","dog"], n.get_words("d")
  #   assert_equal ["dog","do","doppler"], n.get_words("do")
  #
  # end
  #
  # def test_should_check_if_traverse_returns_even_if_word_isnt_in_my_trie
  #   skip
  # end

end

class TrieInsertTest < Minitest::Test
  def test_insert_an_empty_array_returns_false
    t = Trie.new
    inserted = t.insert([])
    assert_nil t.value
    assert_equal 0, t.paths.length
    inserted
  end

  def test_insert_a_single_character_word
    t = Trie.new
    inserted = t.insert(["a"])
    assert_equal 1, t.paths.length
    assert_equal "a", t.paths["a"].value
    assert inserted
  end

  def test_insert_a_two_character_word
    t = Trie.new
    word_arr = "do".chars
    t.insert(word_arr)
    assert_equal 1, t.paths.length
    assert_nil t.value
    assert_nil t.paths["d"].value
    assert_equal "do", t.paths["d"].paths["o"].value
  end

  def test_insert_returns_false_if_word_already_inserted
    t = Trie.new
    word_arr = "bear".chars
    inserted1 = t.insert("bear".chars)
    inserted2 = t.insert("bear".chars)
    assert inserted1
    refute inserted2
  end

  def test_insert_two_words_start_with_same_character
    t = Trie.new
    word_arr = "do".chars
    t.insert(word_arr)
    word_arr2 = "dare".chars
    t.insert(word_arr2)

    assert_equal 1, t.paths.length
    refute_nil t.paths["d"].paths["o"]
    refute_nil t.paths["d"].paths["a"]
    assert_equal "do", t.paths["d"].paths["o"].value
    assert_equal "dare", t.paths["d"].paths["a"].paths["r"].paths["e"].value
  end

  def test_insert_two_words_with_mulitple_overlapping_characters
    t = Trie.new
    word_arr = "door".chars
    t.insert(word_arr)
    word_arr2 = "dog".chars
    t.insert(word_arr2)

    assert_equal 1, t.paths.length
    assert_equal 1, t.paths["d"].paths.length
    assert_equal 2, t.paths["d"].paths["o"].paths.length
    assert_equal "dog", t.paths["d"].paths["o"].paths["g"].value
    assert_equal "door", t.paths["d"].paths["o"].paths["o"].paths["r"].value
  end

end
