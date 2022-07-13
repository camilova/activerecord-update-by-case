class CreateTestModel < ActiveRecord::Migration[7.0]
  def change
    create_table :test_models do |t|
      t.integer :value_1
      t.string :value_2
      t.boolean :value_3
    end
  end
end
