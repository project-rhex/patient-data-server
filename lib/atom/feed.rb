require "atom/builder"

module Atom
  module Feed
    def self.iso_fmt_date(date)
      date.utc.strftime("%Y-%m-%dT%H-%M-%SZ")
    end

    #--------------------------------------------------------------------------------
    # Render an atom feed
    # @param options a hash. These are used for the atom header. The keys are symbols.
    #     :id is required, all others are optional.
    #
    # :id
    # :title
    # :subtitle
    # :updated (time)
    # :link (hash with :href, :rel -or- an array of these, e.g. [{href: "http://foo/bar", rel: "self"}, {href: "..", rel: "alternate"}...])
    # :author (hash with :email, :name, :uri)
    # :category
    # :icon
    # :rights
    # :contributor
    #
    # The block should create more xml elements as when using Nokokgiri::XML::Builder
    # where the element passed to the block is the builder. Typical elements for
    # entries are:
    #
    # title "name"
    # link(href: "link", rel: "alternate")
    # id "idvalue"
    # updated "iso formatted date" << call Atom::Feed.iso_fmt_date(time value)
    # summary "text description"
    #
    # Arbitrary elements may be created, but the actual rules for Atom restricts element
    # content to defined elements unless other namespaces are referenced in the xml header.
    # This atom feed mechanism doesn't yet have a mechanism to add additional namespaces,
    # and prefixes to the xml header.
    #
    # Use this method from any render mechanism that can accept string output such as an
    # erb template. It is perfectly possible to mix this with render partial to split the
    # header with the entries in a partial using the usual sorts of local passing mechanisms
    # in erbs.
    def self.generate(options)
      raise Exception.new('id is required') unless options && options[:id]
      link = options[:link]
      @builder = Atom::Builder.new do |xml|
        xml.feed(xmlns: 'http://www.w3.org/2005/Atom') do
          xml.id options[:id]
          xml.title options[:title] if options[:title]
          xml.subtitle options[:subtitle] if options[:subtitle]
          xml.updated iso_fmt_date(options[:updated]) if options[:updated]
          if link
            if link.kind_of?(Array)
              link.each do |l|
                xml.link(l)
              end
            else
              xml.link(link)
            end
          end
          xml.author do
            xml.name (options[:author][:name]) if options[:author] && options[:author][:name]
            xml.email (options[:author][:email]) if options[:author] && options[:author][:email]
            xml.uri (options[:author][:uri]) if options[:author] && options[:author][:uri]
          end if options[:author]
          xml.category options[:category] if options[:category]
          xml.icon options[:icon] if options[:icon]
          xml.rights options[:rights] if options[:rights]
          xml.contributor do
            xml.name options[:contributor]
          end if options[:contributor]
          xml.generator("atom feed generator", version: "1.0")
          yield xml
        end
      end
      @doc = @builder.doc
      @doc.to_s.html_safe
    end
  end
end