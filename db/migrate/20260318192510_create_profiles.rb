class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :headline, null: false
      t.text :bio, null: false
      t.string :location
      t.string :email, null: false
      t.string :github_url
      t.string :linkedin_url

      t.timestamps
    end
  end
end
