require "test_helper"
require "atom/h_atom_feed"

class AtomFeedModuleTest < ActiveSupport::TestCase
  test "Create Feed" do
    entries = []
    entries << "a1"
    entries << "a2"

    a = {name: "James Joyce", email: "jjoyce@abc.info"}
    c = "Victor Hugo"
    time = Time.now
    i = 1
    atom = HAtomFeed.generate(id: "aaabbbcccddede", title: "Test", updated: time,
                              link: {href: "http://foo/bar"},
                              author: a, contributor: c) do |xml|
      xml.entries(entries) do |e|
        xml.id i.to_s
        xml.title "title #{e}"
        xml.link(href: "/" + e)
        i += 1
      end
    end

    # puts atom

    feed = Feedzirra::Feed.parse(atom)
    assert_equal 'Test', feed.title
    assert_not_nil(feed.entries)
    assert_equal(2, feed.entries.size)
    links = feed.links
    assert_equal 1, links.size
    assert_equal "http://foo/bar", links[0]

    e1 = feed.entries[0]
    e2 = feed.entries[1]
    assert_equal 'title a1', e1.title
    assert_equal 'title a2', e2.title
    assert_equal '/a1', e1.links[0]
    assert_equal '/a2', e2.links[0]
    assert_equal '1', e1.entry_id
    assert_equal '2', e2.entry_id
  end
  
end