class EmailNoteHooks < Redmine::Hook::Listener
  
  def view_issues_edit_notes_bottom(context={})
    lookup   = ActionView::LookupContext.new(File.dirname(__FILE__) + '/../app/views/')
    context  = ActionView::Base.with_empty_template_cache.new(lookup, {}, nil)
    renderer = ActionView::Renderer.new(lookup)
    renderer.render(
      context,
      partial: "issue_edit",
    )
  end

  def controller_issues_edit_before_save(context={})
    send_to_client = (context[:params]['send_to_client'] == "true")
    context[:journal].send_to_client = send_to_client
  end
  
  # add a history note on the journal
  def view_issues_history_journal_bottom(context={})
    return unless context[:journal].send_to_client == true
    lookup   = ActionView::LookupContext.new(File.dirname(__FILE__) + '/../app/views/')
    context  = ActionView::Base.with_empty_template_cache.new(lookup, {}, nil)
    renderer = ActionView::Renderer.new(lookup)
    renderer.render(
      context,
      partial: "issue_history",
    )
  end
  
end
