# connect-thumbnail

  connect middleware for generate thumbnail from image, audio, video and pdf file.

## requirement

* imagemagick
* ffmpeg
* pdftk

## install

```
npm install connect-thumbnail
```

## usage

```
app.use(require('connect-thumbnail')({/* options */}));
```

* `<img src='http://example.net/audio.mp3.thumbnail'>`
* directory -> try to thumb latest file includes

## options

### ext [String]

  * __optional__
  * hook extension, default `thumbnail`.

### path [String]

  * __optional__
  * root directory for file name, default `path.resolve()`.

### cache [String]

  * __optional__
  * cache path, default `/tmp`.
  * no regenerate if already exists cached file.

### timeout [Number]

  * __optional__
  * request timeout, default `5000`.

### resize [String]

  * __optional__
  * resize image for imagemagick, default `160x160`.

### errors [Boolean]

  * __optional__
  * show error log, default `false`

### default [String]

  * __optional__
  * fallback image, default `null`
  * search from `#{default}`, `#{path}/#{default}`, `#{PROJECT}/#{default}`

## Fallback

### Fallback from client

  * redirect to `req.query.fallback`
    * `http://example.net/some/file.mp3?fallback=/img/audio.png`
    * returns redirect to `/img/audio.png`

### Fallback from server

  * on fallback, get file info from `res._thumbnail` and `res._thumbnailError`
  * `res._thumbnail` has target file's `stat` + `path`
    * `_.extend(fs.statSync(target), { path: 'path'})`
  * `res._thumbnailError` is instanceof `Error`

```
app.use(require('connect-thumbnail')({
  ext: 'thumbnail'
}));
app.get(/.*\.thumbnail$/, function (req, res) {
  // this section hooks only thumbnail fallback
  if (res._thumbnail) {
    console.log(res._thumbnail);
  }
});
```

## MIT LICENSE
Copyright &copy; 2013 geta6 licensed under [MIT](http://opensource.org/licenses/MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
