$(document).ready(function()
	{
		$('#petition_ccn').blur(function()
			{
				$('#ccn_unique').text("You left the CCN box");
				var unique=true;	
				var typed_ccn = $(':input[name="petition[ccn]"]').val();
				$.getJSON('/petitions/show', {"ccn": typed_ccn}, function(response)	{
					$('#petition_statement_of_pc').text(response["statement_of_pc"]);
					$('#petition_defendant').text(response["defendant"]);
					$('#petition_defendant_address').text(response["defendant_address"]);
					$('#petition_victim').text(response["victim"]);
					$('#petition_victim_address').text(response["victim_address"]);
					$('#petition_charges').text(response["charges"]);
					$('#petition_offense_date').text(response["offense_date"]);
					$('#petition_incident_address').text(response["incident_address"]);
					$('#ccn_unique').text('(note: this CCN has been used, filling stuff in)');
					$('#ccn_unique').addClass("alert alert-success");
					}
				);
			});
	});