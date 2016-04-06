"""
Settings for djangocms-blog
"""

# Hide articles in menu
BLOG_MENU_TYPE = None
#  Size of the main image when shown on the post lists
BLOG_IMAGE_THUMBNAIL_SIZE = {
    'size': '500x300',
    'crop': True,
    'upscale': True,
}
#  Size of the main image when shown on the post detail
BLOG_IMAGE_FULL_SIZE = {
    'size': '640x300',
    'crop': True,
    'upscale': True,
}
#  Number of post per page; (default: 10)
BLOG_PAGINATION = 10
#  Default number of post in the Latest post plugin; (default: 5)
BLOG_LATEST_POSTS = 5
#  Default number of words shown for abstract in the post list; (default: 100)
BLOG_POSTS_LIST_TRUNCWORDS_COUNT = 100
#  Generic type for the post object; (default: Article)
BLOG_TYPE = 'Article'
#  Choices of available blog types;
#  (default: to META_OBJECT_TYPES defined in django-meta-mixin settings)
# BLOG_TYPES =
#  Open Graph type for the post object; (default: Article)
# BLOG_FB_TYPE =
#  Choices of available blog types;
#  (default: to META_FB_TYPES defined in django-meta-mixin settings)
# BLOG_FB_TYPES =
#  TODO: Social media ids
#  Facebook Application ID
# BLOG_FB_APPID =
#  Facebook profile ID of the post author
# BLOG_FB_PROFILE_ID =
#  Facebook URL of the blog publisher
# BLOG_FB_PUBLISHER =
#  Facebook profile URL of the post author
# BLOG_FB_AUTHOR_URL =
#  Facebook profile URL of the post author
# BLOG_FB_AUTHOR =
#  Twitter Card type for the post object; (default: Summary)
# BLOG_TWITTER_TYPE =
#  Choices of available blog types for twitter;
#  (default: to META_TWITTER_TYPES defined in django-meta-mixin settings)
# BLOG_TWITTER_TYPES =
#  Twitter account of the site
# BLOG_TWITTER_SITE =
#  Twitter account of the post author
# BLOG_TWITTER_AUTHOR =
#  Google+ Snippet type for the post object; (default: Blog)
# BLOG_GPLUS_TYPE =
#  Choices of available blog types for twitter;
#  (default: to META_GPLUS_TYPES defined in django-meta-mixin settings)
# BLOG_GPLUS_TYPES =
#  Google+ account of the post author
# BLOG_GPLUS_AUTHOR =
#  Whether to enable comments by default on posts;
#  while djangocms_blog does not ship any comment system,
#  this flag can be used to control the chosen comments framework;
#  (default: True)
BLOG_ENABLE_COMMENTS = False
#  Use an abstract field for the post;
#  if False no abstract field is available for every post; (default: True)
BLOG_USE_ABSTRACT = False
#  Post content is managed via placeholder;
#  if False a simple HTMLField is used; (default: True)
# BLOG_USE_PLACEHOLDER =
#  Add support for multisite setup; (default: True)
# BLOG_MULTISITE =
#  Use a default if not specified;
#  if set to True the current user is set as the default author,
#  if set to False no default author is set,
#  if set to a string the user with the provided username is used;
#  (default: True)
# BLOG_AUTHOR_DEFAULT =
#  If posts are marked as published by default; (default: False)
BLOG_DEFAULT_PUBLISHED = True
#  Callable function to change(add or filter) fields to fieldsets for admin
#  post edit form; (default: False).
# BLOG_ADMIN_POST_FIELDSET_FILTER =
#  Choices of permalinks styles;
# BLOG_AVAILABLE_PERMALINK_STYLES =
#  URLConf corresponding to BLOG_AVAILABLE_PERMALINK_STYLES;
# BLOG_PERMALINK_URLS =
#  Default name for Blog item (used in django CMS Wizard);
# BLOG_DEFAULT_OBJECT_NAME =
#  Enable the blog Auto setup feature; (default: True)
# BLOG_AUTO_SETUP =
#  Title of the home page created by Auto setup; (default: Home)
# BLOG_AUTO_HOME_TITLE =
#  Title of the blog page created by Auto setup; (default: Blog)
# BLOG_AUTO_BLOG_TITLE =
#  Title of the BlogConfig instance created by Auto setup; (default: Blog)
# BLOG_AUTO_APP_TITLE =
#  Default priority for sitemap items; (default: 0.5)
# BLOG_SITEMAP_PRIORITY_DEFAULT =
#  List for available changefreqs for sitemap items;
#  (default: always, hourly, daily, weekly, monthly, yearly, never)
# BLOG_SITEMAP_CHANGEFREQ =
#  Default changefreq for sitemap items; (default: monthly)
# BLOG_SITEMAP_CHANGEFREQ_DEFAULT =
#  Current post identifier in request (default djangocms_post_current)
# BLOG_CURRENT_POST_IDENTIFIER =
#  Current post config identifier in request
#  (default: djangocms_post_current_config)
# BLOG_CURRENT_NAMESPACE =
#  Is the toolbar menu throught whole all applications (default: False)
# BLOG_ENABLE_THROUGH_TOOLBAR_MENU =
#  Blog plugin module name (default: Blog)
# BLOG_PLUGIN_MODULE_NAME =
#  Blog latest entries plugin name (default: Latest Blog Articles)
# BLOG_LATEST_ENTRIES_PLUGIN_NAME =
#  Blog author posts plugin name (default: Author Blog Articles)
# BLOG_AUTHOR_POSTS_PLUGIN_NAME =
#  Blog tags plugin name (default: Tags)
# BLOG_TAGS_PLUGIN_NAME =
#  Blog categories plugin name (default: Categories)
# BLOG_CATEGORY_PLUGIN_NAME =
#  Blog archive plugin name (default: Archive)
# BLOG_ARCHIVE_PLUGIN_NAME =
