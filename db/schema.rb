# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_13_052728) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "test_models", force: :cascade do |t|
    t.integer "value_1"
    t.string "value_2"
    t.boolean "value_3"
    t.integer "value_4"
  end

end
