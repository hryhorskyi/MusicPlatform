# frozen_string_literal: true

class HelloWorld
  def self.call
    'Hello world!'
  end
end

RSpec.describe 'HelloWorld' do
  it "returns 'Hello world!'" do
    expect(HelloWorld.call).to eq('Hello world!')
  end
end
