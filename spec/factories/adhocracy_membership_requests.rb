FactoryGirl.define do
  factory :adhocracy_membership_request,
    :class => 'Adhocracy::MembershipRequest',
    aliases: [:membership_request] do
      member { |a| a.association(:user) }
      group { |a| a.association(:adhoc) }
  end
end
