require_relative 'test_helper'
require 'minitest'
require_relative '../lib/complete_me'

class CompleteMeTest < Minitest::Test
  def test_new_complete_me_has_no_words
    cm = CompleteMe.new
    assert_equal 0, cm.count
  end

  def test_insert_changes_the_count_number
    cm = CompleteMe.new
    cm.insert("car")
    assert_equal 1, cm.count
  end

  def test_insert_does_not_change_the_count_number_for_a_repeat
    cm = CompleteMe.new
    cm.insert("car")
    cm.insert("car")
    assert_equal 1, cm.count
  end

  def test_counts_all_words_with_no_repeats
    cm = CompleteMe.new
    words = ["dog","cat","bear","kangaroo"]
    words.each do |word|
      cm.insert(word)
    end
    assert_equal 4, cm.count
  end

  def test_counts_all_words_with_multiple_repeats
    cm = CompleteMe.new
    words = ["dog","cat","bear","kangaroo"]*2
    words.each do |word|
      cm.insert(word)
    end
    assert_equal 4, cm.count
  end

  def test_suggest_returns_a_single_word_insertion
    cm = CompleteMe.new
    cm.insert("car")
    assert_equal ["car"], cm.suggest("car")
  end

  def test_suggest_returns_a_single_word_insertion_when_passed_substring_length_1
    cm = CompleteMe.new
    cm.insert("car")
    assert_equal ["car"], cm.suggest("c")
  end

  def test_suggest_returns_a_single_word_insertion_when_passed_substring_length_2
    cm = CompleteMe.new
    cm.insert("car")
    assert_equal ["car"], cm.suggest("ca")
  end


  def test_suggest_returns_all_words_on_a_branch_that_has_multiple_words_along_it
    cm = CompleteMe.new
    words = ["bat","batch","batches", "batchesesss", "batchelor"]
    words.each do |word|
      cm.insert(word)
    end
    assert_equal words.sort, cm.suggest("bat").sort
    assert_equal ["batch","batches", "batchesesss", "batchelor"].sort, cm.suggest("batc").sort
    assert_equal ["batches", "batchesesss"], cm.suggest("batches")
  end

  def test_suggest_on_a_single_branch_with_multiple_branches
    cm = CompleteMe.new
    words = ["dog","dot","doppler","docile","docks"]
    words.each do |word|
      cm.insert(word)
    end
    assert_equal words.sort, cm.suggest("d").sort
    assert_equal words.sort, cm.suggest("do").sort
    assert_equal ["docile", "docks"], cm.suggest("doc").sort
    assert_equal ["doppler"], cm.suggest("dop")
  end

  def test_suggest_gets_all_words_in_the_trie_if_passed_empty_string
    cm = CompleteMe.new
    words = ["dog","dot","doppler","docile","docks"]
    words.each do |word|
      cm.insert(word)
    end
    assert_equal words.sort, cm.suggest("").sort
  end

  def test_suggest_returns_empty_if_passed_string_not_in_trie
    cm = CompleteMe.new
    words = ["dog","dot","doppler","docile","docks"]
    words.each do |word|
      cm.insert(word)
    end
    assert_equal [], cm.suggest("app")
    assert_equal [], cm.suggest("door")
  end

  def test_suggest_returns_all_words_on_multiple_overlapping_branches
    cm = CompleteMe.new
    words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
    words.each do |word|
      cm.insert(word)
    end
    assert_equal ["apple", "app", "after"].sort, cm.suggest("a").sort
    assert_equal ["bat", "batch", "baby","buns"].sort, cm.suggest("b").sort
    assert_equal ["dog","dot","doppler","docile"].sort, cm.suggest("d").sort
  end

  def test_dictionary_load_simple_string
    cm = CompleteMe.new
    dictionary = "apple\napp\nafter"
    cm.populate(dictionary)
    assert_equal ["apple", "app", "after"].sort, cm.suggest("").sort
    assert_equal 3, cm.count
  end

  def test_select_words_on_small_sample
    cm = CompleteMe.new
    words = ["apple", "app", "after","bat", "batch", "baby","buns","dog","dot","doppler","docile"]
    words.each do |word|
      cm.insert(word)
    end
    5.times {cm.select("d","doppler")}
    3.times {cm.select("do","dog")}
    assert_equal "doppler", cm.suggest("d").first
    assert_equal "dog", cm.suggest("do").first
  end

end
