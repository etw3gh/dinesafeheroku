streetname_max_len_query = "select max(length(streetname)) from addresses;"
streetname_max_len_result = ActiveRecord::Base.connection.execute(streetname_max_len_query)
streetname_max_len = streetname_max_len_result[0]['max']



Rails.application.config.max_lengths = { 
    streetname: streetname_max_len
}