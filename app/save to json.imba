def loadFromJSON
	try
		const res = await window.fetch('/load')
		data = await res.json()
		console.log 'loaded', data
		state.dictionary = data
	catch e
		console.error("Couldn't fetch count", e)
	imba.commit()
# make function to delete word from dictionary
def deleteWord word
	let temp = local[word]
	delete local[word]
	state.save
	# console.log 'deleting', state.dictionary
	try
		const res = window.fetch('/delete', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(state.dictionary)
		})
		console.log 'sent to delete', state.dictionary
	catch e
		console.error("Couldn't fetch count", e)
def saveToJSON
	console.log 'saving to json', state.dictionary
	try
		const res = window.fetch('/save', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(state.dictionary)
		})
		console.log 'sent to save', state.dictionary
	catch e
		console.error("Couldn't fetch count", e)