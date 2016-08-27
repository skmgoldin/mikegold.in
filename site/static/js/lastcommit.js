var oAuth = "?access_token=602efd22f1647b9a105dcdef4e674f34419cf288"

var header = {
  "Accept": "application/vnd.github.v3+json"
}

var writeLastCommitHTML = function(commit) {
  lastCommitSHA = "0x" + commit.sha.slice(0, 8)
  lastCommitURL = commit.html_url
  lastCommitHTML = "<a href=\"" + lastCommitURL + "\">" + lastCommitSHA 
                   + "</a>"

  jQuery(document).ready(function() {
    document.getElementById("lastcommit").innerHTML = lastCommitHTML
  })
}

var getLastCommitObj = function(commitUrl, callback) {
  jQuery.ajax(commitUrl + oAuth, {
    headers: header,
    success: function(data, textStatus, jqXHR) {
      callback(data)
    }
  })
}

var findPushEvent = function(activity) {
  var foundPush = false
  var i = 0
  var pushEvent = null
  while(foundPush == false && i < activity.length) {
    if(activity[i].type == "PushEvent") {
      foundPush = true
      pushEvent = activity[i]
    }
    i++
  }
  return pushEvent
}

var req = {
  headers: header,
  success: function(data, textStatus, jqXHR) {
    var pushEvent = findPushEvent(data)
    var commitsInPush = pushEvent.payload.commits.length
    var commitUrl = pushEvent.payload.commits[commitsInPush - 1].url
    getLastCommitObj(commitUrl, writeLastCommitHTML)
  }
}

jQuery.ajax("https://api.github.com/users/skmgoldin/events" + oAuth, req)

