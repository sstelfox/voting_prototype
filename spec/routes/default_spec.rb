require 'spec_helper'

RSpec.describe 'default routes' do
  it 'should have a default route' do
    get '/'
    expect(last_response).to be_ok
  end
end