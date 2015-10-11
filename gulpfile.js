var gulp = require('gulp');
var prettify = require('gulp-prettify');
var prettify2 = require('gulp-html-prettify');

gulp.task('prettify', function(){
  gulp.src('mechanize/research/tmp/**/*.html')
    .pipe(prettify({indent_size: 2}))
    .pipe(gulp.dest('mechanize/research'))
});

gulp.task('prettify2', function(){
  gulp.src('mechanize/research/tmp/**/*.html')
    .pipe(prettify2({indent_char: ' ', indent_size: 2}))
    .pipe(gulp.dest('mechanize/research'))
});