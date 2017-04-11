# MongoDB

## ENV variables

Add to .bashrc and Heroku settings according to your setup

<!-- language: lang-none -->

    export OC_MONGO_PWD=
    export OC_MONGO_PORT=
    export OC_MONGO_IP=
    export OC_MONGO_DB=
    export OC_MONGO_USER=

## Connect script

    ./localmongo/mongo.sh

## TODO connect params

    ./localmongo/mongo.sh --admin | --ds

## User Role (from admin login)

Grant roles as required

TODO: remove user Admin roles


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