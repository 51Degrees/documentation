'use strict';

// Pattern-library build: compile the SCSS design system to CSS.
//
// Pattern Lab (the old PHP/Twig preview) has been retired in favour of
// Storybook (see .storybook/ and stories/). Storybook imports the compiled
// docs-main.css, so this gulpfile is now only responsible for SCSS -> CSS.
// The SCSS uses glob @imports (e.g. '01-base/**/*.scss') which gulp-sass-glob
// resolves; that is why compilation stays in gulp rather than moving to Vite.

var config = {};
config.sass = {
  srcFiles: ['./source/sass/*.scss'],
  watchFiles: ['./source/sass/**/*.scss'],
  options: {
    includePaths: [
      './source/sass',
      './node_modules/normalize.css/'
    ],
    outputStyle: 'expanded'
  },
  destDir: './source/css'
};

var gulp = require('gulp');
// gulp-sass v5+ needs the compiler passed explicitly; use Dart Sass (the
// maintained implementation), not the deprecated node-sass.
var sass = require('gulp-sass')(require('sass'));
var sassGlob = require('gulp-sass-glob');
var sourcemaps = require('gulp-sourcemaps');
var cleanCSS = require('gulp-clean-css');
var size = require('gulp-size');
var rename = require('gulp-rename');
// gulp-autoprefixer 9.x is ESM-only; via CJS the function is on .default.
var autoprefixer = require('gulp-autoprefixer').default;

// Compile SCSS -> CSS.
gulp.task('sass', function () {
  return gulp.src(config.sass.srcFiles)
    .pipe(sassGlob())
    .pipe(sourcemaps.init())
    .pipe(size())
    .pipe(sass(config.sass.options).on('error', sass.logError))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(config.sass.destDir));
});

// Autoprefix the unversioned main.css.
gulp.task('prefix-css', function () {
  return gulp.src(config.sass.destDir + '/main.css')
    .pipe(autoprefixer({ overrideBrowserslist: ['last 2 versions'] }))
    .pipe(gulp.dest(config.sass.destDir));
});

// Minify the *main.css outputs to *.min.css.
gulp.task('minify-css', function () {
  return gulp.src(config.sass.destDir + '/*main.css')
    .pipe(cleanCSS())
    .pipe(rename({ suffix: '.min' }))
    .pipe(gulp.dest(config.sass.destDir));
});

// Full CSS build (consumed by ci/build-pattern-library.ps1).
gulp.task('sass-change', gulp.series('sass', 'prefix-css', 'minify-css'));

// Recompile on change (Storybook handles preview/refresh).
gulp.task('watch', function () {
  gulp.watch(config.sass.watchFiles, gulp.series('sass'));
});

gulp.task('default', gulp.series('sass-change'));
