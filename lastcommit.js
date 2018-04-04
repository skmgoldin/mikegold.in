const axios = require('axios');

const oAuth = '?access_token=602efd22f1647b9a105dcdef4e674f34419cf288';

const header = {
  Accept: 'application/vnd.github.v3+json',
};

const renderLastCommitHTML = (commit) => {
  const lastCommitSHA = `0x${commit.sha.slice(0, 8)}`;
  const lastCommitURL = commit.html_url;
  const lastCommitHTML = `<a href="${lastCommitURL}">${lastCommitSHA
  }</a>`;

  return lastCommitHTML;
};

const getLastCommitObj = async commitUrl => (await axios.get(commitUrl + oAuth, header)).data;

const findPushEvent = (activity) => {
  let foundPush = false;
  let i = 0;
  let pushEvent = null;
  while (foundPush === false && i < activity.length) {
    if (activity[i].type === 'PushEvent') {
      foundPush = true;
      pushEvent = activity[i];
    }
    i += 1;
  }
  return pushEvent;
};

exports.lastCommit = async () => {
  // Get the raw API response for my events, which is in the data prop of the object axios returns
  const rawResult = (await axios.get(
    `https://api.github.com/users/skmgoldin/events${oAuth}`,
    header,
  )).data;

  // Find the most recent push event in my activity
  const pushEvent = findPushEvent(rawResult);

  // Get the number of commits in the pushEvent
  const commitsInPush = pushEvent.payload.commits.length;

  // The commitURL will be the URL property of the final commit object
  const commitUrl = pushEvent.payload.commits[commitsInPush - 1].url;

  // Make another API call to get the most recent commit object at the found commitURL
  const commitObj = await getLastCommitObj(commitUrl);

  // Render HTML which will be displayed: a truncated commit hash linking to the full commit
  return renderLastCommitHTML(commitObj);
};

