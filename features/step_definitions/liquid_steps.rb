Given 'the asset URI prefix is "$uri"' do |uri|
  # Kinda bogus, but makes explicit tests significantly easier
  Landable::Asset.stub!(:url_generator) do
    proc { |asset|
      uri = "#{uri}/" unless uri.ends_with?('/')
      "#{uri}#{asset.basename}"
    }
  end
end

Given /^a page under test$/ do
  @page = Landable::Page.new(title: "Page Under Test")
end

Given "the page's body is \"$body\"" do |body|
  @page.body = body
end

Given "the page's body is:" do |body|
  @page.body = body
end

Given "the page's meta tags are:" do |table|
  @page.meta_tags = {}
  table.hashes.each do |tag|
    @page.meta_tags[tag['name']] = tag['content']
  end
end

Given "the page uses a theme with the body:" do |body|
  @page.theme ||= Landable::Theme.new
  @theme ||= @page.theme
  @page.theme.body = body
end

Given "the page has these assets:" do |table|
  table.hashes.each do |attrs|
    asset_alias = attrs.delete('alias')
    @page.attachments.add build(:asset, attrs), asset_alias
  end
end

Given 'the theme has these assets:' do |table|
  table.hashes.each do |attrs|
    asset_alias = attrs.delete('alias')
    @theme.attachments.add build(:asset, attrs), asset_alias
  end
end

Given 'a theme with the body:' do |body|
  @theme = Landable::Theme.new body: body
end

Given 'a theme with the body "$body"' do |body|
  @theme = Landable::Theme.new body: body
end

When 'this page is rendered:' do |body|
  @page = Landable::Page.new body: body
  @page.theme = @theme
  @rendered_content = Landable::RenderService.call(@page)
end

Then 'the rendered content should be:' do |body|
  @rendered_content ||= Landable::RenderService.call(@page)
  @rendered_content.should == body
end