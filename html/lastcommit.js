var req = {
  success: function(data, textStatus, jqXHR) {
    console.log(data);  
  }
};

jQuery.ajax("http://api.github.com", req);
