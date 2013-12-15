desc "Runs an interactive ruby shell"
task :console do
  sh 'bundle exec pry -I . -r console_init'
  conn = Mongoid.default_session.connection
  args = []
  args << "--username=#{conn.username}" if conn.username rescue nil
  args << "--password=#{conn.password}" if conn.password rescue nil
  args << "--host=#{conn.host}"
  args << "--port=#{conn.port.to_s}"
  args << Mongoid.default_session.name
  exec 'mongo', *args
end
