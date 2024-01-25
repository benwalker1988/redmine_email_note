require 'redmine'
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"
require 'email_note_hooks'

Redmine::Plugin.register :redmine_email_note do
  name 'Redmine email note plugin'
  author 'Ben Walker'
  description 'Redmine Email Note'
  version '0.0.1'
  requires_redmine :version_or_higher => '5.0.0'
  project_module :issue_tracking do
    permission :treat_user_as_supportclient, {}
  end
end
