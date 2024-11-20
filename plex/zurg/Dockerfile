# Stage 1: Build the application
FROM golang:1-alpine AS builder
ARG BuiltAt
ARG GitCommit
ARG Version
WORKDIR /app

# Copy the entire project into the container
COPY . .

# Install dependencies for building the application, including make
RUN apk add --no-cache bash git go gcc musl-dev curl fuse libxml2-utils make

# Set build arguments
ENV BUILT_AT=$BuiltAt
ENV GIT_COMMIT=$GitCommit
ENV VERSION=$Version

# Build the application using the Makefile
RUN make build

# Stage 2: Create the runtime container
FROM alpine:3
WORKDIR /app

# Copy the built binary and assets from the builder stage
COPY --from=builder /app/zurg .
COPY --from=builder /app/favicon.ico ./favicon.ico

# Copy additional necessary files
COPY ./healthcheck.sh /app/healthcheck.sh
COPY config.example.yml /app/config.yml

# Ensure healthcheck script is executable
RUN chmod +x /app/healthcheck.sh

# Install runtime dependencies
RUN apk add --no-cache curl python3 libxml2-utils ffmpeg

# Set up healthcheck
HEALTHCHECK --interval=10s --timeout=10s --start-period=60s --retries=1000 CMD /app/healthcheck.sh

# Set the entrypoint
ENTRYPOINT ["./zurg"]
