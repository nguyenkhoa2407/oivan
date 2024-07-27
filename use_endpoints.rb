require 'net/http'
require 'json'


def encode_url(url)
  puts "\nEncoding URL: #{url}"
  api = URI("http://localhost:3000/url/encode")
  res = Net::HTTP.post_form(api, { url: url })
  data = JSON.parse(res.body)

  if res.is_a?(Net::HTTPSuccess)
    puts "Shortened URL: #{data["shortened_url"]}"
  else
    puts "Error: #{data["error"]} - Status code: #{res.code}"
  end
end


def decode_url(url)
  puts "\nDecoding URL: #{url}"
  api = URI("http://localhost:3000/url/decode")
  res = Net::HTTP.post_form(api, { url: url })
  data = JSON.parse(res.body)

  if res.is_a?(Net::HTTPSuccess)
    puts "Original URL: #{data["original_url"]}"
  else
    puts "Error: #{data['error']} - Status code: #{res.code}"
  end
end

encode_url("https://www.google.com")
decode_url("http://shortlink.com/abc123")

encode_url("invalid.url")
decode_url("http://shortlink.com/OI")