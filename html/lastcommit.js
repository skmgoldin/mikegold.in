var lastCommitDateString;
var oAuth = "?access_token=602efd22f1647b9a105dcdef4e674f34419cf288";

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
    jQuery.ajax(commitUrl + oAuth, {
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
  jQuery.ajax("https://api.github.com/users/skmgoldin/events" + oAuth, req);
});

