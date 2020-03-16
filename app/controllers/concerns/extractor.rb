class Extractor
  def initialize(hash)
    @hash = hash
  end

  def act
    @hash["project_variable_name"]
  end

  def value
    @hash["key"] || @hash["value"]
  end

  def set_dictionary
    VoiceVariable.create_with(value: value).find_or_create_by(name: act, value: value)
  end

  private
    attr_reader :hash
end
