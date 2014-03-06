class CreateAdhocracyMemberships < ActiveRecord::Migration
  def change
    create_table :adhocracy_memberships do |t|
      t.string :member_type
      t.integer :member_id
      t.string :group_type
      t.integer :group_id

      t.timestamps
    end

    add_index :adhocracy_memberships,
      [:member_id, :member_type],
      name: "adhocracy_memberships_on_member"
    add_index :adhocracy_memberships,
      [:group_id, :group_type],
      name: "adhocracy_memberships_on_group"
  end
end
