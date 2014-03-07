require 'spec_helper'

module Adhocracy
  describe ActsAsGroup do

    context "has many" do
      before :each do
        @adhoc = FactoryGirl.build(:adhoc)
      end

      it "memberships" do
        expect(@adhoc).to have_many(:memberships)
      end

      it "membership requests" do
        expect(@adhoc).to have_many(:membership_requests)
      end

      it "membership invitations" do
        expect(@adhoc).to have_many(:membership_invitations)
      end
    end

    context "produces a list" do
      before :each do
        @adhoc = FactoryGirl.create(:adhoc)
        @user1 = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        @user3 = FactoryGirl.create(:user)
        @user4 = FactoryGirl.create(:user)
        @user5 = FactoryGirl.create(:user)
        @adhoc.add_member(@user1)
        @adhoc.add_member(@user3)
        @adhoc.invite_member(@user4)
        @user5.request_membership_in(@adhoc)
      end

      it "including all active members" do
        expect(@adhoc.members).to include @user1, @user3
      end

      it "excluding non-active members" do
        expect(@adhoc.members).to_not include @user2, @user4, @user5
      end

      it "including all invited members" do
        expect(@adhoc.invited_members).to include @user4
      end

      it "excluding non-invited members" do
        expect(@adhoc.invited_members).to_not include @user1, @user2, @user3,
          @user5
      end

      it "including all requested members" do
        expect(@adhoc.membership_requests).to include @user5
      end

      it "excluding non-requests members" do
        expect(@adhoc.membership_requests).to_not include @user1, @user2,
          @user3, @user4
      end
    end

    context "checks" do
      before :each do
        @adhoc = FactoryGirl.create(:adhoc)
        @user = FactoryGirl.create(:user)
      end

      it "if a membership exists and returns true if it does" do
        @adhoc.add_member(@user)
        expect(@adhoc.has_member?(@user)).to be true
      end

      it "if a membership exists and returns false if it does not" do
        expect(@adhoc.has_member?(@user)).to be false
      end

      it "if an invitation exists and returns true if it does" do
        @adhoc.invite_member(@user)
        expect(@adhoc.invited?(@user)).to be true
      end

      it "if an invitation exists and returns false if it does not" do
        expect(@adhoc.invited?(@user)).to be false
      end

      it "if a pending invitation exists and returns true if it does" do
        @adhoc.invite_member(@user)
        expect(@adhoc.invited?(@user, { pending: true })).to be true
      end

      it "if a pending invite exists and returns false if it does not" do
        invitation = @adhoc.invite_member(@user)
        invitation.accept
        expect(@adhoc.invited?(@user, { pending: true })).to be false
      end

      it "if a request exists and returns true if it does" do
        @user.request_membership_in(@adhoc)
        expect(@adhoc.recieved_request_from?(@user)).to be true
      end

      it "if a request exists and returns false if it does not" do
        expect(@adhoc.recieved_request_from?(@user)).to be false
      end

      it "if a pending request exists and returns true if it does" do
        @user.request_membership_in(@adhoc)
        expect(@adhoc.recieved_request_from?(@user, { pending: true })).
          to be true
      end

      it "if a pending request exists and returns false if it does not" do
        request = @user.request_membership_in(@adhoc)
        request.accept
        expect(@adhoc.recieved_request_from?(@user, { pending: true })).
          to be false
      end
    end

    context "handles prospective members by" do
      before :each do
        @adhoc = FactoryGirl.create(:adhoc)
        @user = FactoryGirl.create(:user)
      end

      it "creating memberships" do
        @adhoc.add_member(@user)
        expect(@adhoc.members).to include @user
      end

      it "not creating duplicate memberships" do
        @adhoc.add_member(@user)
        expect(@adhoc.add_member(@user).valid?).to be false
      end

      it "inviting members" do
        @adhoc.invite_member(@user)
        expect(@adhoc.invited_members).to include @user
      end

      it "not allowing new invites while one is still pending" do
        @adhoc.invite_member(@user)
        expect(@adhoc.invite_member(@user).valid?).to be false
      end

      it "not allowing new invites if a previous one was declined" do
        membership_request = @adhoc.invite_member(@user)
        membership_request.decline
        expect(@adhoc.invite_member(@user).valid?).to be false
      end

      it "not allowing new invites if already a member" do
        @adhoc.add_member(@user)
        expect(@adhoc.invite_member(@user).valid?).to be false
      end

      it "accepting invited members if they've requested membership" do
        @user.request_membership_in(@adhoc)
        expect(@adhoc.invite_member(@user).valid?).to be false
        expect(@adhoc.members).to include @user
      end
    end

    context "destroys memberships" do
      before :each do
        @adhoc = FactoryGirl.create(:adhoc)
        @user = FactoryGirl.create(:user)
      end

      it "if the membership exists" do
        @adhoc.add_member(@user)
        @adhoc.remove_member(@user)
        expect(@adhoc.members).to_not include @user
      end

      it "but returns false if the membership does not exist" do
        expect(@adhoc.remove_member(@user)).to be false
      end
    end

  end
end
