This builds a [snap package](https://github.com/ubuntu-core/snappy)
of [httpie](http://httpie.org).

Because it's meant for use in snappy systems, it also includes some
httpie and/or requests plugins to support `snapd`. Right now that
means unix socket support, but soon also macaroon auth.

Also some commandline wrangling is done to make it nicer to use with
`snapd` itself; in particular,

```
~:$ http snapd:///v2/system-info
HTTP/1.1 200 OK
Content-Length: 88
Content-Type: application/json
Date: Tue, 26 Apr 2016 15:52:36 GMT

{
    "result": {
        "flavor": "core",
        "series": "16"
    },
    "status": "OK",
    "status-code": 200,
    "type": "sync"
}
```

HTH. HAND.
