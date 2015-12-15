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

end
