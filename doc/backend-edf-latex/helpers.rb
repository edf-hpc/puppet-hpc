# encoding: UTF-8

# Folds each endline into a single space, escapes special man characters,
# reverts HTML entity references back to their original form, strips trailing
# whitespace and, optionally, appends a newline
def manify(str, append_newline = false)
  str.gsub!('&lt;', '<')
  str.gsub!('&gt;', '>')
  str.gsub!('&#8201;&#8212;&#8201;', '')
  str.gsub!('&#8203;', '') # NOTE remove zero-width space as it's something specific for HTML output
  str.gsub!('&#8212;', '—')
  str.gsub!('&#8217;', '’')
  str.gsub!('&#8230;', '…')
  str.gsub!('&#174;', '\textregistered')
  str.gsub!(/_/, '\_')
  str.gsub!('$', '\$') # escape dollar sign using negative look-behind to check if not already escaped 
  #str.gsub!(/(?<!\\)\$/, '\$') # escape dollar sign using negative look-behind to check if not already escaped 
  #str.gsub!('_', '\_') # escape underscore sign using negative look-behind to check if not already escaped 
  str.gsub!(/(?<!\\)_/, '\_') # escape underscore sign using negative look-behind to check if not already escaped 
  str.gsub!('%', '\%') # escape percent sign using negative look-behind to check if not already escaped 
  #str.gsub!(/(?<!\\)%/, '\%') # escape percent sign using negative look-behind to check if not already escaped 
  str.gsub!(/\\\\_/, '\_') # fix twice espaced underscore introduced by asciidoctor
  str.gsub!('&amp;'){'\&'} # http://stackoverflow.com/questions/6569359/replace-to-in-ruby-seems-impossible
  str.gsub!('#'){'\#'}
  str.gsub!('→','$\rightarrow$')
  str += "\n" if append_newline
  return str
end

def unsub_special_chars(str)
  #puts "|" + str + "|"
  str.gsub!('&lt;', '<')
  str.gsub!('&gt;', '>')
  str.gsub!(/\$/, '$')
  str.gsub!("\\_", "_")
  str.gsub!('&amp;'){'&'} # http://stackoverflow.com/questions/6569359/replace-to-in-ruby-seems-impossible
  return str
end
