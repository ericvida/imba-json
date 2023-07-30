tag word-editor
	prop temp_data = {}
	
	def save
		word.save!
		local.save!
		local.log!
		imba.commit!
	
	def deleteWord
		word.deleteWord!
		local.save!
		imba.commit!
	
	def addToArray arr
		arr.push('')
		imba.commit!
	
	def addPos
		state.dictionary[state.editing.id].pos.push {
			pos: ""
			sources: [
				name: ""
				text: [""]
				]
		}
		imba.commit!
		
	def addSource pos_i
		state.dictionary[state.editing.id].pos[pos_i].sources.push {
			name: ""
			text: [""]
		}
		imba.commit!
		
	def delFromArray arr, index
		arr.splice(index,1)
		imba.commit!
	
	css .circle-button-wrapper
		pos:relative
		del-button
			pos:absolute
			r:1sp
			t:-1sp
		add-button
			pos:absolute
			r:1sp
			b:-1sp
	css .editor-input-wrapper
		# bxs:0 0 0 3px hue3 # FIXME: delete
		bg:gray1 # FIXME: delete
		rd:md
	css .editor-input
		pr:3sp
		bgc:gray1
		w:100%
		h:5sp
		rd:md
		pl:1sp
		# pr:3sp
		&@has(+del-button), &@has(+add-button)
			# NOTE: editor-input before delete-button
			# has padding to prevent delete-button from
			# overlapping input text
			pr:1sp
	<self>
		css bxs:0 0 0 3px rose3
		css d:vflex
		<.row>
			<%id>  
			<span[user-select:none]> "ID: "
				<span> "{state.dictionary[state.editing.id].id}"
				css c:gray4 fs:.8em
		<.row>
			<.columns>
				css d:grid grid-template-columns: 1fr 1fr 1fr
					gap:1sp
				<%spellings>
					css d:vflex gap:1sp
					for spelling, spelling_i in state.dictionary[state.editing.id].khmer
						<.editor-input-wrapper.circle-button-wrapper>
							<input.editor-input bind=state.dictionary[state.editing.id].khmer[spelling_i] placeholder="spelling">
							<del-button @dblclick.delFromArray(state.dictionary[state.editing.id].khmer, spelling_i)>
							if spelling_i is state.dictionary[state.editing.id].khmer.length - 1
								<add-button @click.addToArray(state.dictionary[state.editing.id].khmer)>
				<%vida>
					css d:vflex gap:1sp
					for vida, vida_i in state.dictionary[state.editing.id].vida
						<.editor-input-wrapper.circle-button-wrapper>
							<input.editor-input bind=state.dictionary[state.editing.id].vida[vida_i] placeholder="vida">
							<del-button @dblclick.delFromArray(state.dictionary[state.editing.id].vida, vida_i)>
							if vida_i is state.dictionary[state.editing.id].vida.length - 1
								<add-button @click.addToArray(state.dictionary[state.editing.id].vida)>
				<%ipa>
					css d:vflex gap:1sp
					for ipa, ipa_i in state.dictionary[state.editing.id].ipa
						<.editor-input-wrapper.circle-button-wrapper>
							<input.editor-input bind=state.dictionary[state.editing.id].ipa[ipa_i] placeholder="ipa">
							<del-button @dblclick.delFromArray(state.dictionary[state.editing.id].ipa, ipa_i)>
							if ipa_i is state.dictionary[state.editing.id].ipa.length - 1
								<add-button @click.addToArray(state.dictionary[state.editing.id].ipa)>
				# <%romanized>
				# 	for romanized, romanized_i in state.dictionary[state.editing.id].romanized
				# 		<.editor-input-wrapper.circle-button-wrapper>
				# 			<input.editor-input bind=state.dictionary[state.editing.id].romanized[romanized_i] placeholder="romanized">
				# 			<del-button @dblclick.delFromArray(state.dictionary[state.editing.id].romanized, romanized_i)>
				# 			if romanized_i is state.dictionary[state.editing.id].romanized.length - 1
				# 				<add-button @click.addToArray(state.dictionary[state.editing.id].romanized)>
		<%pos>
			css d:vflex py:1sp
			for pos, pos_i in state.dictionary[state.editing.id].pos
				<%pos.circle-button-wrapper>
					css d:vflex 
						gap:0sp
						pr:3sp
						rd:md
						bg:gray1
						bd:2px solid gray2
					<div>
						css py:1.5sp
							pl:1.5sp
							pr:4sp
						<select name="pos_name" #pos_name bind=state.dictionary[state.editing.id].pos[pos_i].name>
							css rd:md
								h:5sp
								bg:white
								w:100%
								c:hue9
								pl:1sp
							for pos_name in state.pos
								<option value=pos_name> pos_name
					<div>
						css pl:1.5sp
							mb:1.5sp
						for source, source_i in pos.sources
							<%source.circle-button-wrapper>
								css d:grid
									rd:md
									pr:4sp
									py:1.5sp
									bdy:2px solid gray2
									grid-template-columns: repeat(4, 1fr)
								<select name="source" #source bind=state.dictionary[state.editing.id].pos[pos_i].sources[source_i].name>
									css bg:white
										bxs: 0 0 0 2px gray15
										rd:md
										px:1sp
										grid-column-start:1
									for item in state.sources
										<option value=item> item
								css d:grid grid-template-columns:auto auto auto
								for text, text_i in source.text
									<.editor-input-wrapper.circle-button-wrapper>
										<input.editor-input @keyup=(console.log 'ed', state.editing, 'orig', state.editing_original) bind=state.dictionary[state.editing.id].pos[pos_i].sources[source_i].text[text_i] placeholder="english">
											css bg:white
												bxs: 0 0 0 2px gray15
										<del-button @dblclick.delFromArray(state.dictionary[state.editing.id].pos[pos_i].sources[source_i].text, text_i)>
										if text_i is source.text.length - 1
											<add-button @click.addToArray(state.dictionary[state.editing.id].pos[pos_i].sources[source_i].text)>
								<hr.circle-button-wrapper>
								# NOTE: buttons for source-group
								# NOTE: delete source group
								<del-button @dblclick.delFromArray(state.dictionary[state.editing.id].pos[pos_i].sources, source_i)>
								if source_i is state.dictionary[state.editing.id].pos[pos_i].sources.length - 1
									# NOTE: add source-group
									<add-button @click.addSource(pos_i)>
								
						<del-button @dblclick.delFromArray(state.dictionary[state.editing.id].pos, pos_i)>
						if pos_i is state.dictionary[state.editing.id].pos.length - 1
							# NOTE: add source-group
							<add-button @click.addPos>
		
		<%word-editor-action-buttons>
			css d:flex
				jc:end		
			<button.button.delete @dblclick.deleteWord> "delete"
			<button.button @click.save> "save"
tag del-button
	css rd:full
		size:2sp
		d:box
		bg:gray3 @hover: rose3
		cursor:pointer
	css svg
		size:70%
		stroke:gray9 ^@hover: rose9
		stroke-width:14%
	<self>
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />

tag add-button
	css rd:full
		size:2sp
		d:box
		bg:gray3 @hover: green3
		cursor:pointer
	css svg
		size:70%
		stroke:gray9 ^@hover: green9
		stroke-width:14%
	<self>
		<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
			<path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />