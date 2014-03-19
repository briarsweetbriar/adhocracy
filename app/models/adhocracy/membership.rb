module Adhocracy
  class Membership < ActiveRecord::Base
    belongs_to :member, polymorphic: true
    belongs_to :group, polymorphic: true

    validate :membership_is_unique

    private
    def membership_is_unique
      if self.member.member_of?(self.group)
        errors[:base] << I18n.t("activerecord.errors.models.membership.not_unique")
      end
    end
  end
end