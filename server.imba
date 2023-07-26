import express from 'express'
import bodyParser from 'body-parser'
import {FSDB} from 'file-system-db' # https://github.com/WillTDA/File-System-DB
import index from './app/index.html'
const fdb = new FSDB('./db.json', false)

global.LOG = console.log
global.LOGY = console.warn
global.LOGR = console.error

# Using Imba with Express as the server is quick to set up:
const app = express()
const port = process.env.PORT or 3000

# make a post request to save the dictionary
app.post('/save/dictionary', bodyParser.json()) do(req,res)
	# let body = await req.body
	res.send
		fdb.set("dictionary", req.body)

# make get request to get the dictionary
app.get('/load') do(req,res)
	# res.send(req)
	res.send(fdb.getAll())

app.get('/dictionary') do(req,res)
	# res.send(req)
	res.send(fdb.get("dictionary"))

# catch-all route that returns our index.html
app.get(/.*/) do(req,res)
	# only render the html for requests that prefer an html response
	unless req.accepts(['image/*', 'html']) == 'html'
		return res.sendStatus(404)
	res.send(index.body)
# Express is set up and ready to go!
imba.serve(app.listen(port))
