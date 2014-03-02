require 'spec_helper'

describe Invitation do
  it { should have_one(:recipient).class_name('User') }
  it { should belong_to(:sender).class_name('User') }
  it { should validate_presence_of(:sender_id) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:recipient_name) }
  it { should validate_presence_of(:recipient_email) }
  it { should validate_uniqueness_of(:recipient_email).scoped_to(:sender_id) }
end