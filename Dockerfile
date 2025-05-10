# Step 1: Utilizzare un'immagine base con Node.js
FROM node:18-slim AS base

# Step 2: Impostare la directory di lavoro
WORKDIR /app

# Step 3: Copiare i file di package.json e package-lock.json (o yarn.lock)
COPY package*.json ./

# Step 4: Installare le dipendenze
RUN npm ci --only=prod

# Step 5: Copiare il resto del progetto (tutti i file)
COPY . .

# Step 6: Creare la build di Next.js per la produzione
RUN npm run build

# Step 7: Esporre la porta sulla quale Next.js sarà in ascolto
EXPOSE 3000

# Step 8: Eseguire il server in modalità produzione
CMD ["npm", "start"]
