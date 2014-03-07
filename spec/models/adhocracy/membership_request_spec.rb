require 'spec_helper'

module Adhocracy
  describe MembershipRequest do

    context "belongs to" do
      before :each do
        @membership_request = FactoryGirl.build(:membership_request)
      end

      it "a member" do
        expect(@membership_request).to belong_to(:member)
      end

      it "a group" do
        expect(@membership_request).to belong_to(:group)
      end
    end

    it "defaults to pending" do
      membership_request = FactoryGirl.build(:membership_request)
      expect(membership_request.pending).to be true
      expect(membership_request.accepted).to be false
      expect(membership_request.declined).to be false
    end

    context "can be accepted" do
      before :each do
        @user = FactoryGirl.create(:user)
        @adhoc = FactoryGirl.create(:adhoc)
        @membership_request = @user.request_membership_in(@adhoc)
      end

      it "if it is still pending" do
        @membership_request.accept
        expect(@membership_request.pending).to be false
        expect(@membership_request.accepted).to be true
        expect(@membership_request.declined).to be false
      end

      it "but not if it isn't pending" do
        @membership_request.decline
        @membership_request.accept
        expect(@membership_request.pending).to be false
        expect(@membership_request.accepted).to be false
        expect(@membership_request.declined).to be true
      end

      it "which created a membership for the group" do
        @membership_request.accept
        expect(@user.groups).to include @adhoc
      end
    end

    context "can be declined" do
      before :each do
        @user = FactoryGirl.create(:user)
        @adhoc = FactoryGirl.create(:adhoc)
        @membership_request = @user.request_membership_in(@adhoc)
      end

      it "if it is still pending" do
        @membership_request.decline
        expect(@membership_request.pending).to be false
        expect(@membership_request.accepted).to be false
        expect(@membership_request.declined).to be true
      end

      it "but not if it isn't pending" do
        @membership_request.accept
        @membership_request.decline
        expect(@membership_request.pending).to be false
        expect(@membership_request.accepted).to be true
        expect(@membership_request.declined).to be false
      end

      it "which does not create a membership for the group" do
        @membership_request.decline
        expect(@user.groups).to_not include @adhoc
      end
    end

  end
end
