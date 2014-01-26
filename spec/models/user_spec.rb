require 'spec_helper'

describe User do
  it { should respond_to(:email) }

  describe 'admin?' do
    it { should respond_to(:admin?) }

    it 'should be true for admin' do
      u = create(:admin)
      expect(u.admin?).to eq(true)
    end

    it 'should be false for simple-user' do
      u = create(:user)
      expect(u.admin?).to eq(false)
    end
  end

  it 'should create simple-user by default' do
    u = User.create(email: 'admin@mail.ru', password: '12345678', password_confirmation: '12345678')
    expect(u.admin?).to eq(false)
  end
end
