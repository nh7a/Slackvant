require 'spec_helper'

describe 'vant' do
  it 'does not die when there is no text= parameter' do
    post '/'
    expect(response_text).to eq ""
  end
end
