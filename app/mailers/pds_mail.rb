class PdsMail < ActionMailer::Base
  #default from: "gganley@direct.rhex.us"
  add_template_helper(ApplicationHelper)

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.rhex_mail.consult.subject
  #
  def consult(ref_consult_request, record)
    @ref_consult_request = ref_consult_request
    @record = record
    @greeting = "Hi"

    begin
      mail  from: "gganley@direct.rhex.us", to: "gganley@direct.healthvault-stage.com", subject: "RHEx email from PDS - Consult REF##{@ref_consult_request.refNumber}"
    rescue Exception=>e
      puts e.inspect
    end

  end
end
