function supports_input_placeholder() {
	var input = document.createElement('input');
	return 'placeholder' in input;
}

$(function() {
	$('#kcal-limit span a')
		.mouseover(function() {
			$('#change-kcal-label').show();
		})
		.mouseout(function() {
			$('#change-kcal-label').hide();
		});

	$('.meals ul li')
		.mouseover(function() {
			$(this).addClass('hover');
			$(this)
				.children('a.remove')
				.show();
		})
		.mouseout(function() {
			$(this).removeClass('hover');
			$(this)
				.children('a.remove')
				.hide();
		});

	$('#toggle-calendar').click(function() {
		console.log('here');
		if ($('#calendar').css('visibility') == 'hidden') {
			$('#calendar').css('visibility', 'visible');
		} else {
			$('#calendar').css('visibility', 'hidden');
		}
	});

	if (!supports_input_placeholder()) {
		$('[placeholder]')
			.focus(function() {
				var input = $(this);
				if (input.val() == input.attr('placeholder')) {
					input.val('');
					input.removeClass('placeholder');
				}
			})
			.blur(function() {
				var input = $(this);
				if (input.val() == '' || input.val() == input.attr('placeholder')) {
					input.addClass('placeholder');
					input.val(input.attr('placeholder'));
				}
			})
			.blur();

		$('[placeholder]')
			.parents('form')
			.submit(function() {
				$(this)
					.find('[placeholder]')
					.each(function() {
						var input = $(this);
						if (input.val() == input.attr('placeholder')) {
							input.val('');
						}
					});
			});
	}
});

// var debug = new $.debug({
// 	posTo: { x: 'right', y: 'bottom' },
// 	width: '280px',
// 	height: '200px',
// 	itemDivider: '<hr>',
// 	listDOM: ['tagName', 'id', 'innerText', 'href'],
// });
