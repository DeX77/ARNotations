class Array
  include TOXTM2
  include ARNotations::Characteristics
  def array_to_xtm2(array)

    if array.blank?
      return
    end

    doc = TOXTM2::xml_doc
    x = doc.add_element 'topicMap', {'xmlns' => 'http://www.topicmaps.org/xtm/', 'version' => '2.0', 'reifier' => "#tmtopic"}

    #TODO
    #First we need the "more_information" occurrence
    x << topic_as_type("more_information", :psi => $MORE_INFORMATION)

    #collect types
    types = {}

    array.each do |topic|
      types[topic.class.to_s] = topic_as_type(topic.class.to_s, {:psi => topic.get_psi})
      #types[topic.class.to_s] = topic_as_type(topic.class.to_s, {:psi => topic.get_psi, :more_info =>topic.more_info})
    end

    types.each_value { |topic_type| x << topic_type }

    array.each() do |topic|
      stub = topic.topic_stub
      stub << occurrence_to_xtm2("more_information", {:psi => "more_information"}, topic.absolute_identifier)  unless topic.more_info.blank?
      x << stub
    end

    #Create TopicMap ID Reification
    y = REXML::Element.new('topic')
    y.add_attribute('id', "tmtopic")
    z = REXML::Element.new 'name'
    z << TOXTM2.value(array.first.topic_map)
    y << z
    x << y

    return doc
  end

  def to_xtm2
    return array_to_xtm2(self)
  end
end