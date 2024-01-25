class AddSendColumnAndEmailCustomFields < ActiveRecord::Migration[5.2]
  def self.up
    unless column_exists? :journals, :send_to_client
      add_column :journals, :send_to_client, :boolean, :default => false
    end
    t = CustomField.new(
      :name => 'Email To',
      :editable => true,
      :field_format => 'string',
      :is_for_all => true,
      :description => 'Who to email case updates to at the client side'
    )
    t.type = 'IssueCustomField' # cannot be set by mass assignement!
    t.save

    cc = CustomField.new(
      :name => 'Email CC',
      :editable => true,
      :field_format => 'string',
      :is_for_all => true,
      :description => 'Who to CC email case updates to at the client side'
    )
    cc.type = 'IssueCustomField' # cannot be set by mass assignement!
    cc.save

    s = CustomField.new(
      :name => 'Email Subject',
      :editable => true,
      :field_format => 'string',
      :is_for_all => true,
      :description => 'The subject to use when emailing the client'
    )
    s.type = 'IssueCustomField' # cannot be set by mass assignement!
    s.save

    for tracker in [4, 9, 13] do
      execute "INSERT INTO custom_fields_trackers (custom_field_id, tracker_id) VALUES (#{t.id},#{tracker})"
      execute "INSERT INTO custom_fields_trackers (custom_field_id, tracker_id) VALUES (#{cc.id},#{tracker})"
      execute "INSERT INTO custom_fields_trackers (custom_field_id, tracker_id) VALUES (#{s.id},#{tracker})"
    end

  end

  def self.down
    remove_column :journals, :send_to_client

    for field in ['Email To', 'Email CC', 'Email Subject'] do
      c = CustomField.find_by_name(field)
      execute "DELETE FROM custom_fields_trackers WHERE custom_field_id=#{c.id}"
      c.delete
    end
  end
end
