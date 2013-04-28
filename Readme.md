# Dry
Dry is a langague that compiles to JavaScript, specifically created for Frontend Development.
## Docs
See the [Wiki](https://github.com/gdotdesign/dry/wiki/_pages).
## Install
Dry is available through NPM:
```
npm install dry-lang -g
```
## CLI
Compile single file
```
dry -i path/to/file.dry -o path/to/file.js
```
Run static web server which compiles all dry files and serves other files (from CWD)
```
dry -w
------------------------------------------
Dry workspace is ready at http://localhost:4000/
```
Help
```
dry -h
------------------------------------------
Options:
  -i, --input      Input File            
  -o, --output     Output File           
  -v, --version    Version               
  -l, --log        Verbose logging       
  -w, --workspace  Run development server
  -h, --help       Show help             
  --install        Install packages 
```
