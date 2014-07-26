var gulp = require('gulp');
var exec = require('child_process').exec;
var jasmine = require('gulp-jasmine');

gulp.task('task', function (cb) {
  exec('rm -rf *', function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
    cb(err);
  });
})

gulp.task('deploy', ['build'], function(cb) {
	 exec('fly production', function (err, stdout, stderr) {
    if (err) {
    	console.error(stderr, err);
    	return cb(err);
    }
    console.log(stdout);
    cb();
  });
});


gulp.task('build', function(cb) {
	cb();
});