require 'spec_helper'

describe 'qotd plugin' do
  it 'searches qotd' do
    post_text '!Q'
    expect(response_text).to match /---/
  end
end
