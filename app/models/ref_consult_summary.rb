class RefConsultSummary
  include Mongoid::Document
  field :refDate, :type => Date
  field :refNumber, :type => Integer
  field :consultationTreatmentSummary, :type => String
  field :recommendedPlanOfCareId, :type => Integer
  field :sendRequestProviderId, :type => Integer
end
