const gulp = require('gulp');
const plumber = require('gulp-plumber');

const serve = require('gulp-serve');

const merge = require('gulp-merge');
const concat = require('gulp-concat');

const pug = require('gulp-pug');
const sass = require('gulp-sass');
const coffee = require('gulp-coffee');
const uglify = require('gulp-uglify');
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

gulp.task('js', function() {
	merge(
		gulp.src('src/assets/js/*.coffee')
			.pipe(plumber())
			.pipe(coffee({bare: true}))
	,
		gulp.src('src/assets/js/*.js')
			.pipe(plumber())
	)
		.pipe(concat('app.min.js'))
		.pipe(uglify())
		.pipe(gulp.dest('./dist/assets/js'));
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
	port: 8080,
	hostname: '0.0.0.0'
}));

// Wrap 'em up in one big compile task
gulp.task('compile', ['pug', 'sass', 'js', 'images', 'favicons']);

// And add a default task with livereload
gulp.task('default', ['compile', 'serve'], function() {
	gulp.watch('src/**/*.js', ['js']);
	gulp.watch('src/**/*.pug', ['pug']);
	gulp.watch('src/**/*.sass', ['sass']);
	gulp.watch(['src/assets/js/*.coffee', 'src/assets/js/*.js'], ['js']);
	gulp.watch(['src/**/*.jpg', 'src/**/*.png', 'src/**/*.svg'], ['images']);
});
