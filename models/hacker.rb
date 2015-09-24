class Hacker < Ohm::Model
  attribute :name
  attribute :password
  index :name
  reference :seniority, :Seniority
  collection :acquirements, :Acquirement

  def self.login credentials
    hacker = Hacker.find(name: credentials[:name]).to_a.first
    return hacker if hacker.password == credentials[:password]
  end
end
