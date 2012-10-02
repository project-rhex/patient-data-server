class RefConsultRequest
  include Mongoid::Document
  include Mongoid::Symbolize
  include Mongoid::Timestamps

  field :refDate, :type => Date
  field :disposition, :type => String
  field :refNumber, :type => Integer

  symbolize :priority, :in => {
    urgent:      "Urgent (48 hour)",
    high:        "High (14 days)",
    normal:      "Normal (30 days)",
    low:         "Low (4 months)"}, :default => :normal, :scopes =>true

  symbolize :status, :in => {
    pending:           "Pending",
    results_sent:      "Results Sent",
    approved:          "Approved",
    results_pending:   "Results Pending",
    overdue:           "Overdue",
    accepted:          "Accepted",
    declined:          "Declined"}, :default => :pending, :scopes =>true

  field :reasonConditionId, :type => Integer
  field :refType, :type => String
  field :procedureId, :type => Integer
  field :reasonDescription, :type => String
  field :category, :type => String
  field :requestedNumTreatments, :type => Integer
  field :requestProviderId, :type => Integer

  field :patientRecordId, :type => String

  field :comment, :type => String

  # found list at: http://www.healthadvantage.org/body.cfm?id=85
  symbolize :requestedSpecialty, :in => {
    allergy_immunology:       "Allergy & Immunology",
    anesthesia:               "Anesthesia",
    cardiovascular_disease:   "Cardiovascular Disease",
    dermatology:              "Dermatology",
    emergency_medicine:       "Emergency Medicine",
    endocrinology_metabolim:  "Endocrinology and Metabolism",
    family_practice:          "Family Practice",
    gastroenterology:         "Gastroenterology",
    general_practice:         "General Practice",
    geriatric_medicine:       "Geriatric Medicine",
    gynecology:               "Gynecology",
    gynecologic_oncology:     "Gynecologic Oncology",
    hematology:               "Hematology",
    infectious_diseases:      "Infectious Diseases",
    internal_medicine:        "Internal Medicine",
    neonatology:              "Neonatology",
    nephrology:               "Nephrology",
    neurology:                "Neurology",
    neurological_surgery:     "Neurological Surgery",
    obstetrics_gynecology:    "Obstetrics and Gynecology",
    oncology_medical:         "Oncology, Medical",
    ophthalmology:            "Ophthalmology",
    orthopedic_surgery:       "Orthopedic Surgery",
    otorhinolaryngology:      "Otorhinolaryngology",
    pathology:                "Pathology",
    pediatrics:               "Pediatrics",
    physical_medicine_rehab:  "Physical Medicine and Rehabilitation",
    plastic_surgery:          "Plastic Surgery",
    podiatric_medicine:       "Podiatric Medicine",
    preventative_medicine:    "Preventative Medicine",
    psychiatry:               "Psychiatry",
    pulmonary_disease:        "Pulmonary Disease",
    radiology_diagnostic:     "Radiology, Diagnostic",
    radiology_nuclear:        "Radiology, Nuclear",
    radiation_oncology:       "Radiation Oncology",
    rheumatology:             "Rheumatology",
    sports_medicine:          "Sports Medicine",
    surgery_general:          "Surgery, General",
    surgery_hand:             "Surgery, Hand",
    surgery_thoracic:         "Surgery, Thoracic",
    surgery_vascular:         "Surgery, Vascular",
    surgery_colon_rectal:     "Surgery, Colon and Rectal",
    surgery_urology:          "Surgery, Urology"}, :default => :general_practice, :scopes =>true

  field :requestedConsultingProviderId, :type => Integer
  field :reasonText, :type => String
end
