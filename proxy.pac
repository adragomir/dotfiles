function r(tmp) {
    return function(url, host) {
        var tests = []
        if (! tests instanceof Array) {
            tests = [tmp]
        } else {
            tests = tmp
        }
        for (var i = 0; i < tests.length; i++) {
            var test = tests[i]
            if (test instanceof RegExp) {
                alert("Found regexp for testing: " + test + " and url " + url)
                if (test.test(host)) {
                    return true;
                }
            }
            if (typeof test == 'string') {
                if (new RegExp('.*' + test + '.*').test(host)) {
                    return true;
                }
            }
            if (test instanceof Function) {
                if (test(url, host)) {
                    return true
                }
            }
        }
        return false
    }
};

function checkProxy(nets) {
  return function(url, host) {
    for (var i = 0; i < nets.length; i++) {
      if (isInNet(dnsResolve(host), nets[i][0], nets[i][1])) {
        return true;
      }
    }
  }
}

var FindProxyForURL = function(config) {
    return function(url, host) {
        if (host === "[::1]" || host === "localhost" || host === "127.0.0.1")
            return "DIRECT";

        var scheme = url.substr(0, url.indexOf(":"));

        for (var i = 0; i < config.length; i++) {
            proxy = config[i][0]
            tests = config[i][1]
            if (r(tests)(url, host)) {
                alert("Returning proxy " + proxy + " for url " + url + ", " + host);
                return proxy
            }
        }
        return "DIRECT";
    };
}([
//["DIRECT, [//]], 
//["SOCKS5", checkProxy("from", "mask")]]
])

