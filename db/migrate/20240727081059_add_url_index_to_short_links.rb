class AddUrlIndexToShortLinks < ActiveRecord::Migration[7.1]
  def change
    add_index :short_links, :original_url, unique: true
    add_index :short_links, :slug, unique: true
  end
end
