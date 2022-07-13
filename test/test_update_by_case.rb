# frozen_string_literal: true

require "test_helper"

class TestUpdateByCase < GemTest

  def test_that_it_has_a_version_number
    refute_nil ::UpdateByCase::VERSION
  end

  def test_update_based_on_id_by_default
    cases = { value_1: { 1 => 2, 2 => 3, 3 => 4 } }
    assert TestModel.pluck(:value_1) == [1, 2, 3]
    TestModel.update_by_case!(cases)
    assert TestModel.pluck(:value_1) == [2, 3, 4]
  end

  def test_update_based_on_custom_symbol_case_field
    cases = { value_1: { value_2: { one: 11, two: 12, three: 13 } } }
    assert TestModel.pluck(:value_2) == %w(one two three)
    TestModel.update_by_case!(cases)
    assert TestModel.pluck(:value_1) == [11, 12, 13]
  end

  def test_update_based_on_custom_string_case_field
    cases = { value_1: { value_2: { 'one' => 6, 'two' => 7, 'three' => 8 } } }
    assert TestModel.pluck(:value_2) == %w(one two three)
    TestModel.update_by_case!(cases)
    assert TestModel.pluck(:value_1) == [6, 7, 8]
  end

  def test_update_based_on_custom_numeric_case_field
    cases = { value_2: { value_1: { 1 => 'x', 2 => 'y', 3 => 'z' } } }
    assert TestModel.pluck(:value_2) != %w(x y z)
    TestModel.update_by_case!(cases)
    assert TestModel.pluck(:value_2) == %w(x y z)
  end

  def test_update_with_where
    cases = { value_1: { 1 => 2, 2 => 3, 3 => 4 }, where: 'id <= 2' }
    assert TestModel.order(:id).pluck(:value_1) == [1, 2, 3]
    TestModel.update_by_case!(cases)
    assert TestModel.order(:id).pluck(:value_1) == [2, 3, 3]
  end

  def test_update_with_only_one_value_for_all
    cases = { value_1: 0 }
    assert TestModel.order(:id).pluck(:value_1) == [1, 2, 3]
    TestModel.update_by_case!(cases)
    assert TestModel.order(:id).pluck(:value_1) == [0, 0, 0]
  end

end
