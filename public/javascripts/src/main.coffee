$ ->
	$(document).on "submit", ".loginSplash", (e) ->
		e.preventDefault()
		$.post "/signin", $(@).serialize(), (data) ->
			console.log data
			return
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
	
	$(document).on 'click', 'toggleSignUp', (e) ->
		$('#loginSplash').hide()
