class ShortLink < ApplicationRecord
  DOMAIN = 'shortlink.com'.freeze # should be in .env file, but for simplicity, it's here

  validates :original_url, presence: true, uniqueness: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :slug, uniqueness: true, allow_nil: true

  after_create :generate_slug

  def shortened_url
    "http://shortlink.com/#{slug}"
  end

  def generate_slug
    # https://github.com/sqids/sqids-ruby for reference
    sqids = Sqids.new
    update(slug: sqids.encode([id]))
  end
end
