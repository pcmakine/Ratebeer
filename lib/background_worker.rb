module BackgroundWorker
  @@current_thread = nil

 def start_worker
   if @@current_thread.nil? or !@@current_thread.alive?
      @@current_thread = Thread.new do
       while true do
         puts "background thread started"
         ratings = Rating.order(created_at: :desc)
         Rails.cache.write("ratings", ratings)
         Rails.cache.write("recent_ratings", ratings.first(5))
         Rails.cache.write("beer top 3", Beer.top(3))
         Rails.cache.write("brewery top 3", Brewery.top(3))
         Rails.cache.write("style top 3", Style.top(3))
         Rails.cache.write("user top 3", User.top(3))
         sleep 5.minutes
       end
     end
   end
 end
end