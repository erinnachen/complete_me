require_relative 'test_helper'
require 'minitest'
require_relative '../lib/trie'

class TrieTest < Minitest::Test
  def test_new_trie_has_no_value_and_no_paths
    t = Trie.new
    assert_nil t.value
    assert_equal 0, t.paths.length
  end

  def test_traverse_to_returns_self_if_input_is_empty
    t = Trie.new
    assert_equal t, t.traverse_to([])
  end

  def test_traverse_to_end_trie_for_a_single_element
    t = Trie.new
    t.insert(["a"])
    assert_equal t.paths["a"], t.traverse_to(["a"])
    assert_equal "a", t.traverse_to(["a"]).value
  end

  def test_can_traverse_to_a_substring_that_is_not_a_word
    t = Trie.new
    t.insert("pizzeria".chars)
    t.insert("creamery".chars)
    t.insert("brewery".chars)
    assert_nil t.traverse_to("pizz".chars).value
    assert_equal "pizzeria", t.traverse_to("pizzeria".chars).value
  end

  def test_can_traverse_to_a_substring_that_is_a_word
    t = Trie.new
    t.insert("pizzeria".chars)
    t.insert("creamery".chars)
    t.insert("brewery".chars)
    assert_equal "pizzeria", t.traverse_to("pizzeria".chars).value
  end

  def test_traverse_to_returns_nil_if_word_not_in_trie
    t = Trie.new
    t.insert("pizzeria".chars)
    assert_nil t.traverse_to("pizza".chars)
    assert_nil t.traverse_to("car".chars)
  end

  def test_empty_array_is_not_a_word
    t = Trie.new
    t.insert([])
    refute t.traverse_to([]).is_word?
  end

  def test_is_word_returns_true_at_the_end_of_a_word
    t = Trie.new
    word_arr = "dog".chars
    t.insert(word_arr)
    refute t.traverse_to(["d"]).is_word?
    refute t.traverse_to(["d","o"]).is_word?
    assert t.traverse_to(["d","o","g"]).is_word?
  end

  def test_get_words_and_weights_returns_all_words_on_an_overlapping_branch
    t = Trie.new
    words = ["dog","dot","doppler","docile"]
    words.each do |word|
      t.insert(word.chars)
    end
    get_words = t.get_words_and_weights.map {|wandw| wandw[0]}
    assert_equal words.sort, get_words.sort
  end

  def test_get_words_and_weights_returns_all_words_on_a_branch_that_has_multiple_words_along_it
    t = Trie.new
    words = ["bat","batch","batches", "batchesesss", "batchelor"]
    words.each do |word|
      t.insert(word.chars)
    end
    get_words = t.get_words_and_weights.map {|wandw| wandw[0]}
    assert_equal words.sort, get_words.sort
  end

  def test_get_words_and_weights_returns_all_words_on_multiple_overlapping_branches
    t = Trie.new
    words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
    words.each do |word|
      t.insert(word.chars)
    end
    get_words = t.get_words_and_weights.map {|wandw| wandw[0]}
    assert_equal words.sort, get_words.sort
  end

  def test_returns_empty_array_if_suggest_a_word_beginning_not_in_trie
    t = Trie.new
    t.insert("pizzeria".chars)
    t.insert("creamery".chars)
    t.insert("brewery".chars)
    assert_equal [], t.suggest("pizza")
  end

  def test_get_words_and_weights_returns_an_array_of_arrays_containing_words_and_their_weights
    t = Trie.new
    word_arr = "dog".chars
    t.insert(word_arr)
    t.insert("cat".chars)
    assert_equal [["dog", {}],["cat",{}]], t.get_words_and_weights
  end

  def test_change_weight_on_specific_word
    t = Trie.new
    words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
    words.each do |word|
      t.insert(word.chars)
    end
    t.select("","doppler")
    t.select("","doppler")
    word_node = t.traverse_to("doppler".chars)
    assert_equal "doppler", word_node.value
    assert_equal 2, word_node.weights[""]
  end

  def test_does_not_change_the_weight_on_a_word_not_in_the_subtree
    t = Trie.new
    words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
    words.each do |word|
      t.insert(word.chars)
    end
    t.select("b","doppler")
    t.select("d","doppler")
    word_node = t.traverse_to("doppler".chars)
    assert_equal "doppler", word_node.value
    assert_equal 0, word_node.weights["b"]
    assert_equal 1, word_node.weights["d"]
  end

  def test_word_has_different_weights_when_selected_with_different_substrings
    t = Trie.new
    words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
    words.each do |word|
      t.insert(word.chars)
    end
    t.select("b","doppler")
    t.select("d","doppler")
    t.select("d","doppler")
    t.select("do","doppler")
    t.select("dopp","doppler")
    t.select("dop","doppler")
    word_node = t.traverse_to("doppler".chars)
    assert_equal 2, word_node.weights["d"]
    assert_equal 1, word_node.weights["do"]
    assert_equal 1, word_node.weights["dopp"]
  end

  def test_suggest_returns_words_sorted_by_weight_two_elements
    t = Trie.new
    words = ["apple", "dog"]
    words.each do |word|
      t.insert(word.chars)
    end
    assert_equal ["apple","dog"], t.suggest("")
    t.select("","dog")
    t.select("","dog")
    h = {''=>2}
    assert_equal h, t.traverse_to("dog".chars).weights
    assert t.traverse_to("apple".chars).weights.empty?
    assert_equal ["dog","apple"], t.suggest("")
  end

  def test_suggest_returns_words_sorted_by_weight_three_elements
    t = Trie.new
    words = ["apple", "dog", "rhino"]
    words.each do |word|
      t.insert(word.chars)
    end
    assert_equal ["apple","dog","rhino"], t.suggest("")
    4.times {t.select("","dog")}
    2.times {t.select("","apple")}
    assert_equal ["dog","apple","rhino"], t.suggest("")
  end

  def test_suggest_returns_words_sorted_by_weight_if_selected_with_different_substrings
    t = Trie.new
    words = ["do","dog","doppler"]
    words.each do |word|
      t.insert(word.chars)
    end
    4.times {t.select("d","do")}
    2.times {t.select("d","doppler")}
    3.times {t.select("do","dog")}
    2.times {t.select("do","do")}
    t.select("do","doppler")
    assert_equal ["do","doppler","dog"], t.suggest("d")
    assert_equal ["dog","do","doppler"], t.suggest("do")

  end

