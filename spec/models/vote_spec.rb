require 'spec_helper'

RSpec.describe Voting::Vote do
  it { expect(subject).to have_property(:id) }
  it { expect(subject).to have_property(:email) }
  it { expect(subject).to have_property(:pass) }
  it { expect(subject).to have_property(:used) }

  it { expect(subject).to belong_to(:question) }

  it { expect(subject).to have_many(:vas) }
  it { expect(subject).to have_many(:answers).through(:vas) }
end
