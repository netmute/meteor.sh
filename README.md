# Meteor.sh

## What?

Meteor.sh is a simple Shellscript to setup a Meteor server and deploy Meteor apps to it.

## Why?

Because deploying to custom servers should be as simple as everything else in Meteor.

## Awesome, tell me what to do.

### Before we start:

Meteor.sh assumes that you have some kind of Ubuntu-Server and root access to it.

Move the `meteor.sh` file into your project dir and change the `APP_NAME` and `APP_HOST` variables.

Meteor.sh will try to SSH as root to `APP_HOST`.

#### A note on EC2 support:

If your server happens to be an Amazon EC2 instance, uncomment the `EC2_PEM_FILE` variable and point it to your pem file. Meteor.sh will then do the right things for those instances.

### Install the server:

```
./meteor.sh setup
```

This will install Node, Mongo and other dependencies for Meteor and Meteor.sh on `APP_HOST`.

### Deploy your app:

```
./meteor.sh deploy
```

Deploys your app to the server and starts it as a service.

## Meteorite support

Meteor.sh will detect if your project uses Meteorite and use it accordingly.