class User < ActiveRecord::Base
  # Validations ------------------------------------------------------
  validates :spotify_id, presence: true

  # OmniAuth ---------------------------------------------------------
  def self.find_or_create_from_omniauth(auth_hash)
    spotify_id = auth_hash[:extra][:raw_info][:id]

    user = User.where(spotify_id: spotify_id).first_or_initialize
    user.name = auth_hash[:info][:name]

    return user.save ? user : nil
  end

end
