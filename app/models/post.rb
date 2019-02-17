class Post < ApplicationRecord
	# has_many :thumbs
	#定义一个实例方法获取账户名称，可以直接通过实例调用，比如:Post.first.get_account_name 
    def get_account_name
      #self代表实例本身，即Post.first这个实例
      account_id = self.account_id
      account = Account.find_by(id:account_id)
      name = "此用户未命名"
      if account
        name = account.name
      end
    end

    # 获取帖子最后修改时间
    # 当小于60秒的时候返回时间为xx秒前； 
		# 当小于60分钟大于等于60秒时返回xx分钟前； 
		# 当小于24小时大于等于60分钟时返回xx小时前；
		# 当小于2天大于等于24小时时显示一天前； 
		# 当大于等于2天的时候，显示xx-xx-xx日期；
    def get_updated_at
    	updated_at = self.updated_at
    	now = Time.now
    	#时间间隔秒数
    	time_distance = (now - updated_at).to_i
    	#判断时间间隔是否小于60秒，是的话，运行if语句下面的代码，不是的话，继续判断elsif对应的条件
    	if time_distance < 60
    		date = "#{time_distance}秒前"
    	#判断时间间隔是否小于60分钟
    	elsif time_distance/60 < 60
    		date = "#{time_distance/60}分钟前"
    	#判断时间间隔是否小于24小时
    	elsif time_distance/(60*60) < 24
    		date = "#{time_distance/(60*60)}小时前"
    	#判断时间间隔是否小于2天
    	elsif time_distance/(60*60*24) < 2
    		date = "1天前"
    	#时间间隔大于2天，会进入else语句下面的代码
    	else
    		#strftime用于对时间的格式化，"%Y-%m-%d"的日期举例2018-10-11
    		date = updated_at.strftime("%Y-%m-%d")
    	end
    	#最后返回date变量，在get_updated_at方法的时候会返回date变量，注意不能在最后一行写注释，因为ruby默认最后一行
    	date
    end
    
    
    #获取评论数
    def get_post_items
    	num = Comment.where(post_id:self.id).count
    end
    
		#获取点赞数，目前还未建立点赞表，默认点赞数为1
		def get_thumbs
		  num = Thumb.where(post_id:self.id,is_thumb:true).count
		end

		#获取此用户是否给该帖子点过赞，默认为未点过
		def get_thumb_info(account_id)
		  thumb = Thumb.find_by(post_id:self.id,account_id:account_id)
		  boolean = false
		  if thumb && thumb.is_thumb
		  	boolean = true
		  end
		end

	# 战队能量0—200在娱乐场          入场费0能量，最少赢288能量
	# 战队能量200—600在中级场        入场费100能量，最少赢688能量
	# 战队能量600—1000在高级场       入场费200能量，最少赢988能量
	# 战队能量1000—2000在金冠场      入场费300能量，最少赢1288能量
	# 战队能量2000—3500在大师场      入场费600能量，最少赢1988能量
	# 战队能量3500—5000在荣耀场      入场费1000能量，最少赢2888能量
	# 战队能量5000—10000在传奇场     入场费2000能量，最少赢4988能量
	# 战队能量10000—20000在巅峰场    入场费4000能量，最少赢9688能量
	# 战队能量20000—50000在梦想场    入场费8000能量，最少赢18188能量
	def zhong
		hash = Post.first.taobao11_team_score(1)
		hashsss = []
		hash.sort {|a,b| b[1]<=>a[1]}.map{|z,y| hashsss << z}
		
		hash_1 = Post.first.taobao11_team_score(2)
		hashssss = {}
		hashsss[0..20].each do |index|
			hashssss[index] = hash_1[index]
		end
		hashssss
	end
	

	def taobao11_team_score(as_type)
		#初始值
		hash = {}
		#输赢情况 1赢  0输
		conditions = Post.get_conditions(8)
		indexs = []
		conditions.each_with_index do |cos,index|
			score = 494
			condition = [1,1,1,1] + eval(cos)
			puts "#{condition}"
			datas = []
			condition.each_with_index do |co,ind|
				if co == 1 && score >=20000
					indexs << index
				end
				score,datas = Post.taobao11_team_rule(score,co,ind,datas)
				puts "=index:#{index}===score========#{score}===="
			end
			# puts "=index:#{index}===score========#{score}===="
			if as_type == 1
			  hash[index] = score
		    elsif as_type == 2
			  hash[index] = {score => datas}
			end
		end
		indexs.each do |inde|
			hash.delete(inde)
		end
		hash
	end

	def self.taobao11_team_rule(score,co,ind,datas)
		if co == 0
			win = "输"
		else
			win = "赢"
		end
		if score >= 0 && score < 200
			spend = 0
			gain = 288
			score = Post.gains(spend,gain,score,co)
			# ind = ind + 1

			datas << "#{ind}场:#{win}(娱乐场) === #{score}"
		elsif score >= 200 && score < 600
			spend = 100
			gain = 688 + 30
			score = Post.gains(spend,gain,score,co)
			ind = ind + 1
			datas << "#{ind}场:#{win}(中级场) === #{score}"
		elsif score >= 600 && score < 1000
			spend = 200
			gain = 988 + 40
			score = Post.gains(spend,gain,score,co)
			# puts "======高级场======#{score}===="
			ind = ind + 1
			datas << "#{ind}场:#{win}(高级场) === #{score}"
		elsif score >= 1000 && score < 2000
			spend = 300
			gain = 1288 + 50
			score = Post.gains(spend,gain,score,co)
			# puts "======金冠场======#{score}====" 
			ind = ind + 1
			datas << "#{ind}场:#{win}(金冠场) === #{score}"
		elsif score >= 2000 && score < 3500
			spend = 600
			gain = 1988 + 60
			score = Post.gains(spend,gain,score,co)
			# puts "======大师场======#{score}===="
			ind = ind + 1
			datas << "#{ind}场:#{win}(大师场) === #{score}"
		elsif score >= 3500 && score < 5000
			spend = 1000
			gain = 2888 + 70
			score = Post.gains(spend,gain,score,co)
			# puts "======荣耀场======#{score}===="
			ind = ind + 1
			datas << "#{ind}场:#{win}(荣耀场) === #{score}"
		elsif score >= 5000 && score < 10000
			spend = 2000
			gain = 4988 + 80
			score = Post.gains(spend,gain,score,co)
			# puts "======传奇场======#{score}===="
			ind = ind + 1
			datas << "#{ind}场:#{win}(传奇场) === #{score}"
		elsif score >= 10000 && score < 20000
			spend = 4000
			gain = 9688 + 90
			score = Post.gains(spend,gain,score,co)
			# puts "======巅峰场======#{score}===="
			ind = ind + 1
			datas << "#{ind}场:#{win}(巅峰场) === #{score}"
		elsif score >= 20000
			spend = 8000
			gain = 18188 + 100
			score = Post.gains(spend,gain,score,co)
			# puts "======梦想场======#{score}===="
			ind = ind + 1
			datas << "#{ind}场:#{win}(梦想场) === #{score}"
		end
		[score,datas]
	end

	def self.gains(spend,gains,score,co)
		if co == 0
			score = score - spend
		else
			score = score - spend + gains
		end
		score
	end

	# def permutations
	#     return [self] if size < 2
	#     perm = []
	#     each { |e| (self - [e]).permutations.each { |p| perm << ([e] + p) } }
	#     puts "#{perm}"
	#     perm
	# end

	def self.get_conditions(length)
	 conditions = []
	 tuple = Array.new(length, 0)
	 1.upto(1<<length) do |i|
	    # puts tuple.inspect 
	   conditions << tuple.inspect
	   j = length - 1
	   while tuple[j] == 1 do
	     tuple[j] = 0
	     j -= 1
	   end 
	   tuple[j] += 1 
	 end
	 conditions
	end

end
