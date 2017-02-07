{**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article which displays all details about the article.
 *  Expected to be primary object on the page.
 *
 * Core components are produced manually below, but can also be added via
 * plugins using the hooks provided:
 *
 * Templates::Article::Main
 * Templates::Article::Details
 *
 * @uses $article Article This article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $keywords array List of keywords assigned to this article
 * @uses $pubIdPlugins Array of pubId plugins which this article may be assigned
 * @uses $citationPlugins Array of citation format plugins
 * @uses $copyright string Copyright notice. Only assigned if statement should
 *   be included with published articles.
 * @uses $copyrightHolder string Name of copyright holder
 * @uses $copyrightYear string Year of copyright
 * @uses $licenseUrl string URL to license. Only assigned if license should be
 *   included with published articles.
 * @uses $ccLicenseBadge string An image and text with details about the license
 *}
<article class="obj_article_details">
	<h1 class="page_title">
		{$article->getLocalizedTitle()|escape}
	</h1>

	{if $article->getLocalizedSubtitle()}
		<h2 class="subtitle">
			{$article->getLocalizedSubtitle()|escape}
		</h2>
	{/if}

	<div class="row">

		{if $article->getAuthors()}
			<ul class="item authors">
				{foreach from=$article->getAuthors() item=author}
					<li>
						<span class="name">
							{$author->getFullName()|escape}
						</span>
						{if $author->getLocalizedAffiliation()}
							<span class="affiliation">
								{$author->getLocalizedAffiliation()|escape}
							</span>
						{/if}
						{if $author->getOrcid()}
							<span class="orcid">
								<a href="{$author->getOrcid()|escape}" target="_blank">
									{$author->getOrcid()|escape}
								</a>
							</span>
						{/if}
					</li>
				{/foreach}
			</ul>
		{/if}

		{* DOI (requires plugin) *}
		{foreach from=$pubIdPlugins item=pubIdPlugin}
			{if $pubIdPlugin->getPubIdType() != 'doi'}
				{php}continue;{/php}
			{/if}
			{if $issue->getPublished()}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
			{else}
				{assign var=pubId value=$pubIdPlugin->getPubId($article)}{* Preview pubId *}
			{/if}
			{if $pubId}
				{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
				<div class="item doi">
					<span class="label">
						{translate key="plugins.pubIds.doi.readerDisplayName"}
					</span>
					<span class="value">
						<a href="{$doiUrl}">
							{$doiUrl}
						</a>
					</span>
				</div>
			{/if}
		{/foreach}

		<ul class="item article_details_tabs" data-tabs="article-details">
			<li>
				<a href="#" data-tab="article">
					Article
				</a>
			</li>
			<li>
				<a href="#" data-tab="info">
					Information
				</a>
			</li>
			<li>
				<a href="#" data-tab="supplementary">
					Supplementary
				</a>
			</li>
			<li>
				<a href="#" data-tab="metrics">
					Metrics
				</a>
			</li>
			<li>
				<a href="#" data-tab="related-articles">
					Related Articles
				</a>
			</li>
			<li>
				<a href="#" data-tab="comments">
					Comments/Refbacks
				</a>
			</li>
		</ul>

		<div class="article_details_tab_content is-visible" data-tab-content="article">
			<h2 class="pkp_screen_reader">Article</h2>

			{* Abstract *}
			{if $article->getLocalizedAbstract()}
				<div class="item abstract">
					<h3 class="label">
						{translate key="article.abstract"}
					</h3>
					<div class="value">
						{$article->getLocalizedAbstract()|strip_unsafe_html|nl2br}
					</div>
				</div>
			{/if}

			{* Keywords *}
			<div class="item keywords">
				<h3 class="label">
					Keywords
				</h3>
				<div class="value">
					Pretend, These, Are Keywords, For This Article
				</div>
			</div>

			{* Article Galleys *}
			{assign var=galleys value=$article->getGalleys()}
			{if $galleys}
				<div class="item galleys">
					<ul class="value galleys_links">
						{foreach from=$galleys item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}

			<div class="item social">
				<h3 class="label">
					Share this article
				</h3>
				<div class="value">
					Pretend there are some social share links here.
				</div>
			</div>

			{* References *}
			{if $article->getCitations()}
				<div class="item references">
					<h3 class="label">
						{translate key="submission.citations"}
					</h3>
					<div class="value">
						{$article->getCitations()|nl2br}
					</div>
				</div>
			{/if}

		</div><!-- .article_details_tab_content is-visible -->

		<div class="article_details_tab_content is-visible" data-tab-content="info">
			<h2 class="pkp_screen_reader">Information</h2>

			{* Licensing info *}
			{if $copyright || $licenseUrl}
				<div class="item copyright">
					{if $licenseUrl}
						{if $ccLicenseBadge}
							{$ccLicenseBadge}
						{else}
							<a href="{$licenseUrl|escape}" class="copyright">
								{if $copyrightHolder}
									{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder copyrightYear=$copyrightYear}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{/if}
					{$copyright}
				</div>
			{/if}

			{* Citation formats *}
			{if $citationPlugins|@count}
				<div class="item citation_formats">
					{* Output the first citation format *}
					{foreach from=$citationPlugins name="citationPlugins" item="citationPlugin"}
						<div class="sub_item citation_display">
							<h3 class="label">
								{translate key="submission.howToCite"}
							</h3>
							<div id="citationOutput" class="value">
								{$citationPlugin->fetchCitation($article, $issue, $currentContext)}
							</div>
						</div>
						{php}break;{/php}
					{/foreach}

					{* Output list of all citation formats *}
					<div class="sub_item citation_format_options">
						<h3 class="label">
							{translate key="submission.howToCite.citationFormats"}
						</h3>
						<div class="value">
							<ul>
								{foreach from=$citationPlugins name="citationPlugins" item="citationPlugin"}
									<li class="{$citationPlugin->getName()|escape}{if $smarty.foreach.citationPlugins.iteration == 1} current{/if}">
										{capture assign="citationUrl"}{url page="article" op="cite" path=$article->getBestArticleId()}/{$citationPlugin->getName()|escape}{/capture}
										<a href="{$citationUrl}"{if !$citationPlugin->isDownloadable()} data-load-citation="true"{/if} target="_blank">{$citationPlugin->getCitationFormatName()|escape}</a>
									</li>
								{/foreach}
							</ul>
						</div>
					</div>
				</div>
			{/if}

			{if $article->getDatePublished()}
				<div class="item published">
					<h3 class="label">
						{translate key="submissions.published"}
					</h3>
					<div class="value">
						{$article->getDatePublished()|date_format:$dateFormatShort}
					</div>
				</div>
			{/if}

			{if $section}
				<div class="item issue">
					<h3 class="label">
						{translate key="section.section"}
					</h3>
					<div class="value">
						{$section->getLocalizedTitle()|escape}
					</div>
				</div>
			{/if}

		</div><!-- .article_details_tab_content is-visible -->

		<div class="article_details_tab_content is-visible" data-tab-content="supplementary">
			<h2 class="pkp_screen_reader">Supplementary</h2>

			<div class="item figures">
				<h3 class="label">
					Figures
				</h3>
				<div class="value">
					Imagine some figures here.
				</div>
			</div>

			<div class="item images">
				<h3 class="label">
					Images
				</h3>
				<div class="value">
					Imagine some images here.
				</div>
			</div>
		</div><!-- .article_details_tab_content is-visible -->

		<div class="article_details_tab_content is-visible" data-tab-content="metrics">
			<h2 class="pkp_screen_reader">Metrics</h2>

			{call_hook name="Templates::Article::Main"}

			<div class="item images">
				<h3 class="label">
					Article-level Metrics
				</h3>
				<div class="value">
					Imagine some ALM stuff here.
				</div>
			</div>
		</div><!-- .article_details_tab_content is-visible -->

		<div class="article_details_tab_content is-visible" data-tab-content="related-articles">
			<h2 class="pkp_screen_reader">Related Articles</h2>

			<div class="item related-articles">
				<div class="value">
					{include file="frontend/objects/article_summary.tpl" section="false"}
					{include file="frontend/objects/article_summary.tpl" section="false"}
					{include file="frontend/objects/article_summary.tpl" section="false"}
				</div>
			</div>
		</div><!-- .article_details_tab_content is-visible -->

		<div class="article_details_tab_content is-visible" data-tab-content="comments">
			<h2 class="pkp_screen_reader">Comments</h2>

			<div class="item comments">
				<div class="value">
					Imagine some comments here.
				</div>
			</div>
		</div><!-- .article_details_tab_content is-visible -->

	</div><!-- .row -->

</article>
