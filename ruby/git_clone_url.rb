git_host = ARGV[0].to_s.gsub(/https\:\/\//i,'')
git_user = ARGV[1].to_s
git_password = ARGV[2].to_s

print "https://#{git_user}:#{git_password}@#{git_host}"