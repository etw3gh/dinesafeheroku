#!/usr/bin/env python3
import shapefile, os, sys, json
from shapefile import ShapefileException

class MiniAddress:
  def __init__(self, num, name, lat, lng, mun, lonum, hinum, lonumsuf, hinumsuf, locname):
    self.num = num
    self.name = name        #rename to street name
    self.lat = lat
    self.lng = lng
    self.mun = mun

    self.lonum = lonum
    self.hinum = hinum

    self.lonumsuf = str(lonumsuf.strip()).lstrip("b'").replace("'", '')
    self.hinumsuf = str(hinumsuf.strip()).lstrip("b'").replace("'", '')
    self.locname = str(locname.strip()).lstrip("b'").replace("'", '')      # for parks , churches etc....


    # street name not in this dict because it each name will be an array of these dicts
    self.address = {'num': self.num, 'lat': self.lat, 'lng': self.lng, 'mun': self.mun, 'lo': self.lonum, 'los': self.lonumsuf, 'hi': self.hinum, 'his': self.hinumsuf, 'locname': self.locname}

  def __str__(self):
    s = '{} {} ({}, {}) -- {} {} -- lo:{}{}-hi{}{}'.format(self.num, self.name, self.lat, self.lng, self.mun, self.locname, self.lonum, self.lonumsuf, self.hinum, self.hinumsuf)
    return s

class ShapeRip:
  def __init__(self, DBF_path):

    # the DBF file depends on all of the other files in the archive
    # the shapefile reader uses it to access the others

    self.address_dict  = {}

    self.sfreader = None
    try:

      self.sfreader = shapefile.Reader(DBF_path)
    except ShapefileException as e:
      exc_type, exc_obj, exc_tb = sys.exc_info()
      print('elineno: {}, error: {}'.format(str(exc_tb.tb_lineno), str(e)))
      sys.exit(2)

    # Address Point Indices
    # Values not required are commented out
    # TODO examine 15A Finch AVE W
    self.A = {  #'GEO_ID'        : 0,  #unique geographic identifier
                #'LFN_ID'        : 1,  #the street name identification number
                #'LINK'      : 2,  #link to geo_id of the primary address
                'street_number' : 3,  #address number with out suffix
                'street_name'   : 4,  #Street Name
                'LONUM'         : 5,  #Address low number
                'LONUMSUF'      : 6,  #Low number suffix
                'HINUM'         : 7,  #Address High Number
                'HINUMSUF'      : 8,  #High Number suffix
                #'ARC_SIDE'      : 9,  #the location of the address point with respect to the street (left or right side of the direction
                #'DISTANCE'      : 10, #the distance from the start of the street segment along the street segment
                #'FCODE'         : 11, #Feature code number
                #'FCODE_DES'     : 12, #Feature code description
                #'CLASS'         : 13, #Address classification (primary, structure, entrance address etc.)
                'LOC_NAME'       : 14, #(if exists e.g. churches, schools, parks etc.)
                #'X'             : 15, #X
                #'Y'             : 16, #Y
                'LONGITUDE'     : 17, #LONGITUDE
                'LATITUDE'      : 18, #LATITUDE
                #'OBJECTID'      : 19, #OBJECTID
                'MUN_NAME'      : 20, #MUNICIPALITY_NAME
                #'WARD_NAME'     : 21, #WARD_NAME
             }

    """
    each record from the reader looks like this
    0          1         2           3      4           5    6    7  8    9    10     11       12         13    14    15          16            17              18              19    20       21
    [10223523, 10223519, 'REGULAR', '128', 'Spears St', 128, b'', 0, b'', 'L', 15.82, 115001, 'Unknown', 'Land', b'', 306325.749, 4837278.662, -79.4808837185, 43.6774597367, 2495484, 'York', 'York South-Weston (11)']
    def __init__(self, num, name, lat, lng, mun, lonum, hinum, lonumsuf, hinumsuf, locname):
    """

  def extract_address(self, row):
    A = self.A
    snum = row[A['street_number']]
    sname = row[A['street_name']]
    lat = row[A['LATITUDE']]
    lng = row[A['LONGITUDE']]
    mun = row[A['MUN_NAME']]
    lonum = row[A['LONUM']]
    hinum = row[A['HINUM']]
    lonumsuf = row[A['LONUMSUF']]
    hinumsuf = row[A['HINUMSUF']]
    locname = row[A['LOC_NAME']]

    address = MiniAddress(snum, sname, lat, lng, mun, lonum, hinum, lonumsuf, hinumsuf, locname)
    return address

  def rip(self):
    if self.sfreader is None:
      print('no shapefile reader')
      sys.exit(2)

    records = self.sfreader.records()
    for i in range(len(records)):
      a = self.extract_address(records[i])
      if a.name not in self.address_dict.keys():
        # init street on first occcurence
        self.address_dict[a.name] = []
      self.address_dict[a.name].append(a.address)



# run as main assuming extracted shapefiles are present in folder 'shapefiles'
# option run with -t to prefix a temp file id 
# python3 shaperip.py source_filepath dest_dir
if __name__ == '__main__':
  print(sys.argv)
  if (len(sys.argv) < 3):
    sys.stderr.write('usage: python3 shaperip.py source_filepath dest_dir\n')
    sys.exit(2)
  
  source_file = sys.argv[1]
  dest_dir = sys.argv[2]

  s = ShapeRip(source_file)

  timestamp = source_file.split('/')[-2]
  dest_file = '{}_geo.json'.format(timestamp)


  s.rip()
  j = json.dumps(s.address_dict)
  dest = os.path.join(dest_dir, dest_file)

  # prevent overwriting of file
  if os.path.exists(dest):
    dest = os.path.join(dest_dir, 'dupe_' + dest_file)

  with open(dest, 'w') as jfile:
    jfile.write(j)
