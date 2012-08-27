

class NotifyConfig
  include Mongoid::Document
  include Mongoid::Symbolize
  include Mongoid::Timestamps

  # email or username etc
  field :user, :type => String

  # INSTANT | DAILY | WEEKLY
  symbolize :interval, :in => {
    instant: "Instant", 
    daily:   "Daily", 
    weekly:  "Weekly"}, :default => :instant, :scopes => true
  
  # RECORD_UPDATE | CONSULT_REQUEST | CONSULT_COMPLETE
  symbolize :action, :in => {
    record_update:   "Record Update", 
    consult_request:  "Consult Request",
    consult_complete: "Consult Complete" }, :scopes => true

  # one or more of these 
  # default WEB | EMAIL | TEXT | DIRECT_EMAIL
  ## TODO - note the best implementation of this, good for now 
  symbolize :alert_out1, :in => {
    web:   "Web",
    email: "Email",
    text:  "Text",
    direct_email: "Direct Email",
    none: "None"}, :default => :web, :scopes => true

  symbolize :alert_out2, :in => {
    web:   "Web",
    email: "Email",
    text:  "Text",
    direct_email: "Direct Email",
    none: "None"}, :default => :none, :scopes => true

  symbolize :alert_out3, :in => {
    web:   "Web",
    email: "Email",
    text:  "Text",
    direct_email: "Direct Email",
    none: "None"}, :default => :none, :scopes => true

  symbolize :alert_out4, :in => {
    web:   "Web",
    email: "Email",
    text:  "Text",
    direct_email: "Direct Email",
    none: "None"}, :default => :none, :scopes => true


end

