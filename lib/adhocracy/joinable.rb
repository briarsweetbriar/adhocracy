module Adhocracy
  module Joinable
    extend ActiveSupport::Concern

    included do
      validate :no_pending_joins, on: :create
      validate :no_declined_joins, on: :create
      validate :not_currently_a_member, on: :create
    end

    private
    def no_pending_joins
      if self.member.send(query_symbol, self.group, { pending: true })
        errors[:base] << I18n.t("activerecord.errors.models.membership_#{i18n_string}.still_pending")
      end
    end

    def no_declined_joins
      if self.member.send(query_symbol, self.group, { declined: true })
        errors[:base] << I18n.t("activerecord.errors.models.membership_#{i18n_string}.already_declined")
      end
    end

    def not_currently_a_member
      if self.member.member_of?(self.group)
        errors[:base] << I18n.t("activerecord.errors.models.membership_#{i18n_string}.already_a_member")
      end
    end

    def i18n_string
      self.class == Adhocracy::MembershipInvitation ? "invitation" : "request"
    end

    def query_symbol
      if self.class == Adhocracy::MembershipInvitation
        :invited_to?
      else 
        :requested_membership_in?
      end
    end
  end
end