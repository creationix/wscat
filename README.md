# wscat

A netcat like client for websockets

## Install

Install using lit.

```sh
lit make lit://creationix/wscat
```

And copy the resulting `wscat` binary to somewhere on your path.

## Usage

Usage is url and then optionally subprotocol.

```sh
wscat ws://localhost:8080 schema-rpc
```
