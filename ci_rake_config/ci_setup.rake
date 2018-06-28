

# define instance variables
@file_name = 'ci.rake'
@user_response = ''

namespace :ci_setup do
  desc 'This task checks if any ci task has been created in your rails app'
  task :check_or_create_lib do
    if File.directory?('lib')
      puts %q('lib' directory already exists!)
    else
      puts %q(creating 'lib' directory...)
      mkdir 'lib', verbose: false
    end
  end

  desc 'check if tasks directory exist inside lib'
  task :check_or_create_tasks => [:check_or_create_lib] do
    if File.directory?('lib/tasks')
      puts %q('tasks' directory already exists!)
    else
      puts %q(creating 'tasks' directory inside 'lib'...)
      mkdir 'lib/tasks', verbose: false
    end
    Rake::Task['ci_setup:create_ci_task'].invoke
  end

  desc 'create task to handle continuous integration'
  task :create_ci_task do
    puts 'Creating ci rake task...'
    touch %W(lib/tasks/#{ci_file})
    puts '🙂'
  end
end

# Creates user specified rake file
def ci_file
  new_file_name unless handle_user_input.nil? and @user_response == 'y'
  @file_name
end

# Handle user input and fallback to default value
# after 3 attempts, if input is invalid
def handle_user_input
  max_attempts = 3
  print 'Use default file name (y/n)?:'
  @user_response = STDIN.gets.strip.downcase
  raise ArgumentError, 'Your response must be either y or n (case insensitive)' unless ['y','n'].include?(@user_response)
rescue ArgumentError
  attempts ||= 0
  attempts += 1
  @user_response = 'y'

  if attempts < max_attempts
    puts "You have #{max_attempts - attempts} more attempt, before default name is assigned"
    retry
  else
    puts 'assigning default file name...'
  end

end

# Handle assigning a new file name to @file_name instance variable
def new_file_name
  print 'Enter your ci task file name: '
  @file_name = STDIN.gets.strip.downcase + '.rake'
end