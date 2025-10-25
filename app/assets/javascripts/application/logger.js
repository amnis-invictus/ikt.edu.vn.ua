(function () {
  function log(level, args) {
    var ts = '[' + level + '] [' + new Date().toISOString() + ']';
    if (args.length > 0 && typeof args[0] === 'string') {
      args[0] = ts + ' ' + args[0];
    } else {
      args.unshift(ts);
    }
    console.log.apply(console, args);
  }

  window.logger = {
    info: function () {
      log('INFO', Array.prototype.slice.call(arguments));
    },
    error: function () {
      log('ERROR', Array.prototype.slice.call(arguments));
    }
  };
})();
