class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Symbolize


  # email or username etc
  field :user, :type => String

  # RECORD_UPDATE | CONSULT_REQUEST | CONSULT_COMPLETE
  symbolize :action, :in => {
    record_update:   "Record Update", 
    consult_request:  "Consult Request",
    consult_complete: "Consult Complete" }, :scopes => true



  field :record_id, :type => String

  # UNREAD | READ | DONE
  # DONE - user is done with this notification and thus can be cleaned out (deleted) 
  symbolize :status, :in => {
    unread: "Unread",
    read:   "Read",
    done:   "Done" }, :scopes => true
end

