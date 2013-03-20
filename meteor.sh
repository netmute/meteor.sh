#!/bin/bash

# IP or URL of the server you want to deploy to
export APP_HOST=example.com

# Uncomment this if your host is an EC2 instance
# export EC2_PEM_FILE=path/to/your/file.pem

# You usually don't need to change anything below this line

export APP_NAME=meteorapp
export ROOT_URL=http://$APP_HOST
export APP_DIR=/var/www/$APP_NAME
export MONGO_URL=mongodb://localhost:27017/$APP_NAME
if [ -z "$EC2_PEM_FILE" ]; then
    export SSH_HOST="root@$APP_HOST" SSH_OPT=""
  else
    export SSH_HOST="ubuntu@$APP_HOST" SSH_OPT="-i $EC2_PEM_FILE"
fi
if [ -d ".meteor/meteorite" ]; then
    export METEOR_CMD=mrt
  else
    export METEOR_CMD=meteor
fi

case "$1" in
setup )
echo Preparing the server...
echo Get some coffee, this will take a while.
ssh $SSH_OPT $SSH_HOST DEBIAN_FRONTEND=noninteractive 'sudo -E bash -s' > /dev/null 2>&1 <<'ENDSSH'
apt-get update
apt-get install -y python-software-properties
add-apt-repository ppa:chris-lea/node.js-legacy
apt-get update
apt-get install -y build-essential nodejs npm mongodb
npm install -g forever
ENDSSH
echo Done. You can now deploy your app.
;;
deploy )
echo Deploying...
$METEOR_CMD bundle bundle.tgz > /dev/null 2>&1 &&
scp $SSH_OPT bundle.tgz $SSH_HOST:/tmp/ > /dev/null 2>&1 &&
rm bundle.tgz > /dev/null 2>&1 &&
ssh $SSH_OPT $SSH_HOST MONGO_URL=$MONGO_URL ROOT_URL=$ROOT_URL APP_DIR=$APP_DIR 'sudo -E bash -s' > /dev/null 2>&1 <<'ENDSSH'
if [ ! -d "$APP_DIR" ]; then
mkdir -p $APP_DIR
chown -R www-data:www-data $APP_DIR
fi
pushd $APP_DIR
forever stop bundle/main.js
rm -rf bundle
tar xfz /tmp/bundle.tgz -C $APP_DIR
rm /tmp/bundle.tgz
pushd bundle/server/node_modules
rm -rf fibers
npm install fibers
popd
chown -R www-data:www-data bundle
patch -u bundle/server/server.js <<'ENDPATCH'
@@ -286,6 +286,8 @@
     app.listen(port, function() {
       if (argv.keepalive)
         console.log("LISTENING"); // must match run.js
+      process.setgid('www-data');
+      process.setuid('www-data');
     });

   }).run();
ENDPATCH
forever start bundle/main.js
popd
ENDSSH
echo Your app is deployed and serving on: $ROOT_URL
;;
* )
cat <<'ENDCAT'
./meteor.sh [action]

Available actions:

  setup   - Install a meteor environment on a fresh Ubuntu server
  deploy  - Deploy the app to the server
ENDCAT
;;
esac
