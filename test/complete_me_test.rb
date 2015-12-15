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


end
