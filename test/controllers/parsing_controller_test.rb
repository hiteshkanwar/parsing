require 'test_helper'

class ParsingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get parsing_index_url
    assert_response :success
  end

end
