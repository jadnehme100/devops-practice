# ---------- 1) BUILD STAGE ----------
    FROM node:18-alpine AS builder
    WORKDIR /app
    
    # Copy only package files first to leverage Docker layer caching
    COPY package*.json ./
    RUN npm ci
    
    # Now copy the rest of the source
    COPY . .
    
    # Build static assets
    RUN npm run build
    
    
    # ---------- 2) RUNTIME STAGE ----------
    FROM nginx:1.27-alpine AS runtime
    
    # Copy our built static files from the builder stage into Nginx's web root
    COPY --from=builder /app/dist /usr/share/nginx/html
    
    # Provide a minimal Nginx config tuned for SPA/static hosting
    COPY nginx.conf /etc/nginx/conf.d/default.conf
    
    # Add a healthcheck so orchestrators (or you) know if the container is healthy
    HEALTHCHECK CMD wget -qO- http://localhost:80/ || exit 1
    
    # Nginx exposes port 80; Docker uses this to map host ports
    EXPOSE 80
    
    # Default command for nginx images (kept explicit for clarity)
    CMD ["nginx", "-g", "daemon off;"]
    