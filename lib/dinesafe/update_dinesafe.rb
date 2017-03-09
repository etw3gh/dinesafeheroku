class UpdateDinesafe

  attr_accessor :noko, :timestamp, :logerrs, :verbose

  def initialize(xmlpath, verbose, timestamp, byUrl = false)
    # get a nokogiri object & drill down to the row object level
    # each inspection is a row


    # keep old code working for now but will be refactored to accept only 
    # urls instead of downloaded files
    if byUrl
      @noko = Nokogiri::XML(File.open(xmlpath)).css('ROWDATA ROW')
    else
      @noko = Nokogiri::XML(open(xmlpath)).css('ROWDATA ROW')
    end

    @timestamp = timestamp 

    @verbose = verbose
  end
   

  def process
    addr = nil
    version = nil
    rid = nil
    eid = nil
    iid = nil
    etype = nil 
    status = nil
    details = nil
    date = nil
    lo = nil
    hi = nil
    losuf = nil
    hisuf = nil


    @noko.each_with_index do |row|
      multiple_error = false
      notfound_error = false
      version =  @timestamp
      rid =      row.xpath('ROW_ID').text.to_i    
      eid =      row.xpath('ESTABLISHMENT_ID').text.to_i
      iid =      row.xpath('INSPECTION_ID').text.to_i
      name =     row.xpath('ESTABLISHMENT_NAME').text.strip.split.join(' ').downcase
      etype =    row.xpath('ESTABLISHMENTTYPE').text.strip.split.join(' ')
      status =   row.xpath('ESTABLISHMENT_STATUS').text.strip.split.join(' ')
      details =  row.xpath('INFRACTION_DETAILS').text.strip.split.join(' ')
      date =     row.xpath('INSPECTION_DATE').text.strip.split.join(' ')
      severity = row.xpath('SEVERITY').text.strip.split.join(' ')
      action =   row.xpath('ACTION').text.strip.split.join(' ')
      outcome =  row.xpath('COURT_OUTCOME').text
      fine =     row.xpath('AMOUNT_FINED').text
      address =  row.xpath('ESTABLISHMENT_ADDRESS').text.strip.split.join(' ').downcase.remove("'")
      mipy =     row.xpath('MINIMUM_INSPECTIONS_PERYEAR').text.to_i

      street_number, street_name = split_address_from_street_number(address)

      # first find a matching address
      # get or create a venue
      # get or create an inspection, given the timestamp
      address_id = nil
      begin
        # strip out hypenated, take lo num. remove non numeric
        sn = street_number.split('-').first.gsub(/\D/, '') 

        # case when street_number is numeric
        if street_number.numeric?
          orquery = "num='#{street_number}' or lo=#{sn}"          
          addr = Address.where(:streetname=>street_name).where(orquery).first        
        else 
          if street_number.index('-').nil?
            #split num and letter
            arr = split_alpha_from_numeric(street_number)
            if arr.length == 2
              num = arr[0].to_i
              losuf = arr[1]
              addr = Address.where(:streetname=>street_name, :lo=>num, :losuf=>losuf)
            else
              puts "bad split on #{street_number} #{streetname}"
            end
          else
            puts "found hypenated #{street_number}" 

            lo, hi = street_number.split('-')
            if lo.numeric?
              losuf = ''
            else
              lo, losuf = split_address_from_street_number(lo)
            end
            if hi.numeric?
              hisuf = ''
            else
              hi, hisuf = split_address_from_street_number(hi)
            end

            addr = Address.where(:streetname=>street_name, :lo=>lo, :hi=>hi, :losuf=>losuf, :hisuf=>hisuf)
          end
        end

        # if still no hits, try finding number within range
        # try to find within range betwen hi and low 
        if addr.nil?
          range_query = "lo < #{sn} and hi >= #{sn}"
          add = Address.where(:streetname=>street_name).where(range_query)
          addr = add.first

          # TODO find out why getting multiple hits
          unless add.nil?
            if add.length > 1
              multi = "More than one address found for #{sn} #{street_name}\n"
              puts multi if @verbose
              multiple_error = true
            end
          end
        end

        if addr.nil?
          msg = "Address Not Found for iid #{iid}: #{address} == #{street_name} #{street_number}\n"
          puts msg if @verbose
          address_id = -1
          notfound_error = true
        else
          address_id = addr.id
        end

      rescue Exception => add
        t.integer :hirex
        puts addrex
      end
      venue_id = nil
      venue = Venue.where(:address_id=>address_id).first_or_create(:venuename=>name, :eid=>eid)
      if venue.nil?
        msg = "Venue Creation Error for iid #{iid}: a.id #{addr.id}, venue: #{name}, eid: #{eid}\n"
        puts msg if @verbose
        venue_id = -1
      else
        venue_id = venue.id

        if multiple_error
          Multiple.where(:venue_id=> venue_id, :timestamp=>@timestamp, :iid=>iid, :eid=>eid, :num=>street_number, :streetname=>street_name, :lo=>lo, :hi=>hi, :losuf=>losuf, :hisuf=>hisuf).first_or_create
        end
        if notfound_error
          Notfound.where(:venue_id=> venue_id, :timestamp=>@timestamp, :iid=>iid, :eid=>eid, :num=>street_number, :streetname=>street_name, :lo=>lo, :hi=>hi, :losuf=>losuf, :hisuf=>hisuf).first_or_create
        end          
      end

      insp = Inspection.where(:rid => rid,
                              :eid => eid,
                              :iid => iid,
                              :etype => etype.downcase,
                              :status => status.downcase,
                              :details => details.downcase,
                              :date => date,
                              :severity => severity.downcase,
                              :action => action.downcase,
                              :outcome => outcome.downcase,
                              :mipy => mipy,
                              :venue_id => venue_id).first_or_create(version: @timestamp)


      if insp.nil?
        msg = "Inspection Error for iid: #{iid}, rid: #{rid}, venue: #{name}"
        puts msg if @verbose        
      end

    end
    notfound = Notfound.distinct.count
    multiple = Multiple.distinct.count
    if notfound > 0
      puts "#{notfound} Venues Not Found"
    end
    if multiple > 0
      puts "#{multiple} Venues with muliple addresses not found. An approximate one has been assigned"
    end
  end
  
  def split_alpha_from_numeric(s)
    s.scan(/\d+|\D+/)
  end



  # splits the first numeric value from the remainder of the address string
  # returns lowercase tuple (streetnum, streetname)
  def split_address_from_street_number(address)
    street_name = nil
    street_number = nil
    split_add = address.split  
    
    split_add.each do |token|
      # allow for hypenated numbers or suffixed values such as 2b
      if token[0].numeric? && street_number.nil?
        street_number = token
        split_add.delete(token)
        street_name = split_add.join(' ')
        break
      end 
    end
    return street_number.downcase.strip, street_name.downcase.strip
  end


end