#Stackmob JS SDK for NodeJS

See [http://www.stackmob.com/devcenter/docs/JS-SDK-Tutorial](http://www.stackmob.com/devcenter/docs/JS-SDK-Tutorial)

Change Logs (May 4, 2012):

*   Update to StackMob JS v. 0.2.1
*   Use lodash instead of underscore
*   Extension written in Coffeescript

Install:
    
    npm install stackmob-nodejs

##Examples    

Init:

    var StackMob;
    StackMob = require("stackmob-nodejs");
    StackMob.init({
      urlRoot: "http://api.mob1.stackmob.com/",
      consumerKey: "publicKey",
      consumerSecret: "privateKey",
      appName: "appName",
      version: 0,
      dev: true
    });

Read: 

    var username = "anonymous";
    if (username != '') {
      //Call StackMob via Ajax to read a user
      var fetchuser = new StackMob.User({ 'username': username });
      fetchuser.fetch({
        success: function(model) {
          console.log("We fetched the user from StackMob!");
          console.log(model.toJSON());
        },
        error: function(model, response) {
          console.log(response);
        }
      });
    }


Create:

    var user;
    user = new StackMob.User({
      username: "Chuck Norris",
      password: "myfists",
      weaponofchoice: "nunchucks"
    });
    user.create();
    