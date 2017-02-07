<?php

/**
 * @defgroup plugins_themes_default_tabbed Default theme plugin
 */

/**
 * @file plugins/themes/defaultTabbed/index.php
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup plugins_themes_defaultTabbed
 * @brief Wrapper for default tabbed theme plugin.
 *
 */

require_once('DefaultTabbedChildThemePlugin.inc.php');

return new defaultTabbedChildThemePlugin();

?>
