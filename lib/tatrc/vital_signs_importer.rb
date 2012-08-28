module TATRC
  class VitalSignsImporter
    include Singleton

    def import(xml_string)
      xml = Nokogiri::XML(xml_string)
      xml.root.add_namespace_definition('gc32', "urn:hl7-org:greencda:c32")
      vital_signs_xml = xml.xpath("/gc32:vitalSigns/gc32:vitalSignsOrganizer/gc32:vitalSign")
      vital_signs_xml.map do |vs_el|
        vs = VitalSign.new
        code = extract_code(vs_el, './gc32:resultType')
        vs.description = code['name']
        vs.add_code(code['code'], code['codeSystem'])
        set_interval(vs, vs_el)
        set_values(vs, vs_el)
        vs.interpretation = extract_code(vs_el, './gc32:resultInterpretation')
        vs
      end
    end

    def extract_code(vs_element, xpath)
      code_element = vs_element.at_xpath(xpath)
      return unless code_element
        {'code' => code_element['code'],
         'name' => code_element['displayName'],
         'codeSystem' => HealthDataStandards::Util::CodeSystemHelper.code_system_for(code_element['codeSystem'])}
    end

    def set_interval(vs, vs_element)
      ivlts_el = vs_element.at_xpath("gc32:resultDateTime")
      return unless ivlts_el
      value_att = ivlts_el.get_attribute("value")
      if value_att
        vs.time = get_time(ivlts_el)
      else
        low = ivlts_el.at_xpath('./gc32:low')
        high = ivlts_el.at_xpath('./gc32:high')
        vs.start_time = get_time(low) if low
        vs.end_time = get_time(high) if high
      end
    end

    def get_time(time_el)
      time = time_el.get_attribute("value").try(:value)
      return time ? Time.parse(time).to_i : nil
    end

    def set_values(vs, value_element)
      pq_el = value_element.at_xpath("./gc32:resultValue/gc32:physicalQuantity")
      if pq_el
        pq = PhysicalQuantityResultValue.new
        pq.scalar = pq_el['value'].to_f if pq_el['value']
        pq.units = pq_el['unit']
        vs.values << pq
      end
    end

  end
end
