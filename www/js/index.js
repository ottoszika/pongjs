(function() {
  var App;

  App = (function() {
    function App() {
      this.bindEvents();
    }

    App.prototype.bindEvents = function() {
      return document.addEventListener('deviceready', this.onDeviceReady, false);
    };

    App.prototype.onDeviceReady = function() {
      return App.receivedEvent('deviceready');
    };

    App.prototype.receivedEvent = function(id) {
      var listeningElement, parentElement, receivedElement;
      parentElement = document.getElementById(id);
      listeningElement = parentElement.querySelector('.listening');
      receivedElement = parentElement.querySelector('.received');
      listeningElement.setAttribute('style', 'display: none;');
      receivedElement.setAttribute('style', 'display: block;');
      return console.log('Received Event: ' + id);
    };

    return App;

  })();

}).call(this);
