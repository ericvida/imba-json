import {nanoid} from 'nanoid'
let local_storage = imba.locals('word-editor')
let state = {
	editing: undefined
	dictionary: undefined
}

class Word
	
	def edit data
		state.editing = data
	def add
		state.editing =
			id: nanoid!
			spellings: ["spelling"] # sometimes khmer words can have multiple acceptable spellings
			phonetics: [
				vida: ["vida"]
				ipa: ["ipa"]
				arpabet: ["arpabet"]
			]
			definitions: [
				use: "use"
				english: ["english"]
				source: "source"
			]
		
	def cancel
		state.editing = undefined
	
	def deleteWord id
		if state.editing
			delete state.dictionary[id]
			state.editing = undefined
	
	def save data
		state.dictionary[data.id] = data
		state.editing = undefined

class LocalAPI
		
	def loadDictionary
		if local_storage.dictionary isnt undefined
			state.dictionary = local_storage.dictionary
	
	def loadEditing
		if local_storage.editing isnt undefined
			state.editing = local_storage.editing
	
	def load
		loadDictionary!
		loadEditing!
		
	def save
		local_storage.dictionary = state.dictionary
		local_storage.editing = state.editing
		console.log 'local', local_storage.dictionary
		
	def deleteWord id
		console.log 'deleting', id
		delete state.dictionary[id]
		console.log state.dictionary
	def log
		console.log 'l.dict', local_storage.dictionary
		console.log 'l.editing', local_storage.editing
class JsonAPI
	
	def load
		# fetch response from '/load' route
	
		try
			const res = await window.fetch("/dictionary")
			state.dictionary = await res.json()
			console.log 'restored from json', state.dictionary
	
		catch e
			console.error "couldn't load dictionary"
	
	def save
		
		try
			const response = await window.fetch("/save/dictionary", {
				method: "POST"
				headers: {"Content-Type": "application/json"}
				body: JSON.stringify(state.dictionary)
			})
			const result = await response
			console.log "Success", result
		
		catch e
			console.error "Error", e

const word = new Word
const local = new LocalAPI
const json = new JsonAPI

extend tag Element
	get state
		return state
	get word
		return word
	get local
		return local
	get json
		return json
