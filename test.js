functions = {}
var call;

call = function(fn, input) {
  return fn(input, function(input) {
    var func, _i, _len, _ref, _results;

    _ref = fn.methods;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      func = _ref[_i];
      _results.push(call(functions[func], input));
    }
    return _results;
  });
};

functions['-ItAMo2oxhwUP1Cuzu1S'] = function(input,emit){require('zappajs')(5000, function() {
  return this.get('*', function() {
    return emit({
      res: this.response,
      path: this.params[0].slice(1)
    });
  });
});
}
functions['-ItAMo2oxhwUP1Cuzu1S'].methods = ['-ItANWL1LQQMyTAd9pwX']
functions['-ItANWL1LQQMyTAd9pwX'] = function(input,emit){var contents, fs;

fs = require('fs');

contents = fs.readFileSync(input.path, 'utf-8');

input.res.send(contents);
}
functions['-ItANWL1LQQMyTAd9pwX'].methods = []
call(functions['-ItAMo2oxhwUP1Cuzu1S'])