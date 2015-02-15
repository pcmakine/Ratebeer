class MapApi
  def self.key
    raise "MAPAPIKEY env variable not defined" if ENV['MAPAPIKEY'].nil?
    ENV['MAPAPIKEY']
  end
end