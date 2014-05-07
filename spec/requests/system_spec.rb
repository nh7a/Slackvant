require 'spec_helper'

describe 'system plugin' do
  it 'lists plugins' do
    post_text '!list'
    expect(response_text).to match /System/
  end

  it 'shows help' do
    post_text '!help system'
    expect(response_text).to eq "!list\n!help [module name]\n"
  end
end
