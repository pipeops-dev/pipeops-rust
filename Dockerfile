# Use the official Rust image as a builder
FROM rust:1.85-slim AS builder

# Create a new empty shell project
WORKDIR /usr/src/app
COPY . .

# Build the application
RUN cargo build --release

# Use a smaller image for the final runtime
FROM debian:bookworm-slim

# Install necessary libraries (like OpenSSL if needed, though actix-web often doesn't need much)
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy the build artifact from the builder stage
COPY --from=builder /usr/src/app/target/release/pipeops-rust /usr/local/bin/pipeops-rust

# Set the entrypoint
CMD ["pipeops-rust"]
