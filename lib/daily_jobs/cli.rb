
# Our CLI Controller - user interactions/buiness logic/dealing with input

#notes 1. scrape description page 2. active record
require 'pry'

class DailyJobs::CLI
    
    def call
        list_jobs
        menu
    end 
    
    def list_jobs # use fake data before start coding for scraping 
        puts ""
        puts "******************************************************************************"
        puts "********** Today's Full Stack Software Developer Jobs in Australia: **********"
        puts "******************************************************************************"
        puts ""
        @jobs = DailyJobs::Job.today #today is a class method of Job which is an object which returns jobs 
        # binding.pry 
        @jobs.each.with_index(1) do |job, i|
            puts "#{i}. #{job.title} - #{job.employer} - #{job.location}"
        end 
        puts ""
        puts "Please wait while the app is scraping data from Seek.com.au..."
        @all_jobs = DailyJobs::Job.scrape_all_jobs

    end 
    
    def menu
        input = nil 
        
        while input != "exit"
            puts ""
            puts "****************************************"
            puts "************* INSTRUCTIONS *************"
            puts "****************************************"
            puts ""
            puts "-> Enter the job number you'd like the url for the first 20 jobs"
            puts "-> Type list to see the first 20 jobs"
            puts "-> Type all to see the total #{DailyJobs::Job.all.count} available today!"
            puts "-> Type clear to clear terminal" 
            puts "-> Type exit to leave the application"
            input = gets.strip.downcase 
            
            if input.to_i > 0
                the_job = @jobs[input.to_i-1]
                puts ""
                puts "#{input.to_i}. #{the_job.title} - #{the_job.employer} - #{the_job.location}"
                puts "URL: #{the_job.url}"
                puts ""
            elsif input == "list"
                list_jobs
            elsif input == "clear"
                system "clear"
            elsif input == "exit"
                goodbye 
            elsif input == "all"
                list_all_jobs
            else 
                puts "Not sure what you want, type list or exit."
            end 
        end 
    end 
    
    def list_all_jobs
        @all_jobs.each.with_index(1) do |job, i|
            puts "#{i}. #{job.title} - #{job.employer} - #{job.location} - #{job.url}"
        end 
    end 
        
    def goodbye
        puts "See you tomorrow for more jobs!!!"
    end 
    
    
end 