module Adhocracy
  module ActsAsGroup
    extend ActiveSupport::Concern
 
    module ClassMethods
      def acts_as_group(options = {})

        has_many :memberships, as: :group, class_name: "Adhocracy::Membership"
        has_many :membership_invitations, as: :group,
          class_name: "Adhocracy::MembershipInvitation"
        has_many :membership_requests, as: :group,
          class_name: "Adhocracy::MembershipRequest"
        has_many :officer_memberships, -> { where officer: true }, as: :group,
          class_name: "Adhocracy::Membership"

        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def members
        MembershipAssociation.new(group: self).list_members_for_membership
      end

      def officers
        Adhocracy::Membership.where(group: self, officer: true).
          includes(:member).collect { |membership| membership.member }
      end

      def invited_members
        MembershipAssociation.new(group: self).
          list_members_for_membership_invitation
      end

      def membership_requests
        MembershipAssociation.new(group: self).
          list_members_for_membership_request
      end

      def add_member(member)
        MembershipAssociation.new(member: member, group: self).
          create_membership
      end

      def add_officer(member)
        membership = Adhocracy::Membership.where(member: member, group: self).
          first_or_initialize(officer: true)
        if membership.new_record?
          membership.save
        else
          return false if membership.officer?
          membership.update_column(:officer, true)
        end
        return membership
      end

      def demote_officer(member)
        membership = Adhocracy::Membership.find_by(member: member, group: self)
        return false if !membership.present? || !membership.officer?
        return membership.update_column(:officer, false)
      end

      def invite_member(member)
        MembershipAssociation.new(member: member, group: self).
          create_membership_invitation
      end

      def remove_member(member)
        MembershipAssociation.new(member: member, group: self).
          destroy_membership
      end

      def has_member?(member)
        MembershipAssociation.new(member: member, group: self).verify_membership
      end

      def has_officer?(member)
        Adhocracy::Membership.where(member: member, group: self,
          officer: true).exists?
      end

      def invited?(member, params = {})
        params.merge!({ member: member, group: self })
        MembershipAssociation.new(params).verify_membership_invitation
      end

      def recieved_request_from?(member, params = {})
        params.merge!({ member: member, group: self })
        MembershipAssociation.new(params).verify_membership_request
      end
    end
  end
end

ActiveRecord::Base.send :include, Adhocracy::ActsAsGroup