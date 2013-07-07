# modules

module.exports = (options = {}) ->

  _ = require 'underscore'
  fs = require 'fs'
  path = require 'path'
  mime = require 'mime'
  music = require 'musicmetadata'
  async = require 'async'
  mktemp = require 'mktemp'
  {exec} = require 'child_process'

  options.ext or= 'thumbnail'
  options.path or= path.resolve()
  options.cache or= '/tmp'
  options.timeout or= 5000

  return (req, res, next) ->

    regex = new RegExp "\.#{options.ext}$"
    if regex.test req._parsedUrl.pathname
      req.connection.setTimeout options.timeout
      src = path.join options.path, decodeURI req._parsedUrl.pathname.replace regex, ''
      $stat = (src) -> _.extend (fs.statSync src), { path: src, name: path.basename src }
      return next() unless fs.existsSync src
      src = ( (src) ->
        src = $stat src if typeof src is 'string'
        return [src] unless src.isDirectory()
        data = []
        for file in fs.readdirSync src.path
          data.push file = $stat path.join src.path, file
          data = (data.concat arguments.callee file) if file.isDirectory()
        return data
      )(src)
      return next() if src.length is 0
      src = _.reject src, (src) -> src.isDirectory()
      src = (_.sortBy src, (src) -> -1 * src.mtime)[0]
      tag = "#{src.dev}-#{src.ino}-#{src.mtime.getTime()}"
      if req.headers['if-none-match'] is "\"#{tag}\""
        res.statusCode = 304
        return res.end()
      dst = path.join options.cache, "#{tag}.jpg"
      img = new Buffer if fs.existsSync dst then fs.readFileSync dst else 0
      if 0 < img.length
        res.statusCode = 200
        res.setHeader 'ETag', "\"#{tag}\""
        res.setHeader 'Cache-Control', 'public'
        res.setHeader 'Content-Type', mime.lookup 'jpg'
        res.setHeader 'Content-Length', img.length
        return res.end img

      type = mime.lookup src.name

      async.series [
        (done) ->
          if /^image/.test type
            img = new Buffer fs.readFileSync src.path
            return done null

          if /^audio/.test type
            return (new music fs.createReadStream src.path).on 'metadata', (id3) ->
              return done new Error 'no thumbnail' unless id3.picture[0]
              img = id3.picture[0].data
              return done null

          if /^video/.test type
            return exec "ffmpeg -i '#{src.path.replace(/'/g, "'\\''")}'", (err, stdout, stderr) ->
              time = (stderr.replace /^[\s\S]*Duration: (.*?),[\s\S]*$/, '$1').split ':'
              time = (parseInt time[0])*60*60 + (parseInt time[1])*60 + (parseFloat time[2])
              tmpjpg = mktemp.createFileSync path.join options.cache, 'XXXXXX.jpg'
              exec "ffmpeg -y -ss #{parseInt time/3} -vframes 1 -i '#{src.path}' -f image2 '#{tmpjpg}'", (err) ->
                img = new Buffer fs.readFileSync tmpjpg
                fs.unlinkSync tmpjpg if fs.existsSync tmpjpg
                return done null

          if /pdf$/.test type
            tmppdf = mktemp.createFileSync path.join options.cache, 'XXXXXX.pdf'
            tmpjpg = mktemp.createFileSync path.join options.cache, 'XXXXXX.jpg'
            return exec "pdftk '#{src.path}' cat 1 output '#{tmppdf}' && convert -define jpeg:density=24 -density 24 '#{tmppdf}[0]' '#{tmpjpg}'", (err) ->
              img = new Buffer fs.readFileSync tmpjpg
              fs.unlinkSync tmppdf if fs.existsSync tmppdf
              fs.unlinkSync tmpjpg if fs.existsSync tmpjpg
              return done err

          return done new Error 'no thumbnail'

        (done) ->
          tmp = mktemp.createFileSync path.join options.cache, 'XXXXXX.jpg'
          fs.writeFileSync tmp, img
          exec "convert -define jpeg:size=160x160 -resize 160x160 '#{tmp}' '#{dst}'", (err) ->
            console.error err if err
            img = new Buffer fs.readFileSync dst if fs.existsSync dst
            fs.unlinkSync tmp if fs.existsSync tmp
            return done err

      ], (err) ->
        if err
          console.error err, src.path
          return next()
        res.statusCode = 200
        res.setHeader 'ETag', "\"#{tag}\""
        res.setHeader 'Cache-Control', 'public'
        res.setHeader 'Content-Type', mime.lookup 'jpg'
        res.setHeader 'Content-Length', img.length
        return res.end img
    else
      return next()
