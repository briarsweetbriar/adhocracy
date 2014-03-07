class CreateAdhocracyMembershipRequests < ActiveRecord::Migration
  def change
    create_table :adhocracy_membership_requests do |t|
      t.string :member_type
      t.integer :member_id
      t.string :group_type
      t.integer :group_id

      t.boolean :pending, null: false, default: true
      t.boolean :accepted, null: false, default: false
      t.boolean :declined, null: false, default: false

      t.timestamps
    end

    add_index :adhocracy_membership_requests,
      [:member_id, :member_type],
      name: "adhocracy_membership_requests_on_member"
    add_index :adhocracy_memberships,
      [:group_id, :group_type],
      name: "adhocracy_membership_requests_on_group"
  end
end
