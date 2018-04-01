const oAuth = '?access_token=602efd22f1647b9a105dcdef4e674f34419cf288';

const header = {
  Accept: 'application/vnd.github.v3+json',
};

const writeLastCommitHTML = function (commit) {
  lastCommitSHA = `0x${commit.sha.slice(0, 8)}`;
  lastCommitURL = commit.html_url;
  lastCommitHTML = `<a href="${lastCommitURL}">${lastCommitSHA
  }</a>`;

  jQuery(document).ready(() => {
    document.getElementById('lastcommit').innerHTML = lastCommitHTML;
  });
};

const getLastCommitObj = function (commitUrl, callback) {
  jQuery.ajax(commitUrl + oAuth, {
    headers: header,
    success(data, textStatus, jqXHR) {
      callback(data);
    },
  });
};

const findPushEvent = function (activity) {
  let foundPush = false;
  let i = 0;
  let pushEvent = null;
  while (foundPush == false && i < activity.length) {
    if (activity[i].type == 'PushEvent') {
      foundPush = true;
      pushEvent = activity[i];
    }
    i++;
  }
  return pushEvent;
};

const req = {
  headers: header,
  success(data, textStatus, jqXHR) {
    const pushEvent = findPushEvent(data);
    const commitsInPush = pushEvent.payload.commits.length;
    const commitUrl = pushEvent.payload.commits[commitsInPush - 1].url;
    getLastCommitObj(commitUrl, writeLastCommitHTML);
  },
};

jQuery.ajax(`https://api.github.com/users/skmgoldin/events${oAuth}`, req);

