require 'spec_helper'

describe UserRegistration do
  after { ActionMailer::Base.deliveries.clear }

  describe '#register' do
    context 'with invalid personal information' do
      it 'does not create the user' do
        UserRegistration.new(Fabricate.build(:user, password: '')).register('stripe_token', '')
        expect(User.count).to eq(0)
      end

      it 'does not charge the card' do
        expect(StripeWrapper::Charge).to_not receive(:create)
        UserRegistration.new(Fabricate.build(:user, password: '')).register('stripe_token', '')
      end

      it 'does not send out email with invalid inputs' do
        UserRegistration.new(Fabricate.build(:user, password: '')).register('stripe_token', '')
        message = ActionMailer::Base.deliveries
        expect(message).to eq([])
      end
    end

    context 'with valid personal information but failed charge' do
      it 'does not create the user' do
        set_failed_charge
        UserRegistration.new(Fabricate.build(:user)).register('stripe_token', '')
        expect(User.count).to eq(0)
      end

      it 'does not charge the card' do
        expect(StripeWrapper::Charge).to receive(:create)
        set_failed_charge
        result = UserRegistration.new(Fabricate.build(:user)).register('stripe_token', '')
        expect(result.error_message).to be_present
      end

      it 'does not send out email with invalid inputs' do
        set_failed_charge
        UserRegistration.new(Fabricate.build(:user)).register('stripe_token', '')
        message = ActionMailer::Base.deliveries
        expect(message).to eq([])
      end
    end

    context 'with valid personal information and valid charge' do
      before do
        set_successful_charge
        UserRegistration.new(
          Fabricate.build(:user, email: 'hello@leeduan.com', full_name: 'Lee Duan')
        ).register('stripe_token', '')
      end

      it 'creates the user' do
        expect(User.count).to eq(1)
      end

      it 'sends out the email with valid inputs' do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it 'sends out the email to the right recipient with valid inputs' do
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(['hello@leeduan.com'])
      end

      it 'sends the email containing the user name with valid inputs' do
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include('Lee Duan')
      end
    end
  end

  describe '#handle_invitation' do
    let(:invitation_token) { Fabricate(:invitation, sender: Fabricate(:user)).id }

    context 'with invalid personal information' do
      it 'does not receive handle_invitation' do
        set_successful_charge
        expect_any_instance_of(UserRegistration).to_not receive(:handle_invitation)
        UserRegistration.new(Fabricate.build(:user, password: '')).register('stripe_token', invitation_token)
      end
    end

    context 'with valid personal information but invalid charge' do
      it 'does not receive handle_invitation' do
        set_failed_charge
        expect_any_instance_of(UserRegistration).to_not receive(:handle_invitation)
        UserRegistration.new(Fabricate.build(:user)).register('stripe_token', invitation_token)
      end
    end

    context 'with valid personal information and valid charge' do
      let(:user) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, sender: user) }

      it 'does receive handle_invitation' do
        expect_any_instance_of(UserRegistration).to receive(:handle_invitation)
        set_successful_charge
        UserRegistration.new(Fabricate.build(:user, email: invitation.recipient_email, invitation: invitation))
          .register('stripe_token', invitation.id)
      end

      it 'makes the user follow the sender' do
        set_successful_charge
        UserRegistration.new(Fabricate.build(:user, email: invitation.recipient_email, invitation: invitation))
          .register('stripe_token', invitation.id)
        expect(User.last.follows?(User.first)).to eq(true)
      end

      it 'makes the inviter follow the user' do
        set_successful_charge
        UserRegistration.new(Fabricate.build(:user, email: invitation.recipient_email, invitation: invitation))
          .register('stripe_token', invitation.id)
        expect(User.first.follows?(User.last)).to eq(true)
      end

      it 'expires the invitation upon creation of user' do
        set_successful_charge
        UserRegistration.new(Fabricate.build(:user, email: invitation.recipient_email, invitation: invitation))
          .register('stripe_token', invitation.id)
        expect(Invitation.first.token).to eq(nil)
      end
    end
  end

  describe '#successful?' do
    context 'with invalid personal information' do
      it 'returns false' do
        set_successful_charge
        result = UserRegistration.new(Fabricate.build(:user, password: '')).register('stripe_token', '')
        expect(result.successful?).to eq(false)
      end
    end

    context 'with valid personal information but failed charge' do
      it 'returns false' do
        set_failed_charge
        result = UserRegistration.new(Fabricate.build(:user)).register('stripe_token', '')
        expect(result.successful?).to eq(false)
      end
    end

    context 'with valid personal information and valid charge' do
      it 'returns true' do
        set_successful_charge
        result = UserRegistration.new(Fabricate.build(:user)).register('stripe_token', '')
        expect(result.successful?).to eq(true)
      end
    end
  end
end