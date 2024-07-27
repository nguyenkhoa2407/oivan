class ShortLink < ApplicationRecord
  DOMAIN = 'shortlink.com'.freeze # should be in .env file, but for simplicity, it's here

  validates :original_url, presence: true, uniqueness: true
  validates :slug, uniqueness: true, allow_nil: true
  validates :expires_at, presence: true
  validate :original_url_not_malformed

  after_create :generate_slug

  def shortened_url
    "http://shortlink.com/#{slug}"
  end

  private

  def original_url_not_malformed
    begin 
      uri = URI.parse(original_url)
      valid_url = uri.is_a?(URI::HTTP) && uri.host.present?
      errors.add(:original_url, 'is not a valid URL') unless valid_url
    rescue URI::InvalidURIError
      errors.add(:original_url, 'is not a valid URL')
    end
  end

  def generate_slug
    # https://github.com/sqids/sqids-ruby for reference
    sqids = Sqids.new
    update(slug: sqids.encode([id]))
  end
end
