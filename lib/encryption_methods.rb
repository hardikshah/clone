require 'digest'

module EncryptionMethods
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
  def create_activation_hash
    secure_hash((('a'..'z').to_a+('A'..'Z').to_a+
                ('0'..'9').to_a).shuffle.join)
  end

end
