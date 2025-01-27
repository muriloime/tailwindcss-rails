namespace :tailwindcss do
  desc "Build your Tailwind CSS"
  task :build do |_, args|
    debug = args.extras.include?("debug")
    command = Tailwindcss::Commands.compile_command(debug: debug, postcss: use_postcss?)
    puts command.inspect if args.extras.include?("verbose")
    system(*command, exception: true)
  end

  desc "Watch and build your Tailwind CSS on file changes"
  task :watch do |_, args|
    debug = args.extras.include?("debug")
    poll = args.extras.include?("poll")
    command = Tailwindcss::Commands.watch_command(debug: debug, poll: poll, postcss: use_postcss?)
    puts command.inspect if args.extras.include?("verbose")
    system(*command)
  end

  def use_postcss?
    File.exist?(Rails.root.join("postcss.config.js"))
  end
end

Rake::Task["assets:precompile"].enhance(["tailwindcss:build"])

if Rake::Task.task_defined?("test:prepare")
  Rake::Task["test:prepare"].enhance(["tailwindcss:build"])
elsif Rake::Task.task_defined?("db:test:prepare")
  Rake::Task["db:test:prepare"].enhance(["tailwindcss:build"])
end
