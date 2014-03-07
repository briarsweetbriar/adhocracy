module Adhocracy
  class MembershipAssociation

    attr_accessor :params
    def initialize(params)
      @params = params
    end

    # Creates Methods:
    # list_membership, create_membership, destroy_membership, verify_membership
    # list_membership_request, create_membership_request,
    #   destroy_membership_request, verify_membership_request
    # list_membership_invitation, create_membership_invitation,
    #   destroy_membership_invitation, verify_membership_invitation

    %w(membership membership_request membership_invitation).each do |type|
      %w(list_members_for list_groups_for create destroy verify).each do |action|
        define_method "#{action}_#{type}" do
          send("#{action}", "Adhocracy::#{type.camelize}".constantize)
        end
      end
    end

    private
    def list_members_for(membership_class)
      membership_class.where(group: params[:group]).includes(:member).
        collect { |membership| membership.member }
    end

    def list_groups_for(membership_class)
      membership_class.where(member: params[:member]).includes(:group).
        collect { |membership| membership.group }
    end

    def create(membership_class)
      membership_class.create(params)
    end

    def destroy(membership_class)
      membership = membership_class.find_by(params)
      return false if membership.nil?
      membership.destroy
    end

    def verify(membership_class)
      membership_class.where(params).exists?
    end
  end
end
