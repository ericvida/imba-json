import {nanoid} from 'nanoid'
let local_storage = imba.locals('word-editor')

class StateAPI
	constructor
		editing = {}
		editing_original = {}
		dictionary = {}
		# POS TAGS: https://github.com/ye-kyaw-thu/khPOS/blob/master/README.md
		phonetic_system = "ipa"
		sources = [
			"UNDEFINED"
			"vida",
			"google",
			"oxford",
			"gk",
			"other",
			]
		pos = [
			"UNDEFINED", #
			"Noun", # នាម
			"Conjugation", # នាម
			"Pronoun", # សព្វនាម
			"Verb", # កិរិយាសព្ទ
			"Adjective", # គុណនាម
			"Adverb", # គុណកិរិយា
			"Preposition", # ធ្នាក់
			"Conjunction", # ឈ្នាប់
			"Interjection", # ឧទានសព្ទ
			"Particle",
			"Postpositional Marker",
			"Phrase final",
			"Abbreviation",
			"Auxiliary verb",
			"Currency",
			"Number",
			"Double Sign",
			"Determiner",
			"Et Cetera",
			"Full Stop",
			"Measure Word",
			"Question Word",
			"Relative Pronoun",
			"Symbol",
			"Interjection"
			] 	
export let state = new StateAPI
class UserAPI
	
	def changePhoneticSystem system
		state.phonetic_system = system

class WordAPI
	
	def edit dictionary_item_data
		state.editing = dictionary_item_data
		
	def add
		state.editing =
			id: nanoid!
			spellings: [""] # sometimes khmer words can have multiple acceptable spellings
			vida: [""]
			ipa: [""]
			romanized: [""]
			pos: {
				"": {
					"": [""]
				}
			}
	def cancel
		state.dictionary[state.editing_original.id]	= state.editing_original
		state.editing = {}
		# console.log 'cancel', state.dictionary[state.editing_original.id], state.editing_original
	
	def deleteWord id
		if state.editing
			delete state.dictionary[state.editing.id]
			state.editing = {}
	
	def save
		state.dictionary[state.editing.id] = state.editing
		state.editing = {}

class LocalAPI
		
	def loadDictionary
		if local_storage.dictionary
			state.dictionary = local_storage.dictionary
	
	def loadEditing
		if local_storage.editing
			state.editing = local_storage.editing
	
	def loadPhoneticSystem
		if local_storage.phonetic_system
			state.phonetic_system = local_storage.phonetic_system
	
	def load
		loadDictionary!
		loadEditing!
		loadPhoneticSystem!
		
	def save
		local_storage.dictionary = state.dictionary
		local_storage.editing = state.editing
		local_storage.phonetic_system = state.phonetic_system
		# local_storage.editing_original = state.editing_original
		# console.log 'saved all to local'
		
	def deleteWord id
		delete state.dictionary[id]
		# console.log 'word deleted', id
	
	def log
		console.log 'l.dict', local_storage.dictionary
		console.log 'l.editing', local_storage.editing
		console.log 'l.phonetic_system', local_storage.phonetic_system
class JsonAPI
	
	def load
		# fetch response from '/load' route
	
		try
			const res = await window.fetch("/dictionary")
			state.dictionary = await res.json()
			console.log 'restored from json'
	
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

const word = new WordAPI
const local = new LocalAPI
const json = new JsonAPI
const user = new UserAPI
extend tag Element
	get user
		return user
	get state
		return state
	get word
		return word
	get local
		return local
	get json
		return json
