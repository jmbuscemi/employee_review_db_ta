require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'development.sqlite3'
)

class ReviewsMigration < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :department_id
      t.string :name
      t.decimal :salary, precision: 10, scale: 2
      t.string :phone
      t.string :email
      t.boolean :satisfactory, default: true

      t.timestamps null: false
    end

    create_table :departments do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :reviews do |t|
      t.integer :employee_id
      t.text :review

      t.timestamps null: false
    end
  end
end
