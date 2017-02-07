<?php

/**
 * @file plugins/themes/default/defaultTabbedChildThemePlugin.inc.php
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class defaultTabbedChildThemePlugin
 * @ingroup plugins_themes_default_tabbed
 *
 * @brief Default theme
 */
import('lib.pkp.classes.plugins.ThemePlugin');

class defaultTabbedChildThemePlugin extends ThemePlugin {
	/**
	 * Initialize the theme's styles, scripts and hooks. This is only run for
	 * the currently active theme.
	 *
	 * @return null
	 */
	public function init() {

		// Initialize the parent theme
		$this->setParent('defaultthemeplugin');

		// Add custom styles
		$this->modifyStyle('stylesheet', array('addLess' => array('styles/index.less')));

		// Add JavaSCript
		$this->addScript('default', 'js/tabs.js');
	}

	/**
	 * Get the display name of this plugin
	 * @return string
	 */
	function getDisplayName() {
		return __('plugins.themes.defaultTabbed.name');
	}

	/**
	 * Get the description of this plugin
	 * @return string
	 */
	function getDescription() {
		return __('plugins.themes.defaultTabbed.description');
	}
}

?>
