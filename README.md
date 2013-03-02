[![Code Climate](https://codeclimate.com/github/anark/virtual-phone.png)](https://codeclimate.com/github/anark/virtual-phone)

Virtual Phone
=============
Virtual Phone provides a simple way to provision numbers for different area codes and forward them to an existing phone.

Virtual Phone can works using twilio, tropo, or a combination of both.

Configuration
=============
Virtual Phone is configured using the environment variables below

to set locally run

    export ADAPTER="tropo"

to set on heroku run

    heroku config:set ADAPTER="tropo"

Configuration Variables

    URL: The base url for running Virtual Phone from.  This is used when provisioning number to direct the numbers to the application. eg. http://test.example.com
    ADAPTER: [twilio, tropo] sets the adapter to use when provisioning new numbers.  Default is twilio.
    TWILIO_ACCOUNT_SID: The account sid for the twilio acount to be used
    TWILIO_AUTH_TOKEN: The auth token for the twilio account to be used
    TROPO_USERNAME: The username for the tropo account to be used
    TROPO_PASSWORD: The password for the tropo account to be used
    TROPO_APPLICATION_ID: The applicaion id for the tropo application

Minimal Setup
=============
TWILIO
------
To use twilio set the following environment variables

    URL
    TWILIO_ACCOUNT_SID
    TWILIO_AUTH_TOKEN
    ADAPTER to twilio

TROPO
-----
To use tropo you must first set up an application in tropo
login to your tropo account and create a new application.
Set the voice url to the url where you will host your application with the path /phones/incoming_call with the method post

    http://virtual-phone.example.com/phones/incoming_call

After this be sure to set the following environment variables

    TROPO_USERNAME
    TROPO_PASSWORD
    TROPO_APPLICATION_ID
    ADAPTER to tropo
