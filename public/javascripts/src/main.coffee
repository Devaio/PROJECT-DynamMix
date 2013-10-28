$ ->
	$('.signUpSplash').on 'submit', (e) ->
		e.preventDefault()
		console.log $(@).serialize()
		$.post "/signin", $(@).serialize(), (data) ->
			console.log data
			return
		$('#signInModal').modal('toggle')
		return


	$(document).on 'submit', '.artistSearchForm', (e) ->
		e.preventDefault()
		$.post '/related', $(@).serialize(), (data) ->
			console.log data
			$relArtistsList.html(relArtTemplate({artist : data.artist, relArt : data.relatedArtists}))
			return
		$relArtistsList = $('#relatedArtistListCont')
		relArtTemplate = Handlebars.compile $('#relArt-template').html()
		$('.artistSearchForm').val('')
		return
	
	return