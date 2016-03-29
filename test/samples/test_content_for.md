title: test title
author: test author


<% content_for :css do %>
  body { color: red}
<% end %>

<% content_for :js do %>
   console.log( "hello, js" )
<% end %>


# test header 1

test content 1

<% content_for :css do %>
    .slide1 { color: green }
<% end %>


# test header 2

test content 2
