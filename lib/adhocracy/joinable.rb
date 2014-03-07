module Adhocracy
  module Joinable
    extend ActiveSupport::Concern

    included do
      validate :no_pending_joins, on: :create
      validate :no_declined_joins, on: :create
      validate :not_currently_a_member, on: :create
      validate :other_party_has_pending_request, on: :create
    end

    private
    def detect_preexisting_join(state, inverted = false)
      self.member.send(query_symbol(inverted), self.group, { state => true })
    end

    def no_pending_joins
      if detect_preexisting_join(:pending)
        errors[:base] << I18n.t("activerecord.errors.models.membership_#{i18n_string}.still_pending")
      end
    end

    def no_declined_joins
      if detect_preexisting_join(:declined)
        errors[:base] << I18n.t("activerecord.errors.models.membership_#{i18n_string}.already_declined")
      end
    end

    def not_currently_a_member
      if self.member.member_of?(self.group)
        errors[:base] << I18n.t("activerecord.errors.models.membership_#{i18n_string}.already_a_member")
      end
    end

    def other_party_has_pending_request
      if detect_preexisting_join(:pending, true)
        accept_preexisting_join
        errors[:base] << I18n.t("activerecord.errors.models.membership_#{i18n_string}.other_party_had_pending_request")
      end
    end

    def i18n_string
      return case self.class.name
        when "Adhocracy::MembershipInvitation" then "invitation"
        when "Adhocracy::MembershipRequest" then "request"
      end
    end

    def query_symbol(inverted)
      test_class = inverted == false ? self.class.name : inverted_class
      return case test_class
        when "Adhocracy::MembershipInvitation" then :invited_to?
        when "Adhocracy::MembershipRequest" then :requested_membership_in?
      end
    end

    def inverted_class
      return case self.class.name
      when "Adhocracy::MembershipInvitation"
        "Adhocracy::MembershipRequest"
      when "Adhocracy::MembershipRequest"
        "Adhocracy::MembershipInvitation"
      end
    end

    def accept_preexisting_join
      inverted_class.constantize.where(member: self.member, group: self.group).
        first.accept
    end
  end
end