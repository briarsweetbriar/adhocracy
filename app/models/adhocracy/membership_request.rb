module Adhocracy
  class MembershipRequest < ActiveRecord::Base
    include Acceptable

    belongs_to :member, polymorphic: true
    belongs_to :group, polymorphic: true

    validate :no_pending_requests, on: :create
    validate :no_declined_requests, on: :create
    validate :not_currently_a_member, on: :create

    private
    def no_pending_requests
      if self.member.requested_membership_in?(self.group, { pending: true })
        errors[:base] << I18n.t("activerecord.errors.models.membership_request.still_pending")
      end
    end

    def no_declined_requests
      if self.member.requested_membership_in?(self.group, { declined: true })
        errors[:base] << I18n.t("activerecord.errors.models.membership_request.already_declined")
      end
    end

    def not_currently_a_member
      if self.member.member_of?(self.group)
        errors[:base] << I18n.t("activerecord.errors.models.membership_request.already_a_member")
      end
    end
  end
end
