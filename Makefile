install:
	bundle install --path=vendor/bundle
	bundle exec pod check || bundle exec pod install

