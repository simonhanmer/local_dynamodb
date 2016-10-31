# local_dynamodb

A script to install the version of dynamodb from AWS that run's locally and sets up a systemd service to stop, start etc.

##Dependencies.
It's best to check http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html but currently the main dependency is that the Java runtime must be version 6 or newer.

## Installation.
1. Grab the **dynamodb_setup.sh** script from https://github.com/simonhanmer/local_dynamodb.
2. Run ***sudo bash ./dynamodb_setup.sh***

This will install the jar and associated files to */opt/dynamodb* and the datafiles for the database to */opt/dynamodb/data*. **Obviously you should check any code you download and run via sudo!!**

##Starting and Stopping dynamodb
The script setups a systemd service called dynamodb-server. The service can be started with the command 
> ***systemctl start dynamodb-server***

and stopped via 

>***systemctl stop dynamodb-server***



# DISCLAIMER
as above, you should check any code you download and run on your servers - I can't talk to the code from AWS, but mine might cause your server to catch fire, meltdown and burrow to the core of the earth.