FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o pokemon-api cmd/main.go

# Final lightweight image
FROM alpine:latest

WORKDIR /root/

# Copy the binary from builder
COPY --from=builder /app/pokemon-api .
COPY --from=builder /app/.env .

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["./pokemon-api"] 