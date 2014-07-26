# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'my_app_name'
set :repo_url, 'https://github.com/sjkyspa/ordering.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/vagrant'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/unicorn.rb}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :user, "vagrant"

set :rbenv_path, "/home/#{fetch(:deploy_user)}/.rbenv"
set :rbenv_type, :system
set :rbenv_ruby, '2.1.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :local_config_path, Dir.pwd

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute :ls, '-l'
        as "#{fetch(:user)}" do
          with rails_env: :production do
            execute :unicorn_rails, "-c #{current_path.join('config') + 'unicorn.rb'} -D"
          end
        end
      end
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end


  task :uploadconfig do
    on roles(:app) do
      config_path = File.join shared_path, 'config'
      Dir.chdir(fetch(:local_config_path)) do
        puts fetch(:local_config_path)
        Dir.glob("*") do |filename|
          local_file_path = File.join(Dir.pwd, filename)
          remote_file_path = "#{config_path}/#{filename}"

          upload! local_file_path, remote_file_path
          info "upload #{filename} to remote"
        end
      end
    end
  end

  task :prepare_env do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        as "#{fetch(:user)}" do


          with rails_env: :production do
            execute :bundle, 'install'
          end
        end
      end
    end
  end

  before :prepare_env, :uploadconfig
  after :check, :prepare_env

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
