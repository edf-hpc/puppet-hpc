require 'openssl'
require 'digest/md5'
def decryptor(file, password, scheme='AES-256-CBC')

 ### Define key and iv lenght according to the RC4 encryption scheme ###
  case scheme
    when 'AES-256-CBC'
      keylength=32
      ivlength=16
    when 'AES-192-CBC'
      keylength=24
      ivlength=16
    when 'AES-128-CBC'
      keylength=16
      ivlength=16
  end

  encrypted_data = nil

  ### Use binread in old versions ###
  begin
  rver = RUBY_VERSION.split('.')[0]+RUBY_VERSION.split('.')[1]
  if rver.to_i > 18
    encrypted_data = IO.binread(file)
  else
    encrypted_data = IO.read(file)
  end
  rescue
    return nil
  end

  
  if !encrypted_data.nil? or encrypted_data.length > 16 or encrypted_data[0, 8] == 'Salted__'
    salt = encrypted_data[8, 8]
    encrypted_data = encrypted_data[16..-1]
    totsize = keylength + ivlength
    keyivdata = ''
    temp = ''
    while keyivdata.length < totsize do
      temp = Digest::MD5.digest(temp + password + salt)
      keyivdata << temp
    end
    key = keyivdata[0, keylength]
    iv  = keyivdata[keylength, ivlength]
   
    ### Decrypt data ###
    decipher = OpenSSL::Cipher::Cipher.new(scheme)
    decipher.decrypt
    decipher.key = key
    decipher.iv = iv
    result = decipher.update(encrypted_data) + decipher.final
    return result
  else
    return nil 
  end
end

#require 'fileutils'


Puppet::Parser::Functions::newfunction(:decrypt, :type => :rvalue, :arity => -3, :doc =>
  "Loads a crypted file from a module, evaluates it, and returns the resulting value as a string.") do |args|
  raise ArgumentError, ("decrypt(): wrong number of arguments (#{args.length}; must be 2 or 3") if args.length > 3
  args.each do | arg|
    raise ArgumentError, ('decrypt(): argument must be a string') unless arg.is_a?(String)
  end

  target = args[0]
  passwd = args[1] 

  debug "Retrieving crypted content in #{target}"
  
  if File.exist?(target) 
     result = decryptor(target, passwd) 
#    encrypted_data = nil
#    rver = RUBY_VERSION.split('.')[0]+RUBY_VERSION.split('.')[1]
#    if rver.to_i > 18
#      encrypted_data = IO.binread(target)
#    else
#      encrypted_data = IO.read(target)
#    end
#    if !encrypted_data.nil? or encrypted_data.length > 16 or encrypted_data[0, 8] == 'Salted__'
#      result = %x[openssl aes-256-cbc -d -in #{target} -k #{passwd}]
  else
    raise ArgumentError,("Crypted file not found:\n  Filepath: #{target}\n")
  end

  begin
    result
  rescue Puppet::ParseError => internal_error
    if internal_error.original.nil?
      raise internal_error
    else
      raise internal_error.original
    end
  end
end
