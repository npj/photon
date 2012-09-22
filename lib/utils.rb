module Photon
  module Utils

    ALPHANUM = (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).freeze

    def random_string(opts = { })
      opts.fetch(:length, 4).times.inject("") { |str| str << ALPHANUM[rand(ALPHANUM.length)] }
    end
  end
end
