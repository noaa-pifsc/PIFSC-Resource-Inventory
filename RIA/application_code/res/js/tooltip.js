//function to handle positioning for the tooltips when they are created (referenced in the using: clause of the tooltip constructor) - this was pulled directly from the jQuery UI working example (https://jqueryui.com/tooltip/#custom-style)
function tooltip_arrows ( position, feedback )
{
	$( this ).css( position );
	$( "<div>" )
	.addClass( "arrow" )
	.addClass( feedback.vertical )
	.addClass( feedback.horizontal )
	.appendTo( this );
}
