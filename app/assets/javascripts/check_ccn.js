$(document).ready(function()
	{
		$('#petition_ccn').blur(function()
			{
				$('#ccn_unique').text("You left the CCN box");
				var unique=true;	
				var typed_ccn = $(':input[name="petition[ccn]"]').val();
				$.getJSON('/petitions/show', {"ccn": typed_ccn}, function(response)	{
					$('#petition_statement_of_pc').val(response["statement_of_pc"]);
					$('#petition_defendant').val(response["defendant"]);
					$('#petition_defendant_address').val(response["defendant_address"]);
					$('#petition_victim').val(response["victim"]);
					$('#petition_victim_address').val(response["victim_address"]);
					$('#petition_charges').val(response["charges"]);
					$('#petition_offense_date').val(response["offense_date"]);
					$('#petition_incident_address').val(response["incident_address"]);
					$('#ccn_unique').text('(note: this CCN has been used, filling stuff in)');
					$('#ccn_unique').addClass("alert alert-success");
					}
				);
			});
	});