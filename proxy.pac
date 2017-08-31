function r(tmp) {
    return function(hostOrUrl) {
        var tests = []
        if (! tests instanceof Array) {
            tests = [tmp]
        } else {
            tests = tmp
        }
        for (var i = 0; i < tests.length; i++) {
            var test = tests[i]
            if (test instanceof RegExp) {
                if (test.test(hostOrUrl)) {
                    return true;
                }
            }
            if (typeof test == 'string') {
                if (new RegExp('.*' + test + '.*').test(hostOrUrl)) {
                    return true;
                }
            }
            if (test instanceof Function) {
                if (test(hostOrUrl)) {
                    return true
                }
            }
        }
        return false
    }
};

var FindProxyForURL = function(config) {
    return function(url, host) {
        if (host === "[::1]" || host === "localhost" || host === "127.0.0.1")
            return "DIRECT";

        var scheme = url.substr(0, url.indexOf(":"));

        for (var i = 0; i < config.length; i++) {
            proxy = config[i][0]
            tests = config[i][1]
            if (r(tests)(host)) {
                return proxy
            }
        }
        return "DIRECT";
    };
}([
//["SOCKS5 localhost:1235", [/^(172\.16\..*|10\.0\..*|10\.10\..*|ip-10-10.*|marathon-lb.*|.*\.mesos|.*\.l4lb\.thisdcos\.directory)$/]]
["SOCKS5 localhost:9876", [/^(172\.16\..*|10\.0\..*|10\.10\..*|ip-10-10.*|marathon-lb.*|.*\.mesos|.*\.l4lb\.thisdcos\.directory)$/]]
])

