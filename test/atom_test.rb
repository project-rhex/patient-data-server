# Define helpful methods and assertions for atom feed testing
class AtomTest < ActionController::TestCase
  def assert_atom_success
    assert_response :success
    assert_equal "application/atom+xml", response.content_type
  end

  def atom_results
    Feedzirra::Feed.parse(@response.body)
  end

  def assert_atom_result_count rss, count
    assert_not_nil(rss.entries)
    assert_equal(count, rss.entries.size)
  end

  def assert_atom_results rss
    assert_not_nil(rss.entries)
    rss.entries.size > 0
  end
end