FROM python:2.7-slim as builder

RUN apt update

RUN pip install --upgrade pip && \
    pip install grpcio-tools

WORKDIR /opt/src/geometry-client-python
COPY ./ ./

# firgured out the package defintin by looking at comments in this issue https://github.com/google/protobuf/issues/2283
# has to do with having a defined set of package directories for the proto file itself if you're going to publish code to a package itself
RUN python -mgrpc_tools.protoc -I=./proto/ --python_out=./ --grpc_python_out=./ ./proto/epl/geometry/geometry_operators.proto


FROM python:2.7-slim

RUN apt update

RUN pip install --upgrade pip && \
    pip install grpc && \
    pip install grpcio

# TODO remove this and place it as an install for the testing
RUN pip install shapely

WORKDIR /opt/src/geometry-client-python

COPY --from=builder /opt/src/geometry-client-python /opt/src/geometry-client-python

RUN pip install .

ENV GEOMETRY_SERVICE_HOST="localhost:8980"
