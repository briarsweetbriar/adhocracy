require 'spec_helper'

module Adhocracy
  describe ActsAsMember do

    context "has many" do
      before :each do
        @user = FactoryGirl.build(:user)
      end

      it "memberships" do
        expect(@user).to have_many(:memberships)
      end

      it "membership requests" do
        expect(@user).to have_many(:membership_requests)
      end

      it "membership invitations" do
        expect(@user).to have_many(:membership_invitations)
      end
    end

    context "produces a list" do
      before :each do
        @user = FactoryGirl.create(:user)
        @adhoc1 = FactoryGirl.create(:adhoc)
        @adhoc2 = FactoryGirl.create(:adhoc)
        @adhoc3 = FactoryGirl.create(:adhoc)
        @adhoc4 = FactoryGirl.create(:adhoc)
        @adhoc5 = FactoryGirl.create(:adhoc)
        @user.join_group(@adhoc1)
        @user.join_group(@adhoc3)
        @adhoc4.invite_member(@user)
        @user.request_membership_in(@adhoc5)
      end

      it "including all joined groups" do
        expect(@user.groups).to include @adhoc1, @adhoc3
      end

      it "excluding non-joined groups" do
        expect(@user.groups).to_not include @adhoc2, @adhoc4, @adhoc5
      end

      it "including all invited groups" do
        expect(@user.group_invitations).to include @adhoc4
      end

      it "excluding non-invited groups" do
        expect(@user.group_invitations).to_not include @adhoc1, @adhoc2,
          @adhoc3, @adhoc5
      end

      it "including all requested groups" do
        expect(@user.membership_requests).to include @adhoc5
      end

      it "excluding non-requested groups" do
        expect(@user.membership_requests).to_not include @adhoc1, @adhoc2,
          @adhoc3, @adhoc4
      end
    end

    context "checks" do
      before :each do
        @adhoc = FactoryGirl.create(:adhoc)
        @user = FactoryGirl.create(:user)
      end

      it "if a membership exists and returns true if it does" do
        @user.join_group(@adhoc)
        expect(@user.member_of?(@adhoc)).to be true
      end

      it "if a membership exists and returns false if it does not" do
        expect(@user.member_of?(@adhoc)).to be false
      end

      it "if an invitation exists and returns true if it does" do
        @adhoc.invite_member(@user)
        expect(@user.invited_to?(@adhoc)).to be true
      end

      it "if an invitation request exists and returns false if it does not" do
        expect(@user.invited_to?(@adhoc)).to be false
      end

      it "if a pending invitation exists and returns true if it does" do
        @adhoc.invite_member(@user)
        expect(@user.invited_to?(@adhoc, { pending: true })).to be true
      end

      it "if a pending invite exists and returns false if it does not" do
        invitation = @adhoc.invite_member(@user)
        invitation.accept
        expect(@user.invited_to?(@adhoc, { pending: false })).to be true
      end

      it "if a request exists and returns true if it does" do
        @user.request_membership_in(@adhoc)
        expect(@user.requested_membership_in?(@adhoc)).to be true
      end

      it "if a request exists and returns false if it does not" do
        expect(@user.requested_membership_in?(@adhoc)).to be false
      end

      it "if a pending request exists and returns true if it does" do
        @user.request_membership_in(@adhoc)
        expect(@user.requested_membership_in?(@adhoc, { pending: true })).
          to be true
      end

      it "if a pending request exists and returns false if it does not" do
        request = @user.request_membership_in(@adhoc)
        request.accept
        expect(@user.requested_membership_in?(@adhoc, { pending: true })).
          to be false
      end
    end

    context "handles prospective groups by" do
      before :each do
        @adhoc = FactoryGirl.create(:adhoc)
        @user = FactoryGirl.create(:user)
      end

      it "creating memberships" do
        @user.join_group(@adhoc)
        expect(@user.groups).to include @adhoc
      end

      it "not creating duplicate memberships" do
        @user.join_group(@adhoc)
        expect(@user.join_group(@adhoc).valid?).to be false
      end

      it "requesting memberships" do
        @user.request_membership_in(@adhoc)
        expect(@user.membership_requests).to include @adhoc
      end

      it "not allowing new requests while one is still pending" do
        @user.request_membership_in(@adhoc)
        expect(@user.request_membership_in(@adhoc).valid?).to be false
      end

      it "not allowing new requests if a previous one was declined" do
        membership_request = @user.request_membership_in(@adhoc)
        membership_request.decline
        expect(@user.request_membership_in(@adhoc).valid?).to be false
      end

      it "not allowing new requests if already a member" do
        @user.join_group(@adhoc)
        expect(@user.request_membership_in(@adhoc).valid?).to be false
      end
    end

    context "destroys memberships" do
      before :each do
        @adhoc = FactoryGirl.create(:adhoc)
        @user = FactoryGirl.create(:user)
      end

      it "if the membership exists" do
        @user.join_group(@adhoc)
        @user.leave_group(@adhoc)
        expect(@user.groups).to_not include @adhoc
      end

      it "but returns false if the membership does not exist" do
        expect(@user.leave_group(@adhoc)).to be false
      end
    end

  end
end
