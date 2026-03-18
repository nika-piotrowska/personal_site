class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.references :profile, null: false, foreign_key: true
      t.string :title, null: false
      t.string :slug, null: false, index: { unique: true }
      t.text :short_description, null: false
      t.text :description
      t.string :tech_stack
      t.string :repo_url
      t.string :live_url
      t.boolean :featured, null: false, default: false
      t.boolean :published, null: false, default: false
      t.integer :position, null: false

      t.timestamps
    end

    add_index :projects, %i[profile_id position]
  end
end
