FactoryGirl.define do
  factory :adhocracy_membership, :class => 'Adhocracy::Membership',
    aliases: [:membership] do
      member { |a| a.association(:user) }
      group { |a| a.association(:adhoc) }
  end
end
