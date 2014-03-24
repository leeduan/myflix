require 'spec_helper'

describe UserRegistration do
  after { ActionMailer::Base.deliveries.clear }

  def set_successful_charge
    charge = double(:charge, successful?: true)
    allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
  end

  def set_failed_charge
    charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
    allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
  end

  def invalid_user_information_registration
    UserRegistration.new(Fabricate.build(:user, password: '')).register('stripe_token', '')
  end

  def valid_user_information_registration
    UserRegistration.new(Fabricate.build(:user)).register('stripe_token', '')
  end

  describe '#register' do
    context 'with invalid personal information' do
      it 'does not create the user' do
        invalid_user_information_registration
        expect(User.count).to eq(0)
      end

      it 'does not charge the card' do
        expect(StripeWrapper::Charge).to_not receive(:create)
        invalid_user_information_registration
      end

      it 'does not send out email with invalid inputs' do
        invalid_user_information_registration
        message = ActionMailer::Base.deliveries
        expect(message).to eq([])
      end
    end

    context 'with valid personal information but failed charge' do
      it 'does not create the user' do
        set_failed_charge
        valid_user_information_registration
        expect(User.count).to eq(0)
      end

      it 'does not charge the card' do
        expect(StripeWrapper::Charge).to receive(:create)
        set_failed_charge
        result = valid_user_information_registration
        expect(result.error_message).to be_present
      end

      it 'does not send out email with invalid inputs' do
        set_failed_charge
        valid_user_information_registration
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

      def valid_user_registration_with_invitation
        set_successful_charge
        UserRegistration.new(Fabricate.build(:user, email: invitation.recipient_email, invitation: invitation))
          .register('stripe_token', invitation.id)
      end

      it 'does receive handle_invitation' do
        expect_any_instance_of(UserRegistration).to receive(:handle_invitation)
        valid_user_registration_with_invitation
      end

      it 'makes the user follow the sender' do
        valid_user_registration_with_invitation
        expect(User.last.follows?(User.first)).to eq(true)
      end

      it 'makes the inviter follow the user' do
        valid_user_registration_with_invitation
        expect(User.first.follows?(User.last)).to eq(true)
      end

      it 'expires the invitation upon creation of user' do
        valid_user_registration_with_invitation
        expect(Invitation.first.token).to eq(nil)
      end
    end
  end

  describe '#successful?' do
    context 'with invalid personal information' do
      it 'returns false' do
        set_successful_charge
        result = invalid_user_information_registration
        expect(result.successful?).to eq(false)
      end
    end

    context 'with valid personal information but failed charge' do
      it 'returns false' do
        set_failed_charge
        result = valid_user_information_registration
        expect(result.successful?).to eq(false)
      end
    end

    context 'with valid personal information and valid charge' do
      it 'returns true' do
        set_successful_charge
        result = valid_user_information_registration
        expect(result.successful?).to eq(true)
      end
    end
  end
end