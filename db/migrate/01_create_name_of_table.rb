class CreateJobs < ActiveRecord::Migration[4.2]
  def change
    create_table :jobs do |t|
        t.string "title"
        t.string "employer"
        t.string "location"
        t.string "description"
        t.string "job_type"
        t.string "url"
    end
  end
end