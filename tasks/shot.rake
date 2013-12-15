desc "Runs the development server with shotgun."
task :shot, :env do |t,args|
  env = args[:env] || ENV['RAKE_ENV'] || 'development'
  port = args[:port] || ENV['PORT'] || '1234'
  sh "bundle exec shotgun -p #{port} -E #{env} -o 0.0.0.0"
end
