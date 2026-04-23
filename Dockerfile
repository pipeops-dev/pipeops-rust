# Use the official Rust image as a builder
FROM rust:latest AS builder

# Create a new empty shell project
WORKDIR /usr/src/app
COPY . .

# Check cargo version to debug
RUN cargo --version

# Build the application
RUN cargo build --release

# Use a smaller image for the final runtime
FROM debian:bookworm-slim

# Install necessary libraries
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy the build artifact from the builder stage
COPY --from=builder /usr/src/app/target/release/pipeops-rust /usr/local/bin/pipeops-rust

# Set the entrypoint
CMD ["pipeops-rust"]
