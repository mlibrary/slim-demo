source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "sinatra"
gem "puma"
gem "faraday"
gem "yabeda-puma-plugin"
gem "yabeda-prometheus"
gem "canister"
gem "rackup"
gem "semantic_logger"
gem "sinatra-contrib"

group :development do
  gem "listen"
  gem "standard"
end
group :development, :test do
  gem "pry"
  gem "pry-byebug"
  gem "rack-test"
  gem "rspec"
  gem "webmock"
  gem "simplecov"
  gem "climate_control"
end
