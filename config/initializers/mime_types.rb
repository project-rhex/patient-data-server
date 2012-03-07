# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

Mime::Atom = Mime::Type.lookup_by_extension(:atom)
Mime::Json = Mime::Type.lookup_by_extension(:json)
