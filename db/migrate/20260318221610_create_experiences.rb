class CreateExperiences < ActiveRecord::Migration[8.1]
  def change
    create_table :experiences do |t|
      t.string :position, null: false
      t.string :company, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.text :description
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
