#main script file
$ ->
	$relArtistsList = $('#relatedArtistListCont')
	relArtTemplate = Handlebars.compile $('#relArt-template').html()

	$(document).on 'submit', '.artistSearchForm', (e) ->
		$('.artistSearchForm').val('')
		e.preventDefault()
		$.post '/related', $(@).serialize(), (data) ->
			console.log data
			$relArtistsList.html(relArtTemplate({artist : data.artist, relArt : data.relatedArtists}))