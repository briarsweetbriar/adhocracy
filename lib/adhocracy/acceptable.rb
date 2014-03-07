module Adhocracy
  module Acceptable
    extend ActiveSupport::Concern

    def accept
      if pending?
        member.join_group(group)
        update_attributes(pending: false, accepted: true, declined: false)
      end
    end

    def decline
      if pending?
        update_attributes(pending: false, accepted: false, declined: true)
      end
    end
  end
end