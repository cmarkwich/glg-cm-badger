var moment = require('moment');

// Flag from epiquery/councilMember/profile/getFlags.mustache
function normalizeFlag(flag) {
  var templateName = flag.FLAG_NAME.toLowerCase()
    .replace(/%?( ?- ?)|%| |\//gi, '-')
    .replace(/-$/gi, '');
  flag.templateName = templateName + '-flag';
  var dates = ['ACTION_DATE', 'CREATE_DATE', 'DURATION', 'LAST_UPDATE_DATE', 'HISTORY_CREATE_DATE'];
  dates.forEach(function(field) {
    flag[field + '_RAW'] = flag[field];
    flag[field] = moment(flag[field]);
  });
  console.log(templateName, flag);
  return flag;
}

Polymer('glg-cm-badger', {
  created: function() {},

  ready: function() {
    console.log('ready');
  },

  attached: function() {},

  domReady: function() {
  },

  detached: function() {},

  handleResponse: function(e, response) {
    // TODO: Handle errors.
    this.flags = response.response.map(normalizeFlag);
  }

});
