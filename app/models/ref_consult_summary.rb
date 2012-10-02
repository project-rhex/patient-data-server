class RefConsultSummary
  include Mongoid::Document
  include Mongoid::Timestamps
  field :refDate, :type => Date
  field :refNumber, :type => Integer
  field :consultationTreatmentSummary, :type => String
  field :recommendedPlanOfCareId, :type => Integer
  field :sendRequestProviderId, :type => Integer
end
