class CreateShortLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :short_links do |t|
      t.string :original_url, null: false
      t.string :slug, null: true
      t.datetime :expires_at, null: false
      t.timestamps
    end
  end
end
