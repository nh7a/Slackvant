require 'spec_helper'

describe 'google plugin' do
  it 'searches google video' do
    post_text '!Gv avril hello kitty'
    expect(response_text).to match /youtube/
  end

  it 'searches google image' do
    post_text '!Gi bro'
    expect(response_text).to match /\.jpg/
  end
end
