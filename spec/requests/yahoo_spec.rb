require 'spec_helper'

describe 'yahoo plugin' do
  it 'shows yahoo stock' do
    post_text '!yf AAPL'
    expect(response_text).to match %r[chart\.finance\.yahoo\.com]
  end

  it 'shows yahoo stock with $' do
    post_text '$AAPL'
    expect(response_text).to match %r[chart\.finance\.yahoo\.com/z\?s=AAPL]
  end
end
