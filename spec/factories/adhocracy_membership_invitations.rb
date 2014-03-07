FactoryGirl.define do
  factory :adhocracy_membership_invitation,
    :class => 'Adhocracy::MembershipInvitation',
    aliases: [:membership_invitation] do
      member { |a| a.association(:user) }
      group { |a| a.association(:adhoc) }
  end
end
