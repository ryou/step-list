###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

require 'middleman-target'
activate :target

# Methods defined in the helpers block are available in templates
helpers do
  def wp_dir
    if target? :wp
      "<?php echo get_template_directory_uri(); ?>/"
    else
      ''
    end
  end
  def wp_link(href)
    if target? :wp
      "/#{href}"
    else
      "#{href}.html"
    end
  end
  def wp?
    (target? :wp) ? true : false
  end
  def nl2br(str)
    str.gsub(/\r\n|\r|\n/, "<br>")
  end
end

###
# Gem
###
require 'slim'

set :css_dir, 'css'

set :js_dir, 'js'

set :images_dir, 'img'

set :slim, { pretty: true, sort_attrs: false, format: :html5 }

compass_config do |config|
  config.output_style = :expanded
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  # 出力されたcssとsassファイルとの行の対応情報はビルド時に出さないように
  compass_config do |config|
    config.line_comments = false
  end

  # wordpress用build時には、開発環境内のテーマディレクトリへ直接吐き出し＋phpに変換
  if target? :wp
    # wordpressの開発環境に合わせて下記を書き換え
    # theme_dir = '/Users/ryou/vagrants/wp_test/vagrant/sd-milieu.net/test/wp-content/themes/middleman'
    # set :build_dir, theme_dir
    # after_build do
    #   system "rename s/.html/.php/ #{theme_dir}/*"
    # end
  elsif target? :vagrant
    # vagrant上に静的サイトのテスト環境を用意している場合
    # set :build_dir, '/Users/ryou/vagrants/dti_dev/vagrant/sd-milieu.net/test'
  end
end

activate :livereload

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method = :git
  deploy.branch = 'gh-pages'
end
