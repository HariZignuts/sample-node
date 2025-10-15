# -------- Build Stage --------
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Install build dependencies (if needed)
RUN apk add --no-cache python3 make g++

# Copy package.json and package-lock.json first
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy app source code
COPY . .

# -------- Production Stage --------
FROM node:20-alpine

WORKDIR /app

# Copy only production dependencies from build stage
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app ./

# Expose the port
EXPOSE 3000

# Use non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Start the app
CMD ["node", "index.js"]