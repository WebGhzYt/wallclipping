 var type = "Feed"; 

  function assign_type(select_type){
    type = select_type ;
  }

function fetch_tags(keyword,auth){
  var check_auth='';
    var search_keyword = keyword.split(" ")[keyword.split(" ").length - 1] ;
    if (search_keyword == ""){
        $('#hash_tags').hide();
    }
    if (auth == "signed")
      {
      check_auth = "/signed/search/fetch_hash_tags"
      }
      else
      {
       check_auth = "/unsigned/search/fetch_hash_tags"
      }

    if (type == "Feed" && keyword.split(" ")[keyword.split(" ").length - 1].slice(0,1) == "#"){
      $.ajax({
        url: check_auth,
        data: {keyword: search_keyword},
        dataType: 'script'
      });
    }
  }

  $(document).ready(function() {

      $('#tag_search').blur(function() {
          $('#hash_tags').slideUp();
      });
  });

  function send_search(tagValue) {
    currentValue = $("#tag_search").val();
    if(currentValue.split(" ")[currentValue.split(" ").length - 1].length != 0){
      $("#tag_search").val(currentValue.slice(0, -currentValue.split(" ")[currentValue.split(" ").length - 1].length) + tagValue);
    }else{
      $("#tag_search").val(currentValue + tagValue);
    }
  }
