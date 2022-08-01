require 'rails_helper'

RSpec.describe Tea, type: :model do 
  describe 'relationships' do 
    it { should have_many :tea_subs }
    it { should have_many(:subscriptions).through(:tea_subs) }
  end 
end 