require "test_helper"

class ShortLinksControllerTest < ActionDispatch::IntegrationTest
  example_valid_url = "https://www.google.com"
  example_invalid_url = "invalid.url"
  example_nonexistent_url = "https://www.shortlink.com/nonexistent-url"

  ## ENCODE TESTS

  test "should encode valid url" do
    post "/url/encode", params: { url: example_valid_url }, as: :json
    assert_response :success

    shortened_url = ShortLink.find_by(original_url: example_valid_url).shortened_url
    response_url = JSON.parse(@response.body)["shortened_url"]
    assert_equal(shortened_url, response_url)
  end

  test "should return the same shortened url for the same original url" do
    post "/url/encode", params: { url: example_valid_url }, as: :json
    assert_response :success

    first_response_url = JSON.parse(@response.body)["shortened_url"]

    post "/url/encode", params: { url: example_valid_url }, as: :json
    assert_response :success

    second_response_url = JSON.parse(@response.body)["shortened_url"]
    assert_equal(first_response_url, second_response_url)
  end

  test "should not encode valid url" do
    post "/url/encode", params: { url: example_invalid_url }, as: :json
    assert_response :bad_request

    invalid_link = ShortLink.find_by(original_url: example_invalid_url)
    assert_nil(invalid_link)
  end


  ## DECODE TESTS

  test "should decode valid url" do
    short_link = ShortLink.create(
      original_url: example_valid_url,
      expires_at: Time.now + 1.year
    )
    post "/url/decode", params: { url: short_link.shortened_url }, as: :json
    assert_response :success

    response_url = JSON.parse(@response.body)["original_url"]
    assert_equal(example_valid_url, response_url)
  end

  test "should not decode invalid url" do
    post "/url/decode", params: { url: example_invalid_url }, as: :json
    assert_response :bad_request
  end

end
