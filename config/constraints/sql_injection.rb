class SqlInjection
  cattr_accessor :sanitize

  @keyword_query ="select word from pg_get_keywords()" 

  def keywords
    r = ActiveRecord::Base.connection.execute(@keyword_query)

    # return just the reserved keywords
    r.column_values(0)
  end
  
  def contains_sql(s)
    keywords.any? { |w| s.include? w } 
  end

  def @@sanitize(s)
    s.gsub("'", '').gsub("&", '').gsub(";", '').gsub('#', '')  
  end
end