require 'spec_helper'

describe User do

  let!(:user){ create(:user) }
  let!(:admin){ create(:admin) }
  let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: 12345) }


  it { should respond_to(:email) }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe '#admin?' do
    it { should respond_to(:admin?) }

    it 'should be true for admin' do
      expect(admin.admin?).to eq(true)
    end

    it 'should be false for simple-user' do
      expect(user.admin?).to eq(false)
    end
  end

  it 'should create simple-user by default' do
    u = User.create(email: 'admin@mail.ru', password: '12345678', password_confirmation: '12345678')
    expect(u.admin?).to eq(false)
  end

  describe '.find_for_oauth' do
    context 'user already has authorization' do
      it 'return user' do
        user.authorizations.create provider: 'facebook', uid: 12345
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already registered' do
        let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: user.email }) }

        it 'does not create a new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'return user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user not registered' do
        let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: 'newuser@mail.ru' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)

          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
