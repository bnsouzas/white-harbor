FROM krakend/builder:2.2.0 as qs-ignore
WORKDIR /builder
COPY ./krakend-debugger .
RUN go build -buildmode=plugin -o krakend-debugger.so .

FROM krakend/builder:2.2.0 as krakend-server-example
WORKDIR /builder
COPY ./krakend-server-example .
RUN go build -buildmode=plugin -o krakend-server-example.so krakend-server-example.go

FROM devopsfaith/krakend:2.1
COPY --from=qs-ignore /builder/krakend-debugger.so /opt/krakend/plugins/krakend-debugger.so
COPY --from=krakend-server-example /builder/krakend-server-example.so /opt/krakend/plugins/krakend-server-example.so
ENTRYPOINT ["/usr/bin/krakend", "run", "-dc", "/etc/krakend/krakend.json" ]