end

class TrieInsertTest < Minitest::Test
  def test_an_empty_array_returns_false
    t = Trie.new
    inserted = t.insert([])
    assert_nil t.value
    assert_equal 0, t.paths.length
    inserted
  end

  def test_a_single_character_word
    t = Trie.new
    inserted = t.insert(["a"])
    assert_equal 1, t.paths.length
    assert_equal "a", t.paths["a"].value
    assert inserted
  end

  def test_a_two_character_word
    t = Trie.new
    word_arr = "do".chars
    t.insert(word_arr)
    assert_equal 1, t.paths.length
    assert_nil t.value
    assert_nil t.paths["d"].value
    assert_equal "do", t.paths["d"].paths["o"].value
  end

  def test_returns_false_if_word_already_inserted
    t = Trie.new
    word_arr = "bear".chars
    inserted1 = t.insert("bear".chars)
    inserted2 = t.insert("bear".chars)
    assert inserted1
    refute inserted2
  end

  def test_two_words_start_with_same_character
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

  def test_two_words_that_end_with_same_characters
    t = Trie.new
    word_arr = "core".chars
    t.insert(word_arr)
    word_arr2 = "dare".chars
    t.insert(word_arr2)

    assert_equal 2, t.paths.length
    assert_equal "dare", t.paths["d"].paths["a"].paths["r"].paths["e"].value
    assert_equal "core", t.paths["c"].paths["o"].paths["r"].paths["e"].value
  end

  def test_two_words_with_mulitple_overlapping_characters
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
