global.LOG = console.log
global.LOGY = console.warn
global.LOGR = console.error
import './api'
import {nanoid} from 'nanoid'
import 'imba/preflight.css'
import './font.css'
import './tags'
import {new_dict} from './2023-07-29-cambodia-u-dictionary.imba'
# LOG new_dict
# import {dictionary} from "./2023-07-29-cambodia-u-dictionary.imba"
global css @root
	1sp: .6em
	hue:indigo
	bg:gray0
	p:1sp
	* gap:1sp
	kbd bd:2px solid hue2 rd:md fs:xs ml:1sp c:hue4 px:.5sp py: .2sp
	button.button
		bg:white
		p:1sp
		bd:1px solid gray2
		rd:1sp
		@hover
			bg:hue1
			&.delete
				bg:rose2
tag App
	def build
		local.load!
	
	def save
		local.save!
	
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
		save!
		imba.commit!
	
	def deleteWord id
		local.deleteWord(id)
		save!
		imba.commit!
	
	def restore
		LOG 'json.load!', 'save!'
		await json.load!
		save!
		imba.commit!
	
	def load
		LOG 'local.load!'
		local.load!
		imba.commit!
	def backup
		LOG 'json.save!'
		json.save!
		
	def empty arg
		if Array.isArray(arg)
			return arg.length is 0
		else
			if typeof arg is 'object'
				return Object.keys(arg).length is 0
			if typeof arg is 'string'
				return arg is ''
			if typeof arg is 'number'
				return arg is 0
	<self>
		# console.log 'editing', word.editing, 'dictionary', word.dictionary 
		
		<%top-nav>
			css d:hflex
				mb:1sp
			<button.button @click.backup> "j.save"
			<button.button @click.restore> "j.load"
			<button.button @click.save> "save"
			<button.button @click.load> "load"
			<button.button @click.add> "add"
			
			# if Object.keys(state.editing).length > 0
			# console.log state.dictionary
		<section>
			css d:grid grid-template-columns: 1fr
				.card
					bg:white
					p:1sp
					bd:1px solid gray2
					rd:md
					bxs:sm,xl
			<[d:hflex]>
				<input bind=card_query>
			# NOTE: show editor at top of list id of state.editing is not in state.dictionary.
			if !empty(state.editing) 
			and state.dictionary[state.editing.id] is undefined
				<word-editor.card >

			# NOTE: show editor in place of card, when card's id is in state.editing
			for own id, value of state.dictionary
				if !empty(state.editing)
				and id is state.editing.id
					<word-editor.card>
				else
					<dictionary-card.card dict_item_data=value>
			# <word-editor.card >




imba.mount <App>, document.getElementById('app')
