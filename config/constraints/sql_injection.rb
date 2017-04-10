class SqlInjection

  @keyword_query ="select word from pg_get_keywords()" 

  def keywords
    r = ActiveRecord::Base.connection.execute(@keyword_query)

    # return just the reserved keywords
    r.column_values(0)
  end
  
  def self.contains_sql(s)
    self.keywords.any? { |w| s.include? w } 
  end

  def self.sanitize(s)
    s.gsub("'", '').gsub("&", '').gsub(";", '').gsub('#', '')  
  end
end