class CreateInviteBuyers < ActiveRecord::Migration[5.2]
  def change
    create_table :invite_buyers do |t|
      t.bigint :item_requests_id
      t.string :email_address
      t.text :name

      t.timestamps
    end
  end
end
