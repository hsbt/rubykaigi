Haml::Template.options.update(
  :format      => :xhtml,
  :escape_html => true
)

Sass::Plugin.options.update(
  :template_location => {
    Rails.root + 'public/stylesheets/sass'      => Rails.root + 'public/stylesheets',
    Rails.root + 'public/2010/stylesheets/sass' => Rails.root + 'public/2010/stylesheets'
  }
)
