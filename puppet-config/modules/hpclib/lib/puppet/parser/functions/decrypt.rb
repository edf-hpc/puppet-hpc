require 'openssl'
require 'digest/md5'
require 'open-uri'

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

  if file.kind_of?(Array)
    file_array = file
  else
    file_array = [file]
  end

  # First, try to read the file with the puppet function 
  # file, it handles fallback natively and paths like:
  # * <module>/<filename>
  # * Absolute file name
  encrypted_data = ''
  begin
    encrypted_data = function_file(file_array)
  rescue
    debug("function_file failed to read #{file_array}.")
  end

  if encrypted_data == ''
    file_array.each do |current_file|
      begin
        # Remove the 'file://' part
        uri = current_file.sub(%r{^file://}, '')
        encrypted_data = open(uri, 'rb') { |f| f.read }
      rescue => e 
          debug("IO module failed to read #{current_file}: #{e}")
      end
    end
  end

  if encrypted_data == ''
    raise "Failed to read encrypted data from any source: #{file}"
  end

  if encrypted_data.length > 16 or encrypted_data[0, 8] == 'Salted__'
    # the unpack/pack trick is here to avoid an encoding issue
    # when using the salt in the MD5::digest. Not sufficiently
    # an expert on ruby string encoding to entirely understand
    # what's going on here.
    salt = encrypted_data[8, 8].unpack('c*').pack('c*')
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
    raise "Invalid encrypted data read from file: #{file}"
  end
end

# @param target File that should be decrypted
# @param passwd Password to use for decrypting the file
Puppet::Parser::Functions::newfunction(
  :decrypt, 
  :type => :rvalue,
  :arity => 2,
  :doc => "Loads a crypted file from a module, evaluates it, and returns the resulting value as a string.") do |args|
  raise ArgumentError, ("decrypt(): wrong number of arguments (#{args.length}; must be 2") if args.length != 2

  target = args[0]
  passwd = args[1] 

  raise ArgumentError, ('decrypt(): First argument (Target) must be an Array or a String') unless target.kind_of?(Array) or target.is_a?(String)
  raise ArgumentError, ('decrypt(): Seconf argument (Password) must be a string') unless passwd.is_a?(String)

  debug "Retrieving crypted content in #{target}"
    result = decryptor(target, passwd) 

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
