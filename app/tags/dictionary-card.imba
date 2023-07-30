
tag dictionary-card
	prop dict_item_data
	
	def edit
		# backup original
		state.editing_original = dict_item_data
		state.editing = dict_item_data
		local.save!
		imba.commit!
		
		
	def changePhoneticSystem string
		user.changePhoneticSystem string
		local.save!
		imba.commit!
	
	<self.dictionary-card>
		css d:vflex
		
		<%spellings>
			css d:hflex
				ff:OpenKhmerSchool
				ja:center
				fs:4xl
				pt:3sp
				pb:1sp
			css .pipe
				c:gray3
			for spelling, spelling_i in dict_item_data.khmer
				<span.spelling> spelling
				<span.pipe> " / " if spelling_i isnt dict_item_data.khmer.length - 1
		
		<%phonetics>
			css ff:'Noto Sans Mono', monospace
				d:vflex ja:center
				w:100%
			<div.phonetics>
				css c:hue4 gap:1sp d:hflex
				switch state.phonetic_system
					when "vida"
						if dict_item_data.vida[0] is ''
							<span[c:hue2]> "["
							<span[c:hue2]> "—"
							<span[c:hue2]> "]"
						else
							<span[c:hue2]> "["
							for vida, vida_i in dict_item_data.vida
								<span> vida || "—"
								if vida_i isnt dict_item_data.vida.length - 1
									<span[c:hue2]> "|"
							<span[c:hue2]> "]"
					when "ipa"
						<span[c:hue2]> "["
						for ipa, ipa_i in dict_item_data.ipa
							<span> ipa || "ipa"
							if ipa_i isnt dict_item_data.ipa.length - 1
								<span[c:hue2]> "|"
						<span[c:hue2]> "]"
					when "romanized"
						<span[c:hue2]> "["
						for romanized, romanized_i in dict_item_data.romanized
							<span> romanized || "romanized"
							if romanized_i isnt dict_item_data.romanized.length - 1
								<span[c:hue2]> "|"
						<span[c:hue2]> "]"
			<div.phonetic-nav>
				css d:hflex gap:1sp
					fs:xs
					c:gray3
					.active
						c:gray6
				<span.active=(state.phonetic_system is "ipa") @click.changePhoneticSystem("ipa")> "ipa"
				<span.active=(state.phonetic_system is "vida") @click.changePhoneticSystem("vida")> "vida"
				<span.active=(state.phonetic_system is "romanized") @click.changePhoneticSystem("romanized")> "romanized"
		<%pos> 
			css flg:1
				my:2sp
			for pos, pos_i of dict_item_data.pos
				<section>
					css ff: 'Noto Sans Mono', monospace
					if pos.name isnt ""
						<h2[fs:1xl]> pos.name
					for source, source_i of pos.sources
						<ol>
							css list-style-type: number
								pl:7sp
								fs:sm
								c:gray5
								li@marker
									c:gray3
							<li> 
								for text, text_i in source.text
									if text_i isnt source.text.length - 1
										<span> "{text}, "
									else
										<span> "{text}."
								<span> " — {source.name}"
									css font-style:italic
										c:gray3
		<section>
			css d:hflex jc:end
			<button.button @click.edit> "edit"
				css w:100px
					bg:gray1 @hover:hue3