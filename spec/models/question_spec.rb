require 'spec_helper'

RSpec.describe Voting::Question do
  it { expect(subject).to have_property(:id) }
  it { expect(subject).to have_property(:closed) }
  it { expect(subject).to have_property(:text) }

  it { expect(subject).to have_many(:answers) }
  it { expect(subject).to have_many(:votes) }
end
