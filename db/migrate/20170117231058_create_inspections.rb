class CreateInspections < ActiveRecord::Migration[5.0]
  def change
    if !table_exists?('inspections')
      create_table :inspections do |t|
        t.integer :rid
        t.integer :eid
        t.integer :iid
        t.string  :etype
        t.string  :status
        t.string  :details
        t.string  :date
        t.string  :severity
        t.string  :action
        t.string  :outcome
        t.integer :mipy
        t.integer :version
        t.integer :venue_id
        t.timestamps
      end
      add_index :inspections, :eid
    end
  end
end
=begin
    
<ROW>
  <ROW_ID>2</ROW_ID>
  <ESTABLISHMENT_ID>1222579</ESTABLISHMENT_ID>
  <INSPECTION_ID>103420091</INSPECTION_ID>
  <ESTABLISHMENT_NAME>SAI-LILA KHAMAN DHOKLA HOUSE</ESTABLISHMENT_NAME>
  <ESTABLISHMENTTYPE>Food Take Out</ESTABLISHMENTTYPE>
  <ESTABLISHMENT_ADDRESS>870 MARKHAM RD </ESTABLISHMENT_ADDRESS>
  <ESTABLISHMENT_STATUS>Pass</ESTABLISHMENT_STATUS>
  <MINIMUM_INSPECTIONS_PERYEAR>2</MINIMUM_INSPECTIONS_PERYEAR>
  <INFRACTION_DETAILS>Operator fail to properly wash surfaces in rooms</INFRACTION_DETAILS>
  <INSPECTION_DATE>2015-01-08</INSPECTION_DATE>
  <SEVERITY>M - Minor</SEVERITY>
  <ACTION>Notice to Comply</ACTION>
  <COURT_OUTCOME> </COURT_OUTCOME>
  <AMOUNT_FINED> </AMOUNT_FINED>
</ROW>

    
=end