class DailyJobs::Job
    
    attr_accessor :title, :employer, :location, :description, :url 
    
    @@all = [] # class variable is an empty array 
    
    def initialize #constructor - when ruby creates a new object, it executes this 'constructor' instance method to put default values into instance variables 
        @@all << self #when a class of this instance is initialized, it will be pushed to the @all class variable 
    end

    def self.all #class method - returns an array of all the instances of the Course class
        @@all
    end

    def self.reset_all #class method
        @@all.clear
    end
    
    def self.today #return a bunch of insteads of Job - eg. [job_1, job_2]
        #scrape Seek.com.au and then return jobs based on that data
        self.scrape_jobs 
    
    end 
    
    def self.scrape_jobs #returns an array of job instances 
        doc = Nokogiri::HTML(open("https://www.seek.com.au/full-stack-developer-or-software-engineer-jobs/in-All-Australia"))
        jobs = doc.css("article")
        jobs.collect do |job|
            new_job = self.new
            new_job.title = "Title: #{job.css("h1>a").text.strip}" #string
            new_job.employer = "Employer: #{job.css("a._17sHMz8")[0].text.strip}" 
            new_job.location = job.css("strong._7ZnNccT span._2cFajGc")[0].text.gsub("location:", "Location:").strip
            new_job.url = "https://www.seek.com.au#{job.css("h1>a").attribute("href").value}"
            new_job #returns array of objects, not strings 
        end 
    end 
    
    def self.scrape_all_jobs
        all_jobs = []
        self.reset_all  #clear class variable @@all 
        doc = Nokogiri::HTML(open("https://www.seek.com.au/full-stack-developer-or-software-engineer-jobs/in-All-Australia"))
        jobs = doc.css("article")
        
        page = 1 
        per_page = jobs.count #number of job listings per page
        total_job_listings = doc.css("h1>strong").text.gsub(",","").to_i #total of job listings, and convert string to integer 
        last_page = (total_job_listings.to_f/per_page.to_f).round 
        
        while page <= last_page 
            pagination_url = "https://www.seek.com.au/full-stack-developer-or-software-engineer-jobs/in-All-Australia?page=#{page}"
            pagination_parsed_page = Nokogiri::HTML(open(pagination_url))
            pagination_job_listings = pagination_parsed_page.css("article")
        
            
            pagination_job_listings.collect do |job|
                new_job = self.new
                new_job.title = "Title: #{job.css("h1>a").text.strip}" #string
                new_job.employer = "Employer: #{job.css("a._17sHMz8")[0].text.strip}" 
                new_job.location = job.css("strong._7ZnNccT span._2cFajGc")[0].text.gsub("location:", "Location:").strip
                new_job.url = "https://www.seek.com.au#{job.css("h1>a").attribute("href").value}"
                all_jobs << new_job 
            end 
            page +=1
            print "="
        end 
        all_jobs 
    end 
   # binding.pry    
end 