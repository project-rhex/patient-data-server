require "atom/h_atom_builder"

module HAtomFeed
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
  # :link (hash with :href, :rel -or- an array of these)
  # :author (hash with :email, :name, :uri)
  # :category
  # :icon
  # :rights
  # :contributor
  #
  # The block should create more xml elements using Nokokgiri::XML::Builder. Typical elements for
  # entries are:
  #
  # xml.title "name"
  # xml.link(href: "link", rel: "alternate")
  # xml.id "idvalue"
  # xml.updated "iso formatted date" << call HAtom::Feed.iso_fmt_date(time value)
  # xml.summary "text description"
  def self.generate(options)
    raise Exception.new('id is required') unless options && options[:id]
    link = options[:link]
    @builder = HAtomBuilder.new do |xml|
      xml.feed(xmlns: 'http://www.w3.org/2005/Atom') {
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
        xml.author {
          xml.name (options[:author][:name]) if options[:author] && options[:author][:name]
          xml.email (options[:author][:email]) if options[:author] && options[:author][:email]
          xml.uri (options[:author][:uri]) if options[:author] && options[:author][:uri]
        } if options[:author]
        xml.category options[:category] if options[:category]
        xml.icon options[:icon] if options[:icon]
        xml.rights options[:rights] if options[:rights]
        xml.contributor {
          xml.name options[:contributor]
        } if options[:contributor]
        xml.generator("h atom generator", version: "1.0")
        yield xml
      }
    end
    @doc = @builder.doc
    @doc.to_s.html_safe
  end


end