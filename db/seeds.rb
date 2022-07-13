require_relative '../models/test_model'

[
  { id: 1, value_1: 1, value_2: 'one', value_3: true },
  { id: 2, value_1: 2, value_2: 'two', value_3: false },
  { id: 3, value_1: 3, value_2: 'three', value_3: true },
].each do |attributes|
  TestModel.create!(attributes)
end
