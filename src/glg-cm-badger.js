Polymer('glg-cm-badger', {
  created: function() {},

  ready: function() {
    console.log('ready');
  },

  attached: function() {},

  domReady: function() {
    this.flags = [{
      name: 'flag-1'
    }, {
      name: 'flag-1'
    }];
  },

  detached: function() {},

  handleResponse: function(e, response) {
    console.log(response);
  }

});

/*
<core-ajax
  auto
  url="https://query.glgroup.com/councilMember/profile/getFlags.mustache"
  params='{"councilMemberId":"239081"}'
  handleAs="json"
  withCredentials="true"
  on-core-response="{{handleResponse}}"></core-ajax>
*/
