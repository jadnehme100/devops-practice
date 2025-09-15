# ---------- 1) BUILD STAGE ----------
    FROM node:20-alpine AS builder
    WORKDIR /app
    
    # Copy only manifests first to enable layer caching
    COPY package*.json ./
    RUN npm ci
    
    # Copy the rest of the source and build the static assets
    COPY . .
    RUN npm run build
    
    
    # ---------- 2) RUNTIME STAGE ----------
    FROM nginx:1.27-alpine AS runtime
    
    # Serve the built static files with Nginx
    COPY --from=builder /app/dist /usr/share/nginx/html
    COPY nginx.conf /etc/nginx/conf.d/default.conf
    
    # Healthcheck so orchestrators know if this is responsive
    HEALTHCHECK CMD wget -qO- http://localhost:80/ || exit 1
    
    # Nginx listens on 80 inside the container
    EXPOSE 80
    
    # Keep Nginx in the foreground
    CMD ["nginx", "-g", "daemon off;"]
    