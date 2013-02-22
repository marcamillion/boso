module TagFetcher

  def self.fetch_tags(num_results, page_num)
    if num_results && page_num
      @tags = Serel::Tag.pagesize(num_results).page(page_num).get
    elsif num_results
      @tags = Serel::Tag.pagesize(num_results).get
    elsif page_num
      @tags = Serel::Tag.pagesize(100).page(page_num).get
    else
      @tags = Serel::Tag.pagesize(100).get
    end          
  end

end
