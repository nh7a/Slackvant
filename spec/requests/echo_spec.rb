require 'spec_helper'

describe 'echo plugin' do
  it 'returns the text' do
    post_text "!echo Hello"
    expect(response_text).to eq "Hello"
  end
end
