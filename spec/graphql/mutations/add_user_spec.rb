require 'rails_helper'

module Mutations
  module Users
    RSpec.describe AddUser, type: :request do
      subject(:mutation) do
        described_class.new(
          object: nil,
          field: nil,
          context: nil
        )
      end

      describe 'resolve' do
        let(:input) do
          {
            name: 'John doe',
            username: 'johndoe',
            password: 'strong_pass',
            email: 'johndoe@mail.com'
          }
        end

        context 'with valid params' do
          subject { mutation.resolve(params: input) }

          it 'creates an user' do
            expect(subject[:user][:id]).to eq(1)
          end
        end

        context 'with invalid params' do
          subject { mutation.resolve(params: {}) }

          it 'return an error' do
            expect(subject.to_s).to include('Invalid attributes for')
          end
        end
      end
    end
  end
end

