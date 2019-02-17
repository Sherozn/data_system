class PostsController < ApplicationController
  before_action :check_login
  def new
  end

  #创建帖子
  def create
  	head = params[:post][:head]
  	body = params[:post][:body].strip
  	if head.blank?
  		flash.notice = "标题不能为空"
  	elsif body.length < 8
  		flash.notice = "内容长度不能少于8个字"
  	else
  		post = Post.new(account_id: @current_user.id,as_type:0,status:0)
  		post.head = head
  		post.body = body
  		boolean = post.save
  		puts "===boolean=======#{boolean}===="
  		if boolean
  			puts "===post=======#{post.id}===="
  			flash.notice = "发布成功"
  			redirect_to :root
  		else
  			flash.notice = "发布失败，请重新发布"
  			render "/posts/new"
  		end
  	end	
  end

  #点赞
	def create_thumb
		post_id = params[:post_id]
		is_thumb = params[:is_thumb]
		account_id = @current_user.id
		thumb = Thumb.find_or_create_by(account_id:account_id,post_id:post_id)
		if is_thumb == "0"
			thumb.is_thumb = false
		elsif is_thumb == "1"
			thumb.is_thumb = true
		end
		thumb.save
	end

	#进入帖子详情/评论页面
	def show_posts
		post_id = params[:post_id]
		@post = Post.find(post_id)
		#as_type为0时代表帖子的评论，为1时代表评论的回复
		@comments = Comment.where(post_id:post_id,as_type:0).order(created_at: :desc).page(params[:page]).per(10)
	end

	#创建评论
	def create_comment
		#将从客户端提交的参数保存到变量中
		as_type = params[:as_type].to_i
		content = params[:comment]
		post_id = params[:post_id]
		#先判断当前是否有用户登录，没有登录需要提示登录
		if @current_user.blank?
			flash.notice = "您还未登录，请先登录！"
			redirect_to "/posts/show_posts/#{post_id}"
		#再判断评论内容是否为空，内容为空，提示并且返回到帖子详情页面
		elsif content.blank? 
			flash.notice = "评论内容不能为空"
			redirect_to "/posts/show_posts/#{post_id}"
		else
			#as_type参数为0时，说明是帖子的评论
			if as_type == 0
				#创建评论
				boolean_0 = Comment.create(status:0,account_id:@current_user.id,as_type:as_type,content:content,post_id:post_id)
				if boolean_0
					flash.notice = "评论成功"
				else
					flash.notice = "评论失败，请重新评论"
				end
				#重定向到帖子详情页面
				redirect_to "/posts/show_posts/#{post_id}"
			#as_type参数为1时，说明是评论下面的回复
			elsif as_type == 1
				comment_id = params[:comment_id]
				re_reply_id = params[:re_reply_id]
				boolean_1 = Comment.create(status:0,account_id:@current_user.id,as_type:as_type,content:content,post_id:post_id,re_comment_id:comment_id,re_reply_id:re_reply_id)
				if boolean_1
					flash.notice = "回复成功"
				else
				  flash.notice = "回复失败，请重新回复"
				end
				redirect_to "/posts/show_posts/#{post_id}"
			end	
		end
	end

	#删除评论
	def delete_comment
		comment_id = params[:comment_id]
		comment = Comment.find(comment_id)
		post_id = comment.post_id
		#comment表中status为1代表自己删除，为2代表管理员删除
		if @current_user.id == comment.account_id
			comment.status = 1
		else @current_user.role > 0
			comment.status = 2
		end
		comment.save
	end

	#显示评论下面的回复
	def show_replys
	  @comment_id = params[:comment_id]
	  @point = params[:point].to_i
	  #定义每次加载的条数
	  @step = 8
	  #找到comment_id代表的评论下面所有的回复
	  @reply_part = Comment.where(re_comment_id:@comment_id,as_type:1)
	end
end
