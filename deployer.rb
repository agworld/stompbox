require 'git'
require 'open3'
require 'config/config'

class Deployer

  attr_accessor :push

  def initialize(push)
    @push = push
  end

  def self.deploy(push)
    Deployer.new(push).deploy
  end

  # This is the async method
  # Add tcrawley bg stuff here
  def deploy
    begin
      push.deploy
      puts "Cloning #{git_url} to #{repository_name}"
      git = Git.clone(git_url, repository_name, :path=>deployment_path)
      puts "Resetting repo to #{push['after']}"
      git.reset_hard(push['after'])
      puts "Freezing gems"
      freeze_gems
      push.deployed
      puts "Deploy complete"
    rescue Exception => ex
      puts ex
      push.failed
    end
  end

  # Hack to avoid problems with github responses using git gem over https
  def git_url
    push['repository']['url'].sub('https', 'git')
  end

  def deployment_path
    StompBox::Config.get('deployments')
  end

  def repository_name
    "#{push['repository']['name']}-#{commit_hash}"
  end

  def root
    "#{deployment_path}/#{repository_name}"
  end

  def commit_hash
    push['after'][0..6]
  end

  protected

  def path_to(file)
    "#{root}/#{file}"
  end

  def freeze_gems
    if ( File.exist?( path_to('Gemfile') ) )
      jruby = File.join( RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'] )
      exec_cmd( "cd #{root} && #{jruby} -S bundle package" )
      exec_cmd( "cd #{root} && #{jruby} -S bundle install --local --path vendor/bundle" )
    end
  end

  def exec_cmd(cmd)
    Open3.popen3( cmd ) do |stdin, stdout, stderr|
      stdin.close
      stdout_thr = Thread.new(stdout) {|stdout_io|
        stdout_io.each_line do |l|
          STDOUT.puts l
          STDOUT.flush
        end
        stdout_io.close
      }
      stderr_thr = Thread.new(stderr) {|stderr_io|
        stderr_io.each_line do |l|
          STDERR.puts l
          STDERR.flush
        end
      }
      stdout_thr.join
      stderr_thr.join
    end
  end
end




