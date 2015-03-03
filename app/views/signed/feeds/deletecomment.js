<% if @feed %>
  $("#remove_"+"<%= params[:feed_id] %>"+"_"+"<%= params[:comment_id]%>").hide();
  if(<%= @feed.comments.count %> > 0)
  {
   $("#comment_mood_count_"+"<%= params[:feed_id] %>").text(<%= @feed.comments.count %>);
  }else{
    $("#comments_count_"+"<%= params[:feed_id] %>").remove();
  }
<% end %>