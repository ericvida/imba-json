global.LOG = console.log
global.LOGY = console.warn
global.LOGR = console.error
import './api'


tag dictionary-editor
	def build
		local.load!
		
	def save
		local.save!
	
	def persist
		local.persist!
	
	def save
		# saves temporary word to localStorage
		local.save!
	
	def add
		word.add!
		local.save!
		imba.commit!
		
	def edit
		word.add!
		local.save!
		imba.commit!
	
	def deleteWord id
		local.deleteWord(id)
		local.save!
		imba.commit!

	def restore
		json.load!
		local.save!
		imba.commit!
	
	def backup
		json.save!
	<self>
		# console.log 'editing', word.editing, 'dictionary', word.dictionary
		<button @click.backup> "j.save"
		<button @click.restore> "j.load"
		<button @click.save> "save"
		<button @click.load> "load"
		<button @click.add> "add"
		
		<[d:vflex]>
			if state.editing isnt undefined
				<word-editor data=state.editing>
			for own id, value of state.dictionary
				<dictionary-item data=value>

tag dictionary-item
	prop data
	def edit
		word.edit data
		local.save!
		imba.commit!
	<self>
		<div> 
			css p:1em
			<%id> data.id
				css c:gray4 fs:.8em
			<%phonetics>
				for phonetic, phonetic_i in data.phonetics
					<[d:vflex]>
						<[d:hfex]>
							for vida in phonetic.vida
								<div> vida
						<[d:hfex]>
							for ipa in phonetic.ipa
								<div> ipa
						<[d:hfex]>
							for arpabet in phonetic.arpabet
								<div> arpabet
			<%definitions> 
				for definition in data.definitions
					<div> definition.use
					<div> definition.source
					for english in definition.english
						<div> english
			<button @click.edit> "edit"
			
tag word-editor
	prop data
	def build
		local.loadEditing!
		imba.commit!
	def cancel
		word.cancel!
		local.save!
		imba.commit!
	def save
		word.save! data
		local.save!
		local.log!
		imba.commit!
	def deleteWord
		word.deleteWord! data.id
		local.save!
		imba.commit!
	<self>
		<div>
			css p:1em
				bd:1px solid gray2
				rd:md
			
			<%id>  
				<span[user-select:none]> "ID: "
				<span> "{data.id}"
			
				css c:gray4 fs:.8em
			
			<%spellings> 
			
				for spelling, spelling_i in data.spellings
			
					<input bind=data.spellings[spelling_i]>
				<button> "+"
			<%phonetics>
				for phonetic, phonetic_i in data.phonetics
					<[d:vflex]>
						<[d:hfex]>
							for vida, vida_i in phonetic.vida
								<input bind=data.phonetics[phonetic_i].vida[vida_i]>
							<button> "+"
						<[d:hfex]>
							for ipa, ipa_i in phonetic.ipa
								<input bind=data.phonetics[phonetic_i].ipa[ipa_i]>
							<button> "+"
						<[d:hfex]>
							for arpabet, arpabet_i in phonetic.arpabet
								<input bind=data.phonetics[phonetic_i].arpabet[arpabet_i]>
							<button> "+"
			<%definitions> 
				css mb:1em
				<h3> "definition"
				for definition, definition_i in data.definitions
					<[d:hflex]>
						<input type="text" bind=data.definitions[definition_i].use>
						<input bind=data.definitions[definition_i].source>
						for english, english_i in definition.english
							<input bind=data.definitions[definition_i].english[english_i]>
						<button> "+"
					<button> "+"
						
			<button @click.deleteWord> "delete"
			<button @click.cancel> "cancel"
			<button @click.save> "save"

imba.mount <dictionary-editor>, document.getElementById('app')
