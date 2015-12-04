gulp = require 'gulp'
plugins = require('gulp-load-plugins')(
  pattern: ['gulp-*', 'gulp.*', 'del', 'nib'],
  replaceString: /\bgulp[\-.]/
)

electron = require('electron-connect').server.create()

# Asset source and destination directories
distPath = './assets'
srcPath = './src'
bowerPath = './bower_components'


# Javascript library files
jsLibFiles = [
]

# Javascript source files (Coffeescript)
jsFiles = [
  srcPath+'/js/app.coffee'
]

# CSS source files (bower)
cssLibFiles = [
    bowerPath+'/normalize-css/normalize.css',
    bowerPath+'/font-awesome/css/font-awesome.css',
    bowerPath+'/bootstrap/dist/css/bootstrap.min.css'
]

fontFiles = [
    bowerPath+'/fontawesome/fonts/fontawesome-webfont.ttf',
    bowerPath+'/fontawesome/fonts/fontawesome-webfont.eot',
    bowerPath+'/fontawesome/fonts/fontawesome-webfont.woff',
    bowerPath+'/fontawesome/fonts/fontawesome-webfont.woff2',
    bowerPath+'/fontawesome/fonts/fontawesome-webfont.svg'
]


gulp.task 'copy-js-dependencies', ->
  gulp.src jsLibFiles
    .pipe gulp.dest distPath+'/js'


gulp.task 'copy-fonts', ->
  gulp.src fontFiles
    .pipe gulp.dest distPath+'/fonts'


gulp.task 'copy-css', ['copy-fonts'], ->
  gulp.src cssLibFiles
    .pipe gulp.dest distPath+'/css'


# Build CSS from stylus sources
gulp.task 'build-css', ['copy-css'], ->
  gulp.src srcPath+'/css/*.styl'
    .pipe plugins.plumber()
    .pipe plugins.sourcemaps.init()
    .pipe plugins.stylus
      use: plugins.nib()
    .pipe plugins.autoprefixer
      browsers:['last 10 versions']
    .pipe plugins.sourcemaps.write()
    .pipe gulp.dest distPath+'/css'


# Delete generated css/js files from dist directory
# and vendor files in src directory copied from
# bower_components
gulp.task 'clean', (cb)->
  plugins.del [
    distPath+'/css/*.css',
    distPath+'/js/*.js',
    distPath+'/html'
  ], cb


# Coffeescript compilation
gulp.task 'build-js', ['copy-js-dependencies'], ->
  gulp.src srcPath+'/js/**/*.coffee'
    .pipe plugins.plumber()
    .pipe plugins.coffeelint()
    .pipe plugins.coffeelint.reporter()
    .pipe plugins.sourcemaps.init()
    .pipe plugins.coffee()
    .pipe plugins.sourcemaps.write()
    #.pipe plugins.concat 'app.js'
    .pipe gulp.dest distPath+'/js'


# Uglify Javascript
gulp.task 'uglify-js', ['build-js'], ->
  gulp.src [distPath+'/js/*.js', '!'+distPath+'/js/*.min.js', '!'+distPath+'/js/*-min.js']
    .pipe plugins.uglify().on('error', plugins.util.log)
    .pipe plugins.rename
      suffix: '.min'
    .pipe gulp.dest distPath+'/js'


# Compile jade templates
gulp.task 'jade-tpl', ->
  gulp.src [srcPath+'/templates/**/*.jade', '!'+srcPath+'/templates/_mixins/*.jade', '!'+srcPath+'/templates/layouts/*.jade']
    .pipe plugins.plumber()
    .pipe plugins.jade pretty: true
    .pipe gulp.dest distPath


# Default: Build theme and keep watching for changes
gulp.task 'default', ['clean'], ->

  gulp.src srcPath+'/css/**/*.styl'
    .pipe plugins.watch srcPath+'/css/**/*.styl', ->
      gulp.start 'build-css'

  gulp.src srcPath+'/js/*.coffee'
    .pipe plugins.watch srcPath+'/js/**/*.coffee', ->
      gulp.start 'uglify-js'

  gulp.src srcPath+'/**/*.jade'
    .pipe plugins.watch srcPath+'/**/*.jade', ->
      gulp.start 'jade-tpl'

  electron.start()
  plugins.watch [distPath+'/css/style.css',distPath+'/index.html',distPath+'/js/app.js'], electron.reload
  plugins.watch distPath+'/js/main.js', electron.restart


# Build without watch
gulp.task 'build', ['clean'], ->
  gulp.start 'build-css'
  gulp.start 'uglify-js'
  gulp.start 'jade-tpl'
