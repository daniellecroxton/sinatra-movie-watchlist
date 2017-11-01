class CreateMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :notes
      t.string :genre
      t.integer :user_id
      t.integer :watched
      t.timestamps null: false
    end
  end
end
