Polymer('glg-cm-badger', {
  created: function() {},

  ready: function() {
    console.log('ready');
  },

  attached: function() {},

  domReady: function() {
    var flag1 = document.querySelector('#flag-1');
    console.log(flag1);
    // var flag1 = this.$['flag-1'];
    // flag1.model = {};
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
