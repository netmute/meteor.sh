# This project is not maintained anymore!

As you have probably noticed, nothing happened here for years.

The script is most likely broken in all kind of ways, please don't use it on anything important anymore.

This project now exists mostly as an archive to satisfy your curiousity.

# Meteor.sh

## What?

Meteor.sh is a simple Shellscript to setup a Meteor server and deploy Meteor apps to it.

## Why?

Because deploying to custom servers should be as simple as everything else in Meteor.

## Awesome, tell me what to do.

### Before we start:

Meteor.sh assumes that you have some kind of Ubuntu-Server and root access to it.

Move the `meteor.sh` file into your project dir and change the `APP_HOST` variable.

Meteor.sh will try to SSH as root to `APP_HOST`.

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
