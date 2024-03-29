<?php
# Protect against web entry
if ( !defined( 'MEDIAWIKI' ) ) { exit; }

$wgSitename = $_ENV["SITE_NAME"];

$wgMetaNamespace = "Project";
# Configured web paths & short URLs
# This allows use of the /wiki/* path
## https://www.mediawiki.org/wiki/Manual:Short_URL
$wgScriptPath = "/w";        // this should already have been configured this way
$wgArticlePath = "/wiki/$1";

## The protocol and server name to use in fully-qualified URLs
$wgServer = $_ENV["WG_SERVER"];

## The URL path to static resources (images, scripts, etc.)
$wgResourceBasePath = $wgScriptPath;

## The URL paths to the logo
$wgLogos = [ '1x' => "$wgResourceBasePath/resources/assets/logo.jpg" ];

$wgFavicon = "$wgResourceBasePath/resources/assets/favicon.ico";

## UPO means: this is also a user preference option

$wgEnableEmail = true;
$wgEnableUserEmail = true; # UPO

$wgEmergencyContact = "hello@inventaire.io";

$wgEnotifUserTalk = false; # UPO
$wgEnotifWatchlist = false; # UPO
$wgEmailAuthentication = true;

## Database settings
$wgDBtype = "mysql";
$wgDBserver = $_ENV["MYSQL_SERVER"];
$wgDBname = $_ENV["MYSQL_DATABASE"];
$wgDBuser = $_ENV["MYSQL_USER"];
$wgDBpassword = $_ENV["MYSQL_PASSWORD"];

# MySQL specific settings
$wgDBprefix = "";

# MySQL table options to use during installation or update
$wgDBTableOptions = "ENGINE=InnoDB, DEFAULT CHARSET=binary";

## Shared memory settings
$wgMainCacheType = CACHE_ACCEL;
$wgMemCachedServers = [];

## To enable image uploads, make sure the 'images' directory
## is writable, then set this to true:
$wgEnableUploads = true;
$wgUseImageMagick = true;
$wgImageMagickConvertCommand = "/usr/bin/convert";
// Tmp directory should be owned by www-data user
$wgTmpDirectory = '/tmp/mediawiki';

# InstantCommons allows wiki to use images from https://commons.wikimedia.org
# See https://www.mediawiki.org/wiki/Special:MyLanguage/Manual:$wgUseInstantCommons
$wgUseInstantCommons = true;

# Periodically send a pingback to https://www.mediawiki.org/ with basic data
# about this MediaWiki instance. The Wikimedia Foundation shares this data
# with MediaWiki developers to help guide future development efforts.
$wgPingback = true;

## If you use ImageMagick (or any other shell command) on a
## Linux server, this will need to be set to the name of an
## available UTF-8 locale
$wgShellLocale = "C.UTF-8";

## Set $wgCacheDirectory to a writable directory on the web server
## to make your wiki go slightly faster. The directory should not
## be publicly accessible from the web.
#$wgCacheDirectory = "$IP/cache";

# Site language code, should be one of the list in ./languages/data/Names.php
$wgLanguageCode = $_ENV["SITE_LANG"];

$wgSecretKey = $_ENV["SECRET_KEY"];

# Changing this will log out all existing sessions.
$wgAuthenticationTokenVersion = "1";

# Site upgrade key. Must be set to a string (default provided) to turn on the
# web installer while LocalSettings.php is in place
$wgUpgradeKey = "e5b45eb671248d69";

## For attaching licensing metadata to pages, and displaying an
## appropriate copyright notice / icon. GNU Free Documentation
## License and Creative Commons licenses are supported so far.
$wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
$wgRightsUrl = "https://creativecommons.org/publicdomain/zero/1.0/";
$wgRightsText = "Creative Commons Zero (Public Domain)";
$wgRightsIcon = "$wgResourceBasePath/resources/assets/licenses/cc-0.png";

# Path to the GNU diff3 utility. Used for conflict resolution.
$wgDiff3 = "/usr/bin/diff3";

## Default skin: you can change the default skin. Use the internal symbolic
## names, ie 'vector', 'monobook':
$wgDefaultSkin = "vector";

# Enabled skins.
# The following skins were automatically enabled:
wfLoadSkin( 'Vector' );

# End of automatically generated settings.
# Add more configuration options below.

$wgAllowExternalImages = true;

$wgGroupPermissions['*']['edit'] = false;
$wgGroupPermissions['*']['createaccount'] = false;
$wgDebugLogFile = "/var/log/mediawiki.log";

