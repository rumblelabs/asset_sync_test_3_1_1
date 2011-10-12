With **Rails 3.1.1** changes to the *asset pipeline* we needed to change how to configure asset_sync.

* Rails will not load config/initializers/asset_sync.rb
* So we added an initializer to the asset_sync gem itself and tried to force the load of an initializer in `Rails.root/config/initializers/asset_sync.rb` (this feels wrong and also didn't work)
* Even with *:group => :assets* on the initializer in asset_sync/engine, it doesn't seem to be run

## Alternatives.

Tried the following and they all work, locally and when pushed to heroku (and `heroku run rake assets:precomile` is ran).

There is still a nasty error now on push to heroku because the precompile task doesn't work. Haven't checked but I'm guessing ENV variables still aren't there on push.

      -----> Preparing app for Rails asset pipeline
             Running: rake assets:precompile
             /usr/local/bin/ruby /tmp/build_1ajde6o93skek/vendor/bundle/ruby/1.9.1/bin/rake assets:precompile:nondigest RAILS_ENV=production RAILS_GROUPS=assets
             rake aborted!
             Aws access key can't be blank, Aws access secret can't be blank, Aws bucket can't be blank
       
             Tasks: TOP => assets:precompile
             (See full trace by running task with --trace)

Also heroku doesn't seem to run the same tasks as when run from `heroku run` or maybe it eschews the output of the first task.

    ~ $ bundle exec rake assets:precompile
    /usr/local/bin/ruby /app/vendor/bundle/ruby/1.9.1/bin/rake assets:precompile:all RAILS_ENV=staging RAILS_GROUPS=assets
    /usr/local/bin/ruby /app/vendor/bundle/ruby/1.9.1/bin/rake assets:precompile:nondigest RAILS_ENV=staging RAILS_GROUPS=assets

Not sure but this could be related.

### YAML

* Purely relying on *config/asset_sync.yml* works fine (with hardcoded or ENV variables... as the yml file can have erb in it).

### put contents of an initializer in config/application.rb

* Putting what should be generated into config/initializers directly into application.rb is actually now loaded during the `assets:precompile` task.

### Use config.asset_sync

Playing around with this, we added a railtie to add a method to the Rails App config. 

This now works also.
Should be able to put this in the different config/environments/* files and override from there.


    config.asset_sync.aws_access_key = ENV['AWS_ACCESS_KEY']
    config.asset_sync.aws_access_secret = ENV['AWS_ACCESS_SECRET']
    config.asset_sync.aws_bucket = ENV['AWS_BUCKET']
    config.asset_sync.aws_region = "eu-west-1"
