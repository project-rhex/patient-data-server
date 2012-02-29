

class NotifyConfig
  include Mongoid::Document

  # email or username etc
  field :user, :type => String

  # INSTANT | DAILY | WEEKLY
  field :interval, :type => String

  # RECORD_UPDATE | CONSULT_REQUEST | CONSULT_COMPLETE
  field :type, :type => String

  # one or more of these 
  # default WEB | EMAIL | TEXT | DIRECT_EMAIL
  field :alert_flags, :type => String
end



class NotifyEnum
  def NotifyEnum.add_item(key,value)
    @hash ||= {}
    @hash[key]=value
  end
  
  def NotifyEnum.const_missing(key)
    @hash[key]
  end    
  
  def NotifyEnum.each
    @hash.each {|key,value| yield(key,value)}
  end
  
  def NotifyEnum.items
    key_array = []
    @hash.each { |key,value| 
      key_array << key
    }
    key_array
  end    
    
end


class NotifyInterval < NotifyEnum

  NotifyInterval.add_item :INSTANT, 1
  NotifyInterval.add_item :DAILY  , 2
  NotifyInterval.add_item :WEEKLY , 3
end


class NotifyType < NotifyEnum

  NotifyType.add_item :RECORD_UPDATE   , 1
  NotifyType.add_item :CONSULT_REQUEST , 2
  NotifyType.add_item :CONSULT_COMPLETE, 3
end


class AlertFlag < NotifyEnum

  AlertFlag.add_item :WEB         , 0x1
  AlertFlag.add_item :EMAIL       , 0x2
  AlertFlag.add_item :TEXT        , 0x4
  AlertFlag.add_item :DIRECT_EMAIL, 0x8
end

