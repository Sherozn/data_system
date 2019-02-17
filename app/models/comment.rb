class Comment < ApplicationRecord
	#通过评论实例获取该评论客户的用户名
	def get_account_name
		account = Account.find_by(id:self.account_id)
		if account
			name = account.name
		else
			name = "用户不存在"
		end
	end

	# 获取评论创建时间
	# 当小于60秒的时候返回时间为xx秒前； 
	# 当小于60分钟大于等于60秒时返回xx分钟前； 
	# 当小于24小时大于等于60分钟时返回xx小时前；
	# 当大于等于1天的时候，显示xxxx-xx-xx xx-xx时间；
	def get_created_at
		created_at = self.created_at
		now = Time.now
		#时间间隔秒数
		time_distance = (now - created_at).to_i
		if time_distance == 0
			date = "刚刚"
		elsif	time_distance < 60
			date = "#{time_distance}秒前"
		#判断时间间隔是否小于60分钟
		elsif time_distance/60 < 60
			date = "#{time_distance/60}分钟前"
		#判断时间间隔是否小于24小时
		elsif time_distance/(60*60) < 24
			date = "#{time_distance/(60*60)}小时前"
		#时间间隔大于1天，会进入else语句下面的代码
		else
			date = created_at.strftime("%Y-%m-%d %H:%M")
		end
		date
	end

	#判断当前用户是否有删除评论的权利
	def get_account_right(current_user)
		#当没有用户登录，不显示删除链接
		if current_user.blank?
			boolean = false
		#当前用户的role字段为1、2时，代表是管理员、超级管理员，有删除评论的权利
		elsif	current_user.role > 0
			boolean = true
		#如果是自己发布的评论，可以删除
		elsif current_user.id == self.account_id
			boolean = true
		else
			boolean = false
		end
		boolean
	end
end