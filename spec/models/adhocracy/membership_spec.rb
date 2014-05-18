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

    context "must have at least one officer" do
      before :each do
        @adhoc = FactoryGirl.create(:adhoc)
        @officer_1 = FactoryGirl.create(:user)
        @member = FactoryGirl.create(:user)
        @officer_1_membership = @adhoc.add_officer(@officer_1)
        @member_membership = @adhoc.add_member(@member)
      end

      it "which cannot be removed" do
        @adhoc.remove_member(@officer_1)
        expect(@adhoc.has_officer?(@officer_1)).to be true
      end

      it "which cannot be demoted" do
        @adhoc.demote_officer(@officer_1)
        expect(@adhoc.has_officer?(@officer_1)).to be true
      end

      context "but if there is more than one" do

        before :each do
          @officer_2 = FactoryGirl.create(:user)
          @officer_2_membership = @adhoc.add_officer(@officer_2)
        end

        it "an officer can be removed" do
          @adhoc.remove_member(@officer_1)
          expect(@adhoc.has_officer?(@officer_1)).to be false
        end

        it "an officer can be demoted" do
          @adhoc.demote_officer(@officer_1)
          expect(@adhoc.has_officer?(@officer_1)).to be false
        end
      end
    end

  end
end
