module Adhocracy
  class MembershipInvitation < ActiveRecord::Base
    include Acceptable

    belongs_to :member, polymorphic: true
    belongs_to :group, polymorphic: true

    validate :no_pending_invitations, on: :create
    validate :no_declined_invitations, on: :create
    validate :not_currently_a_member, on: :create

    private
    def no_pending_invitations
      if self.member.invited_to?(self.group, { pending: true })
        errors[:base] << I18n.t("activerecord.errors.models.membership_invitation.still_pending")
      end
    end

    def no_declined_invitations
      if self.member.invited_to?(self.group, { declined: true })
        errors[:base] << I18n.t("activerecord.errors.models.membership_invitation.already_declined")
      end
    end

    def not_currently_a_member
      if self.member.member_of?(self.group)
        errors[:base] << I18n.t("activerecord.errors.models.membership_invitation.already_a_member")
      end
    end
  end
end
