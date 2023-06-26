require 'rails_helper'

RSpec.describe Pokemon, type: :model do
  describe '#create' do
    subject { described_class.create(name:) }

    context 'with missing name' do
      let(:name) { '' }

      it 'raises an error' do
        expect { subject }.to raise_error(StandardError, 'Please provide a Pokemon name')
        expect(Pokemon.count).to eq(0)
      end
    end

    context 'with wrong name' do
      let(:name) { 'Doraemon' }

      before do
        allow(PokeApi).to receive(:get).and_raise(
          StandardError.new("Please provide a valid Pokemon name (name provided: '#{name}')")
        )
      end

      it 'raises an error' do
        expect { subject }.to raise_error(
          StandardError, "Please provide a valid Pokemon name (name provided: '#{name}')"
        )
        expect(Pokemon.count).to eq(0)
      end
    end

    context 'with correct name' do
      let(:name) { 'Gyarados' }
      let(:pokemon_params) do
        {
          name: 'gyarados',
          id: 130,
          height: 65,
          order: 211,
          weight: 2350
        }
      end

      before do
        allow(PokeApi).to receive(:get).and_return(pokemon_params)
      end

      it 'creates a Pokemon' do
        subject
        expect(Pokemon.count).to eq(1)
        pokemon = Pokemon.first
        expect(pokemon.name).to eq(name.downcase)
        expect(pokemon.id).to eq(130)
        expect(pokemon.height).to eq(65)
        expect(pokemon.order).to eq(211)
        expect(pokemon.weight).to eq(2350)
      end
    end
  end
end
