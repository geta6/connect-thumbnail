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
  * request timeout, default 5000.

## MIT LICENSE
Copyright &copy; 2013 geta6 licensed under [MIT](http://opensource.org/licenses/MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
