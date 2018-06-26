# Day 8 - 스캐폴딩

rails g scaffold post title:string contents:text

* 스캐폴드로 만들면 parameter값이 변경된다.(form의 형태가 바뀐다.)

```erb
	<input type="text" name="title"> 
=>	<input type="text" name="post[title]">

	<form action="" method=""></form>
=>	<%= form_tag("/posts") %><% end %>
	<%= text_field_tag(:title) %>
	<%= text_area_tag(:contents) %>

* @post와 관련된 것만 쓸 수 있다.(f.text_field:description 불가능)
* Post모델의 컬럼과 관련 없는 input 태그는 입력(설정) 불가능
=>	<%= form_for(@post) do |f| %>
		<%= f.text_field(:title)%>
		<%= f.text_area(:contents)%>
	<% end %>
```

## SQL INJECTION

* 파라미터명을 제대로 설정하지 않고 

## form_for

 <%= link_to 'show',post_path(post) %>

`rake routes`

```ruby
   Prefix Verb   URI Pattern               Controller#Action
    posts GET    /posts(.:format)          posts#index
          POST   /posts(.:format)          posts#create
 new_post GET    /posts/new(.:format)      posts#new
edit_post GET    /posts/:id/edit(.:format) posts#edit
     post GET    /posts/:id(.:format)      posts#show
          PATCH  /posts/:id(.:format)      posts#update
          PUT    /posts/:id(.:format)      posts#update
          DELETE /posts/:id(.:format)      posts#destroy
     root GET    /                         post#index
```

* `flash[:notice] = 'Post was successfully created'`

  =>` notice: 'Post was successfully created.` 

  `* 대신에 redirect to 랑 같이 써야한다. '`

## 댓글

```ruby
rails g model comment content post_id:integer
```

`comment.rb`

```
class Comment < ApplicationRecord
    belongs_to :post
end

```

`post.rb`

```ruby
class Post < ApplicationRecord
    has_many :comments
end

```

```ruby
 rails g controller comments create destroy
```

`routes.rb`

``` ruby
post 'post/:id/comments/create' => 'comments#create'
delete 'comments/:id' => 'comments#destroy'
  
get 'comments/destroy'
```

* 어떤 게시글에 속해있는지 알아야하기 때문에 게시글id, 댓글id가 필요.(두 번찾아야 한다)

`$ rake routes`

```ruby
          Prefix Verb   URI Pattern                          Controller#Action
                 POST   /posts/:id/comments/create(.:format) comments#create
                 DELETE /comments/:id(.:format)              comments#destroy
comments_destroy GET    /comments/destroy(.:format)          comments#destroy
           posts GET    /posts(.:format)                     posts#index
                 POST   /posts(.:format)                     posts#create
        new_post GET    /posts/new(.:format)                 posts#new
       edit_post GET    /posts/:id/edit(.:format)            posts#edit
            post GET    /posts/:id(.:format)                 posts#show
                 PATCH  /posts/:id(.:format)                 posts#update
                 PUT    /posts/:id(.:format)                 posts#update
                 DELETE /posts/:id(.:format)                 posts#destroy
            root GET    /                                    post#index
```

* 댓글을 만들 때는 게시글 id, 댓글 id
* 댓글을 삭제할 때는 댓글 id만 알아도 된다.

`rake db:seed / rake db:reset`



## m:n

join table(mebership 테이블)을 이용하여 관계를 설정한다.

```ruby
u1.daums = [1번카페, 2번카페, 3번카페]
2.3.4 :010 > Membership.create(user_id:1, daum_id:1)
2.3.4 :011 > Membership.create(user_id:1, daum_id:2)
2.3.4 :012 > Membership.create(user_id:1, daum_id:3)
u2.daums = [2번카페, 3번카페]
2.3.4 :013 > Membership.create(user_id:2, daum_id:2)
2.3.4 :013 > Membership.create(user_id:2, daum_id:3)
u3.daums = [1번카페, 3번카페]
2.3.4 :015 > Membership.create(user_id:3, daum_id:1) 
2.3.4 :016 > Membership.create(user_id:3, daum_id:3)
```



1번 유저가 1,2,3번 카페에 가입한다

2번 유저가 2,3번 카페에 가입한다.

3번 유저는 1,3번 카페에 가입한다.

```
c1.users = [1번유저,3번유저]
```



1번카페에는 1,3번 유저가 가입했다.

2번카페에는 1,2번 유저가 가입했다.

3번카페는 1,2,3번 유저가 가입했다.

## The `has_many :through` Association

A `has_many :through` association is often used to set up a many-to-many connection with another model.  

```ruby
class Physician < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments
end
 
class Appointment < ApplicationRecord
  belongs_to :physician
  belongs_to :patient
end
 
class Patient < ApplicationRecord
  has_many :appointments
  has_many :physicians, through: :appointments
end
```

![1529995729259](C:\Users\student\AppData\Local\Temp\1529995729259.png)

