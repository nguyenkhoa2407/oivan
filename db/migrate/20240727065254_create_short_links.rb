class CreateShortLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :short_links do |t|
      t.string :original_url
      t.string :short_url
      t.datetime :expires_at
      t.timestamps
    end
  end
end
