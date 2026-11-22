class CreateFeedbackMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :feedback_messages do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :body
      t.string :status, default: "new", null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
