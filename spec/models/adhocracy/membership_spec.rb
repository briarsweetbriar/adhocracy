require 'spec_helper'

module Adhocracy
  describe Membership do

    context "belongs to" do
      before :each do
        @membership = FactoryGirl.build(:membership)
      end

      it "a member" do
        expect(@membership).to belong_to(:member)
      end

      it "a group" do
        expect(@membership).to belong_to(:group)
      end
    end

  end
end