// See: https://www.mediawiki.org/wiki/Extension:SendGrid
$wgSendGridAPIKey = $_ENV["WG_SENDGRD_API_KEY"];

// git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/UniversalLanguageSelector.git
// See: https://www.mediawiki.org/wiki/Extension:UniversalLanguageSelector

# Translation extensions
$wgCCTrailerFilter = true;
$wgCCUserFilter = false;
$wgDefaultUserOptions['usenewrc'] = 1;

$wgLocalisationUpdateDirectory = "$IP/cache";

$wgGroupPermissions['user']['translate'] = true;
$wgGroupPermissions['user']['translate-messagereview'] = true;
$wgGroupPermissions['user']['translate-groupreview'] = true;
$wgGroupPermissions['user']['translate-import'] = true;
$wgGroupPermissions['user']['skipcaptcha'] = true;
$wgGroupPermissions['user']['pagelang'] = true;
$wgGroupPermissions['sysop']['pagetranslation'] = true;
$wgGroupPermissions['sysop']['translate-manage'] = true;
$wgGroupPermissions['bureaucrat']['deletebatch'] = false;
$wgGroupPermissions['sysop']['deletebatch'] = true;

// How to translate step by step guide: https://www.mediawiki.org/wiki/Help:Extension:Translate/Page_translation_example
$wgEnablePageTranslation = true;
$wgTranslatePageTranslationULS = false;
$wgPageLanguageUseDB = true; // manually changing page language

$wgScribuntoDefaultEngine = 'luastandalone';

$invHost = $_ENV['INV_HOST'];

// Remove login links from all pages
// https://www.mediawiki.org/wiki/Manual:Preventing_access#Removing_the_Login_link_from_all_pages
function NoLoginLinkOnMainPage( &$personal_urls ){
    unset( $personal_urls['login'] );
    unset( $personal_urls['anonlogin'] );
    return true;
}
$wgHooks['PersonalUrls'][]='NoLoginLinkOnMainPage';

$wgOAuth2Client['client']['id']     = $_ENV['OAUTH_CLIENT_ID']; // The client ID assigned to you by the provider
$wgOAuth2Client['client']['secret'] = $_ENV['OAUTH_CLIENT_SECRET']; // The client secret assigned to you by the provider

$wgOAuth2Client['configuration']['authorize_endpoint']     = "$invHost/authorize";
$wgOAuth2Client['configuration']['access_token_endpoint']  = "$invHost/api/oauth/token";
$wgOAuth2Client['configuration']['api_endpoint']           = "$invHost/api/user";
$wgOAuth2Client['configuration']['redirect_uri']           = "$wgServer/wiki/Special:OAuth2Client/callback";

// Using the stableUsername as it will then be used as the user identifier by mediawiki
// To change a user username, you would thus need to simultaneously rename the mediawiki user
// (using the not yet installed https://www.mediawiki.org/wiki/Extension:Renameuser)
// and update their 'stableUsername' in the Inventaire user database
$wgOAuth2Client['configuration']['username'] = 'stableUsername'; // JSON path to stableUsername in the api_endpoint response
$wgOAuth2Client['configuration']['email'] = 'email'; // JSON path to email in the api_endpoint response

$wgOAuth2Client['configuration']['scopes'] = 'stable-username email';

$wgOAuth2Client['configuration']['service_name'] = $wgSitename;
$wgOAuth2Client['configuration']['service_login_link_text'] = "Login with Inventaire";

$wgCookieSecure = true;
$wgCookieSameSite = 'Lax';

wfLoadExtension( 'Babel' );
wfLoadExtension( 'Cite' );
wfLoadExtension( 'cldr' );
wfLoadExtension( 'CleanChanges' );
wfLoadExtension( 'CodeEditor' );
wfLoadExtension( 'DeleteBatch' );
wfLoadExtension( 'ExternalData' );
wfLoadExtension( 'LocalisationUpdate' );
wfLoadExtension( 'MobileFrontend' );
wfLoadExtension( 'MW-OAuth2Client' );
wfLoadExtension( 'ParserFunctions' );
wfLoadExtension( 'Scribunto' );
wfLoadExtension( 'SendGrid' );
wfLoadExtension( 'SyntaxHighlight_GeSHi' );
wfLoadExtension( 'TemplateStyles' );
wfLoadExtension( 'Translate' );
wfLoadExtension( 'UniversalLanguageSelector' );
wfLoadExtension( 'WikiEditor' );
