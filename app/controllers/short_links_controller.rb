class ShortLinksController < ApplicationController
  def encode
    short_link = ShortLink.find_or_create_by(original_url: url_param) do |sl|
      sl.expires_at = Time.now + 1.year
    end

    if short_link.errors.any?
      render json: { error: short_link.errors.full_messages.join(', ') }, status: :bad_request
    else
      render json: { shortened_url: short_link.shortened_url }
    end
  end


  def decode
    if !valid_decode_url?
      render json: { error: 'Invalid URL' }, status: :bad_request
      return
    end
    
    slug = url_param.split('/').last
    short_link = ShortLink.find_by(slug: slug)

    if short_link.nil?
      render json: { error: 'Link not found' }, status: :not_found
    else
      render json: { original_url: short_link.original_url }
    end
  end 

  private
    # Only allow a list of trusted parameters through.
    def url_param
      params.require(:url)
    end

    def valid_decode_url?
      api_domain = ShortLink::DOMAIN
      begin 
        uri = URI.parse(url_param)
        uri.is_a?(URI::HTTP) && uri.host.present? && uri.host == api_domain
      rescue URI::InvalidURIError
        false
      end
    end
end
