/**
 * @file plugins/themes/defaultTabbed/js/tabs.js
 *
 * Copyright (c) 2014-2017 Simon Fraser University
 * Copyright (c) 2000-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Handle JavaScript functionality unique to this theme.
 */
(function($) {

	var $tabs = $('[data-tabs]').find('a'),
		$tabContent = $('[data-tab-content]');

	$tabs.click(function(e) {
		e.stopPropagation();
		e.preventDefault();

		var $tab = $(e.target),
			target =
			$target = $tabContent.filter('[data-tab-content="' + $tab.data('tab') + '"]');

		if (!$target.length) {
			return;
		}

		$tabs.removeClass('current');
		$tab.addClass('current');
		$tabContent.removeClass('is-visible');
		$target.addClass('is-visible');
	});

	// @todo if multiple tabs exist on the same page this will only initialize one
	$tabs.first().click();

})(jQuery);
