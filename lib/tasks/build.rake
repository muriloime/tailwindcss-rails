namespace :tailwindcss do
  desc "Build your Tailwind CSS"
  task :build do |_, args|
    debug = args.extras.include?("debug")
    postcss = args.extras.include?("postcss")
    command = Tailwindcss::Commands.compile_command(debug: debug, postcss: postcss)
    puts command.inspect
    system(*command, exception: true)
  end

  desc "Watch and build your Tailwind CSS on file changes"
  task :watch do |_, args|
    debug = args.extras.include?("debug")
    poll = args.extras.include?("poll")
    postcss = args.extras.include?("postcss")
    command = Tailwindcss::Commands.watch_command(debug: debug, poll: poll, postcss: postcss)
    puts command.inspect
    system(*command)
  end
end

Rake::Task["assets:precompile"].enhance(["tailwindcss:build"])

if Rake::Task.task_defined?("test:prepare")
  Rake::Task["test:prepare"].enhance(["tailwindcss:build"])
elsif Rake::Task.task_defined?("db:test:prepare")
  Rake::Task["db:test:prepare"].enhance(["tailwindcss:build"])
end
