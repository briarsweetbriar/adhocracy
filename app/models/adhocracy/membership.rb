module Adhocracy
  class Membership < ActiveRecord::Base
    belongs_to :member, polymorphic: true
    belongs_to :group, polymorphic: true

    validate :membership_is_unique
    before_destroy :member_is_not_only_officer

    def is_necessary_officer?
      officer? && group.officers.length <= 1
    end

    private
    def membership_is_unique
      if self.member.member_of?(self.group)
        errors[:base] << I18n.t("activerecord.errors.models.membership.not_unique")
      end
    end

    def member_is_not_only_officer
      return false if is_necessary_officer?
    end
  end
end