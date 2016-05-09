# Fixes excel uploading
#
if Paperclip.options[:content_type_mappings]
  Paperclip.options[:content_type_mappings][:xls] = "CDF V2 Document, No summary info"
end
