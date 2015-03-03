# This file should be placed on the directory of ~/blog/config
 
working_directory "/home/deploy/gitlab/recommendone"
pid "/home/deploy/gitlab/recommendone/tmp/pids/unicorn.pid"
stderr_path "/home/deploy/gitlab/recommendone/unicorn/err.log"
stdout_path "/home/deploy/gitlab/recommendone/unicorn/out.log"
 
listen "/tmp/unicorn.sock"
 
worker_processes 2
timeout 30
