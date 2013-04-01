module TagFetcher

  def self.fetch_tags(page_num)
    tags = Serel::Tag.pagesize(100).page(page_num).get
  end

  def self.find_tag(tagname)
    #this is due to the tagname not being encoded and returning an error when parsing the tag 'c#'.
    tagname.gsub!("c#", "c%23")
    tagname.gsub!("f#", "f%23")
    # tagname.gsub!()
    tag = Serel::Tag.find_by_name(tagname)
  end
end
