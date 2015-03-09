require 'spec_helper'

RSpec.describe Voting::User do
  it { expect(subject).to have_property(:id) }
  it { expect(subject).to have_property(:username) }
  it { expect(subject).to have_property(:crypt_pass) }
  it { expect(subject).to have_property(:salt) }
  it { expect(subject).to have_property(:created_at) }
  it { expect(subject).to have_property(:updated_at) }
end
