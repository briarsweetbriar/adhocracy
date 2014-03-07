require 'spec_helper'

module Adhocracy
  describe MembershipInvitation do

    context "belongs to" do
      before :each do
        @membership_invitation = FactoryGirl.build(:membership_invitation)
      end

      it "a member" do
        expect(@membership_invitation).to belong_to(:member)
      end

      it "a group" do
        expect(@membership_invitation).to belong_to(:group)
      end
    end

    it "defaults to pending" do
      membership_invitation = FactoryGirl.build(:membership_invitation)
      expect(membership_invitation.pending).to be true
      expect(membership_invitation.accepted).to be false
      expect(membership_invitation.declined).to be false
    end

    context "can be accepted" do
      before :each do
        @user = FactoryGirl.create(:user)
        @adhoc = FactoryGirl.create(:adhoc)
        @membership_invitation = @adhoc.invite_member(@user)
      end

      it "if it is still pending" do
        @membership_invitation.accept
        expect(@membership_invitation.pending).to be false
        expect(@membership_invitation.accepted).to be true
        expect(@membership_invitation.declined).to be false
      end

      it "but not if it isn't pending" do
        @membership_invitation.decline
        @membership_invitation.accept
        expect(@membership_invitation.pending).to be false
        expect(@membership_invitation.accepted).to be false
        expect(@membership_invitation.declined).to be true
      end

      it "which creates a membership for the group" do
        @membership_invitation.accept
        expect(@adhoc.members).to include @user
      end
    end

    context "can be declined" do
      before :each do
        @user = FactoryGirl.create(:user)
        @adhoc = FactoryGirl.create(:adhoc)
        @membership_invitation = @adhoc.invite_member(@user)
      end

      it "if it is still pending" do
        @membership_invitation.decline
        expect(@membership_invitation.pending).to be false
        expect(@membership_invitation.accepted).to be false
        expect(@membership_invitation.declined).to be true
      end

      it "but not if it isn't pending" do
        @membership_invitation.accept
        @membership_invitation.decline
        expect(@membership_invitation.pending).to be false
        expect(@membership_invitation.accepted).to be true
        expect(@membership_invitation.declined).to be false
      end

      it "which does not create a membership for the group" do
        @membership_invitation.decline
        expect(@adhoc.members).to_not include @user
      end
    end

  end
end
