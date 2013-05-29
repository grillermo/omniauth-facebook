require 'omniauth/strategies/oauth2'
require 'base64'
require 'openssl'
require 'rack/utils'

module OmniAuth
  module Strategies
    class Nimanic
      include OmniAuth::Strategy

      option :fields, [:telephone_number,]
      option :uid_field, :telephone_number
      
      def request_phase
        form = OmniAuth::Form.new(:title => "Número de teléfono", :url => callback_path)
        options.fields.each do |field|
          form.text_field field.to_s.capitalize.gsub("_", " "), field.to_s
        end
        form.button "Dame código de verificación por teléfono"
        form.to_response
      end

      def callback_phase
        puts 'options'+@options.to_s
      end

      uid do
        request.params[options.uid_field.to_s]
      end

      info do
        options.fields.inject({}) do |hash, field|
          hash[field] = request.params[field]
          hash
        end
      end
    end
  end
end
