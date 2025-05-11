# Dockerfile per progetto Nextjs per CloudRun (singola immagine)
# Note importanti
# Questo approccio costruisce e serve l'app nella stessa immagine.
# Non è ideale per immagini molto leggere (perché contiene sia il codice che la build), ma è perfetto se vuoi semplicità e non usare multi-stage.

# Nel tuo next.config.js assicurati di avere:
# module.exports = {
#   output: 'standalone',
# };

# Step 1: Utilizzare un'immagine base con Node.js
FROM node:18-slim

# Step 2: Impostare la directory di lavoro
WORKDIR /app

# Step 3: Copiare i file di package.json e package-lock.json (o yarn.lock)
COPY package*.json ./

# Step 4: Installare le dipendenze

# Con il comando seguente non verrebbero installati tsc, e non si potrebbero quindi processare i file .ts.
# Infatti, ignora tutte le devDependencies (come eslint, typescript, jest, ecc)
# RUN npm ci --only=production
#
# Installa tutte le dipendenze, incluse devDependencies
RUN npm ci

# Step 5: Copiare il resto del progetto (tutti i file)
COPY . .

# Step 6: Creare la build di Next.js per la produzione
RUN npm run build

# Step 7: Esporre la porta sulla quale Next.js sarà in ascolto
EXPOSE 8080
# Per GCP sono obbligato ad esporre la porta 8080 (invece della 3000 di default)

# Step 9: Imposta variabili di ambiente per Node.js
ENV PORT=8080
# Avendo esposto la porta 8080, devo personalizzare anche la porta di NextJs:
ENV NODE_ENV=production
# React disattiva i warning e strumenti di debug
# Next.js attiva ottimizzazioni lato server
# Alcuni logger scrivono meno output


# Step 9: Eseguire il server in modalità produzione
# CMD ["npm", "start"]
# Avvia l'app Next.js
CMD ["node", ".next/standalone/server.js"]
