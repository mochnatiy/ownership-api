# README

This service contains API to create/delete and transfer ownership of properties
between users.

The solution was made without authlogic or grape/graphql gems because this gems
are not necessary to make it work.


#

A MySQL used as db. Use database.yml.example and

```ruby
rake db:migrate
```
to setup a database

#

Run application by:

```ruby
rails s
```

Run tests suites by:

```ruby
rspec spec
```

# API

Usage of service begins with registration an user. To register an user send request to

```
POST /api/users/register.json
```
with params:

```
login (string), length from 3 to 32
password (string), length from 8 to 20
```

If user is registered, an user id should be returned with status 200, otherwise - error message with status 422.

#

After successful registration user could log in service via API:

```
POST /api/authenticate.json
```

with params:

```
login (string)
password (string)
```

In case of successful authentication a json with auth_key should be returned

#
User is available to create its own properties using auth_key:

```
POST /api/properties/create.json
```

with params:

```
auth_key (string)
title (string)
value (integer)
```

In case of successful creation json with property_id should be returned

Also, after creation user is available to get its own properties

```
POST /api/properties.json
```

with params:

```
auth_key (string)
```

In case of any property available a json with properties should be returned,
otherwise you will get a 404 status

#

User is available to transfer ownership of his property to another user

```
POST /api/ownership_transfers/request_operation.json
```

with params:

```
auth_key (string)
recipient_login (string)
property_id (integer)
```

In case of succesful transaction a json with transfer_key should be returned
This transfer_key should be used by recipient to finish operation:

```
POST /api/ownership_transfers/complete_operation.json
```

with params:

```
auth_key (string)
transfer_key (string)
property_id (integer)
```

In case of successful transction a json with status 200 and success flag should be returned. Otherwise, json would content error message
