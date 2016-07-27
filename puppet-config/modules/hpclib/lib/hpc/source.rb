require 'open-uri'

def hpc_source_file(source)

  if source.kind_of?(Array)
    source_array = source
  else
    source_array = [source]
  end

  # First, try to read the file with the puppet function 
  # file, it handles fallback natively and paths like:
  # * <module>/<filename>
  # * Absolute file name
  data = ''
  begin
    data = function_file(source_array)
  rescue
    debug("function_file failed to read #{source_array}.")
  end

  if data == ''
    source_array.each do |current_file|
      begin
        # Remove the 'file://' part
        uri = current_file.sub(%r{^file://}, '')
        data = open(uri, 'rb') { |f| f.read }
      rescue => e 
          debug("IO module failed to read #{current_file}: #{e}")
      end
    end
  end

  return data

end
