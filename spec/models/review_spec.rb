require 'spec_helper'

describe Review do
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:description) }
  it { should belong_to(:user) }
  it { should belong_to(:video) }
end