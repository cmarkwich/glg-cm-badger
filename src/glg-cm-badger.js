// Flag from epiquery/councilMember/profile/getFlags.mustache
function normalizeFlag(flag) {
  var templateName = flag.FLAG_NAME.toLowerCase()
    .replace(/%?( ?- ?)|%| |\//gi, '-')
    .replace(/-$/gi, '');
  flag.templateName = templateName + '-flag';
  console.log(templateName);
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
