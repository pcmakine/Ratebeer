class Style < ActiveRecord::Base
  include Calcs
  has_many :beers, dependent: :destroy

  def self.top(n)
    sql = "select avg(r.score) as avg, b.style_id from ratings r join beers b on r.beer_id = b.id group by b.style_id order by avg desc limit #{n}"
    top = ActiveRecord::Base.connection.execute(sql)
    top_styles = {}
    top.each{|b| top_styles[Style.find(b["style_id"])] = b["avg"]}
    top_styles
  end

  def to_s
    name
  end
end
