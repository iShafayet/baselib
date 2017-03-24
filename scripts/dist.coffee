
cslib = require 'coffee-script'
fslib = require 'fs'
pathlib = require 'path'


## INPUT

path = (pathlib.join process.cwd(), '/index.coffee')

input = fslib.readFileSync path, {encoding: 'utf8'}

## PROCESSING

output = cslib.compile input

output = "window['baselib'] = {};\n\n" + output

if (index = output.lastIndexOf '}).call(this);') is -1
  throw new Error 'Something went wrong, 1'

output = output.slice 0, index

output += '}).call(window[\'baselib\']);\n\n'

## OUTPUT

path = (pathlib.join process.cwd(), 'package.json')

directives = fslib.readFileSync path, {encoding: 'utf8'}

directives = JSON.parse directives

version = directives.version

path = (pathlib.join process.cwd(), '/build-dist-browser')

fslib.mkdirSync path unless fslib.existsSync path

path = (pathlib.join path, "/baselib-#{version}.js")

fslib.writeFileSync path, output, {encoding:'utf8'}

console.log "Compiled to \"#{path}\"\n\n"

