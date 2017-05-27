### Security

#### HTTPS only

Registered clients (web apps from specific domains) are forced to use https

<!-- language: lang-none -->

    // http://stackoverflow.com/a/4723302/6826791
    forceHttps = () => {
        const notHttps = location.protocol != 'https:'
        const notLocal = location.href.indexOf('localhost') === -1

        if (notHttps && notLocal) {
        location.href = 'https:' + window.location.href.substring(window.location.protocol.length);
        }
    }


#### Request Layer

Calling the API by AJAX is locked to certain domains (web apps), which are stored in an environment variable

> The client web app will sanitize user input before it reaches the rails app 

Calling from the browser is disabled [use Postman](https://www.getpostman.com/)

Calling by CURL or Postman requires an API key which is also stored in an environment variable

#### Segment Layer

Segments must conform to regex or the request will be 404'd

#### Controller Layer

A request will be rejected if it contains any hint of SQL injection (TODO)

#### SQL Injection 

Apart from locking requests to known client apps, user input will be checked for SQL injection

PostgreSQL reserved keywords are obtained by this query:

    SELECT word FROM pg_get_keywords() WHERE catdesc='reserved';