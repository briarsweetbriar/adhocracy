module Adhocracy
  module ActsAsMember
    extend ActiveSupport::Concern
 
    module ClassMethods
      def acts_as_member(options = {})

        has_many :memberships, as: :member, class_name: "Adhocracy::Membership"
        has_many :membership_invitations, as: :member,
          class_name: "Adhocracy::MembershipInvitation"
        has_many :membership_requests, as: :member,
          class_name: "Adhocracy::MembershipRequest"
        has_many :officer_memberships, -> { where officer: true }, as: :member,
          class_name: "Adhocracy::Membership"

        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def groups
        MembershipAssociation.new(member: self).list_groups_for_membership
      end

      def administrations
        Adhocracy::Membership.where(member: self, officer: true).
          includes(:group).collect { |membership| membership.group }
      end

      def group_invitations
        MembershipAssociation.new(member: self).
          list_groups_for_membership_invitation
      end

      def membership_requests
        MembershipAssociation.new(member: self).
          list_groups_for_membership_request
      end

      def join_group(group)
        MembershipAssociation.new(member: self, group: group).create_membership
      end

      def promote(group)
        membership = Adhocracy::Membership.where(member: self, group: group).
          first_or_initialize(officer: true)
        if membership.new_record?
          membership.save
        else
          return false if membership.officer?
          membership.update_column(:officer, true)
        end
        return membership
      end

      def demote(member)
        membership = Adhocracy::Membership.find_by(member: self, group: member)
        return false if !membership.present? || !membership.officer?
        return membership.update_column(:officer, false)
      end

      def request_membership_in(group)
        MembershipAssociation.new(member: self, group: group).
          create_membership_request
      end

      def leave_group(group)
        MembershipAssociation.new(member: self, group: group).destroy_membership
      end

      def member_of?(group)
        MembershipAssociation.new(member: self, group: group).verify_membership
      end

      def officer_of?(group)
        Adhocracy::Membership.where(member: self, group: group,
          officer: true).exists?
      end

      def invited_to?(group, params = {})
        params.merge!({ member: self, group: group })
        MembershipAssociation.new(params).verify_membership_invitation
      end

      def requested_membership_in?(group, params = {})
        params.merge!({ member: self, group: group })
        MembershipAssociation.new(params).verify_membership_request
      end
    end
  end
end

ActiveRecord::Base.send :include, Adhocracy::ActsAsMember