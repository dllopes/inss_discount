# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :session_id

    def connect
      self.session_id = SecureRandom.hex(8)
      Rails.logger.info "[ActionCable] Connection established with session_id: #{session_id}"
    end
  end
end
