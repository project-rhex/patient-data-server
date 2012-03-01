class NotifyEvent

  
  def self.process(user, action)
    # lookup user and action in notify_config
    notify_configs = NotifyConfig.all( conditions: { user: /#{user}/i, action: action } ).to_a

    puts notify_configs.inspect

    # for each entry, insert a document into notification table
    notify_configs.each do |nconfig|
      n = Notification.new
      n.user = user
      n.action = action
      n.record_id = 1  ## TODO change this
      n.status = :unread
      if n.save!
        ## log it
        AuditLog.create(requester_info: user, event: "notification_set", description: "action:#{action}|record_id:1|#{:unread}")
      end
      
      #TODO wire this up
      #if nconfigs.interval
      # if instant then notify now
        # daily and weekly not implemented
    end

  end

end
