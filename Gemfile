source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Postegresql Gem
gem 'pg'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'

# Traducoes
gem 'rails-i18n'

# Validador de cpf/cnpj
gem 'cpf_cnpj'

# Devise Gem para autenticacao
gem 'devise'

# Pundit Autorizacoes/Politica de uso
gem 'pundit'

# Cron process
gem 'rufus-scheduler'

# Images storage
gem "aws-sdk-s3"

# Set timeout to requests
gem 'rack-timeout'

# Jquery gem
gem 'jquery-rails'
gem 'jquery_mask_rails'
gem 'jquery-ui-rails'

# Charts
gem 'chart-js-rails'

# Drag and Drop upload
gem 'dropzonejs-rails'

# Use Puma as the app server
gem 'puma'

# Icones Material Design
gem 'material_icons'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'bootstrap', '~> 5.0.1'

# Paginacao para listagem
gem 'kaminari'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'

  # Para pegar emais em dev
  
  gem 'mailcatcher'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
