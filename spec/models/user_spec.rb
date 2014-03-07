require 'spec_helper'

describe User do

  let!(:user){ create(:user) }
  let!(:admin){ create(:admin) }
  let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: 12345) }


  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }

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

      context 'without email' do
        let(:auth){ OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '12345', info: {  }) }

        it 'does not crate new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'returns nil' do
          expect(User.find_for_oauth(auth)).to be_nil
        end
      end
    end
  end

  describe '#add_authorization' do
    context 'authorization does not exists' do
      it 'add authorization to user' do
        expect { user.add_authorization(auth) }.to change(user.authorizations, :count).by(1)
      end

      it 'returns true' do
        expect(user.add_authorization(auth)).to be_true
      end
    end

    context 'authorization already exists' do
      context 'authorization associated with current user' do
        before { user.create_authorization(auth) }

        it 'does not create authorization to user' do
          expect { user.add_authorization(auth) }.to_not change(user.authorizations, :count)
        end

        it 'returns true' do
          expect(user.add_authorization(auth)).to be_true
        end
      end

      context 'authorization associated wth other user' do
        let(:other_user) { create(:user, email: 'other@mail.ru') }
        before { other_user.create_authorization(auth) }

        it 'does not create authorization to user' do
          expect { user.add_authorization(auth) }.to_not change(user.authorizations, :count)
        end

        it 'returns false' do
          expect(user.add_authorization(auth)).to be_false
        end
      end
    end
  end
end
