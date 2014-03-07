module Adhocracy
  class MembershipInvitation < ActiveRecord::Base
    include Acceptable
    include Joinable

    belongs_to :member, polymorphic: true
    belongs_to :group, polymorphic: true
  end
end
