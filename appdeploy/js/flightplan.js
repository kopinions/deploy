var Flightplan = require('flightplan');


var plan = new Flightplan();

// configuration
plan.briefing({
  debug: true,
  destinations: {
    'production': [
      {
        host: 'localhost',
        username: 'vagrant',
        port: 2222,
        privateKey: "/Users/twer/.vagrant.d/insecure_private_key"
      }
    ]
  }
});

plan.remote(function(remote) {
  remote.log('Move folder to web root');
 
	remote.exec('git clone https://github.com/almazhou/express-mysql.git', '/home/vagrant');
	
  remote.log('Install dependencies');
  remote.with('cd /home/vagrant', function() {
  	remote.ls('-l');
  	remote.exec('npm install');
  	remote.exec('nohup node app.js &');
  });
});