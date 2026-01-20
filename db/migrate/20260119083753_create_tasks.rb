class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false 
      t.integer :priority, null: false, default: 1  #default to medium priority
      t.integer :status, null: false, default: 0   #default to 'todo'
      t.date :due_date

      t.timestamps
    end

    add_index :tasks, [:user_id, :status]
    add_index :tasks, [:user_id, :priority]
    add_index :tasks, [:user_id, :due_date]
  end
end
