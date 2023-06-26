class Pokemon < ApplicationRecord
  before_save :populate_from_api

  private

  def populate_from_api
    raise 'Please provide a Pokemon name' if name.blank?

    pokemon_json = PokeApi.get(pokemon: name.downcase).to_json
    params = JSON.parse(pokemon_json)
    params.select! { |x| attribute_names.index(x) } # select only attributes we are using
    self.attributes = params
  rescue JSON::ParserError
    raise "Please provide a valid Pokemon name (name provided: '#{name}')"
  end
end
