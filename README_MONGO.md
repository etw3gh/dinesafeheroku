# MongoDB

## Structure 

### Collections (Tables)

App Admin collection: ENV['OC_MONGO_COLLECTION']
Venue Types: 'venue_types'
Users: 'users'

## ENV variables

Add to .bashrc and Heroku settings according to your setup

<!-- language: lang-none -->

    export OC_MONGO_PWD=         password
    export OC_MONGO_PORT=        non standard connection port
    export OC_MONGO_IP=          server address
    export OC_MONGO_DB=          admin database
    export OC_MONGO_USER=        admin user
    export OC_MONGO_COLLECTION=  dinesafe collection
    export OC_DS_USER=           app user (access OC_MONGO_COLLECTION only)
    export OC_MONGO_DS=          app database 

## Connect script

    ./scripts/mongo.sh

## admin connection

    ./scripts/mongo.sh --admin [ or -a ] 


## User Roles

Grant roles as required

db.grantRolesToUser({'USER', [{'role': 'roleName', 'db': 'DATABASE'}]})


<!-- language: lang-none -->

    db.system.users.find().pretty()
    {
        "_id" : "admin.admin" ...   
    },
    {
        "_id" : "admin.ds",
        "user" : "ds",
        "db" : "dinesafe",
        "credentials" : {...
        },
        "roles" : [
            {
                "role" : "readWrite",
                "db" : "dinesafe"
            },
            {
                "role" : "userAdminAnyDatabase",
                "db" : "dinesafe"
            },
            {
                "role" : "dbAdminAnyDatabase",
                "db" : "dinesafe"
            },
            {
                "role" : "readWriteAnyDatabase",
                "db" : "dinesafe"
            }
        ]
    }