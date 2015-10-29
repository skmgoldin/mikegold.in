var lastCommitDateString;

var header = {
  "Accept": "application/vnd.github.v3+json"
}

var req = {
  headers: header,
  success: function(data, textStatus, jqXHR) {
    var foundCommit = false;
    var i = 0;
    var pushObj;
    while(foundCommit != true && i < data.length) {
      if(data[i].type == "PushEvent") {
        foundCommit = true;
        pushObj = data[i];
      }
      i++;
    }

    var commitsInPush = pushObj.payload.commits.length;
    var commitUrl = pushObj.payload.commits[commitsInPush - 1].url;
    jQuery.ajax(commitUrl, {
      headers: header,
      success: function(data, textStatus, jqXHR) {
        lastCommitDateString = new Date(data.commit.author.date);
        lastCommitDateString = lastCommitDateString.toLocaleDateString();
        document.getElementById("lastcommit").innerHTML = lastCommitDateString;
      }
    });
  }
};

jQuery(document).ready(function() {
  jQuery.ajax("http://api.github.com/users/skmgoldin/events/public", req);
});

