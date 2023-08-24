# Use a Rust base image
FROM rust:latest as build

# Set the working directory in the container
WORKDIR /app

# Copy the Cargo.toml and Cargo.lock files to the container
COPY Cargo.toml Cargo.lock ./

# Create an empty project with the same dependencies to cache them
RUN mkdir src && \
    echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs && \
    cargo build --release && \
    rm -f target/release/deps/pipeops-rust*

# Copy the rest of the source code to the container
COPY . .

# Build the Rust application
RUN cargo build --release

# Create a smaller final image
FROM debian:buster-slim

# Set the working directory in the final image
WORKDIR /app

# Copy the built application from the build image to the final image
COPY --from=build /app/target/release/pipeops-rust .

# Expose the port your Rust web application listens on (change as needed)
EXPOSE 8000

# Command to run your Rust web application (adjust as needed)
CMD ["./pipeops-rust"]
