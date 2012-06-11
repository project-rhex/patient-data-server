class RefNumber
  include Mongoid::Document

  field :num, :type => Integer


  def self.next
    ## retrieve the current value from the mongo
    if RefNumber.first == nil ||  RefNumber.first.num == nil
      r = RefNumber.new
      r.num = 1000
    else
      r = RefNumber.first 
    end
    curr_num = r.num

    r.num += 1
    r.save!

    return curr_num
  end
end
