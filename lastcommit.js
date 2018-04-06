const axios = require('axios');

const oAuth = '?access_token=602efd22f1647b9a105dcdef4e674f34419cf288';

const header = {
  Accept: 'application/vnd.github.v3+json',
};

const renderLastCommitHTML = (commit) => {
  const lastCommitSHA = `0x${commit.sha.slice(0, 8)}`;
  const lastCommitURL = commit.url;
  const lastCommitHTML = `<a href="${lastCommitURL}">${lastCommitSHA
  }</a>`;

  return lastCommitHTML;
};

const findPushEvent = activity =>
  activity.find(event => event.type === 'PushEvent');

exports.lastCommit = async () => {
  // Get the raw API response for my events, which is in the data prop of the object axios returns
  const rawResult = (await axios.get(
    `https://api.github.com/users/skmgoldin/events${oAuth}`,
    header,
  )).data;

  // Find the most recent push event in my activity
  const pushEvent = findPushEvent(rawResult);
  if (typeof pushEvent === 'undefined') {
    return 'unavailable';
  }

  // Get the most recent commit object from the payload
  // TODO: payload.commits actually only includes the first 20 commits in the push, so this will
  // not always actually be the most recent commit. This can be fixed using the commits API.
  const commitObj = pushEvent.payload.commits[pushEvent.payload.commits.length - 1];

  // Render HTML which will be displayed: a truncated commit hash linking to the full commit
  return renderLastCommitHTML(commitObj);
};

