$(document).ready(function()
	{
		$('#petition_defendant').blur(function()
			{
				var typed_name = $(':input[name="petition[defendant]"]').val();
				$.getJSON('/petitions/show', {"defendant": typed_name}, function(response)	{
					$('#petition_defendant').val(response["defendant"]);
					$('#petition_defendant_address').val(response["defendant_address"]);
					$('#petition_defendant_dob').val(response["defendant_dob"]);
					$('#petition_school').val(response["school"]);
					$('#petition_parent').val(response["parent"]);
					$('#defendant_unique').text('(We know this Respondent, filling stuff in)');
					$('#defendant_unique').addClass("alert alert-success");
					}
				);
			});
	});