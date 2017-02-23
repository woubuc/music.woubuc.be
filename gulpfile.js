const gulp = require('gulp');
const plumber = require('gulp-plumber');

const serve = require('gulp-serve');

const pug = require('gulp-pug');
const sass = require('gulp-sass');
const coffee = require('gulp-coffee');
const imagemin = require('gulp-imagemin');

// Separate tasks to compile Pug to HTML, Sass to CSS and Coffeescript to Javascript

gulp.task('pug', function() {
	gulp.src('src/**/*.pug')
		.pipe(plumber())
		.pipe(pug())
		.pipe(gulp.dest('./dist'));
});

gulp.task('sass', function() {
	gulp.src('src/**/*.sass')
		.pipe(plumber())
		.pipe(sass({outputStyle: 'compressed'}))
		.pipe(gulp.dest('./dist'));
});

gulp.task('coffee', function() {
	gulp.src('src/**/*.coffee')
		.pipe(plumber())
		.pipe(coffee({bare: true}))
		.pipe(gulp.dest('./dist'));
});

gulp.task('js', function() {
	gulp.src('src/**/*.js')
		.pipe(plumber())
		.pipe(gulp.dest('./dist'));
});

gulp.task('images', function() {
	gulp.src(['src/**/*.jpg', 'src/**/*.png', 'src/**/*.svg'])
		.pipe(plumber())
		.pipe(imagemin())
		.pipe(gulp.dest('./dist'))
});

gulp.task('favicons', function() {
	gulp.src('favicons/*').pipe(gulp.dest('./dist'));
})

gulp.task('serve', serve({
	root: ['dist'],
	port: 8080
}));

// Wrap 'em up in one big compile task
gulp.task('compile', ['pug', 'sass', 'coffee', 'js', 'images', 'favicons']);

// And add a default task with livereload
gulp.task('default', ['compile', 'serve'], function() {
	gulp.watch('src/**/*.js', ['js']);
	gulp.watch('src/**/*.pug', ['pug']);
	gulp.watch('src/**/*.sass', ['sass']);
	gulp.watch('src/**/*.coffee', ['coffee']);
	gulp.watch(['src/**/*.jpg', 'src/**/*.png', 'src/**/*.svg'], ['images']);
});
