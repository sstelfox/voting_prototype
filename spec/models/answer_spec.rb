require 'spec_helper'

RSpec.describe Voting::Answer do
  it { expect(subject).to have_property(:id) }
  it { expect(subject).to have_property(:text) }

  it { expect(subject).to have_many(:vas) }
  it { expect(subject).to have_many(:votes).through(:vas) }
end
