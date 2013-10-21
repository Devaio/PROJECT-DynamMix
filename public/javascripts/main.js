//main script file
$(function(){
	$relArtistsList = $('#relatedArtistListCont')
	relArtTemplate = Handlebars.compile($('#relArt-template').html())

	$(document).on('submit', '.artistSearchForm', function(e){
		$('.artistSearchForm').val('')
		e.preventDefault()
		$.post('/related', $(this).serialize(), function(data){
			console.log(data)
			$relArtistsList.html(relArtTemplate({artist : data.artist, relArt : data.relatedArtists}))
		})

	});








});




//handlebars to include data on main page for content feed


//LAST FM API INFO
// API Key: 1805293d5e058d03761b53547ec0ad74
// Secret: is ff65671f88c114e3752236f465566c67
//



//Spotify service URL http://ws.spotify.com/lookup/1/ AND http://ws.spotify.com/search/1/

