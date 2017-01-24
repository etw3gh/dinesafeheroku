# task order 


## to reset
`bin/rails db:environment:set RAILS_ENV=development`

`rake db:drop db:create db:migrate`

## purge downloaded files if after reset

`rake arch:rmgeo`

`rake arch:rmxml`

## run rake tasks in this order

### get archives from helper server

`rake arch:get`

### verify with rake downloads

`rake arch:downloads`

should show filenames: 

xml: lib/assets/1484577503.0_dinesafe.xml, geo: lib/assets/1474461890.0_geo.json

### process geo data (TAKES SEVERAL HOURS)

`rake seed:geo`

### proceess dinesafe

`rake seed:dinesafe`