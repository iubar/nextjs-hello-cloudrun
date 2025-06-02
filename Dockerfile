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

# Step 2: Imposta la directory di lavoro
WORKDIR /app

# Step 3: Copia i file di package.json e package-lock.json (o yarn.lock)
COPY package*.json ./

# Step 4: Installare le dipendenze

# Con il comando seguente non verrebbero installati tsc, e non si potrebbero quindi processare i file .ts.
# Infatti, ignora tutte le devDependencies (come eslint, typescript, jest, ecc)
# RUN npm ci --only=production
#
# Installa tutte le dipendenze, incluse devDependencies
RUN npm install

# Step 5: Copia il resto del progetto (tutti i file)
COPY . .

# Step 6: Crea la build di Next.js per la produzione 
# (NB: in next.config.ts è impostato il valore "standalone")
RUN npm run build

# Copia la cartella public (asset statici)
# Implemento il comando seguente, come descritto nella guida https://nextjs.org/docs/app/api-reference/config/next-config-js/output
# cp -r public .next/standalone/ && cp -r .next/static .next/standalone/.next/
COPY public .next/standalone/public
COPY .next/static .next/standalone/.next/static

# Step 7: Espone la porta sulla quale Next.js sarà in ascolto
EXPOSE 8080
# Per GCP sono obbligato ad esporre la porta 8080 (invece della 3000 di default)

# Step 9: Imposta variabili di ambiente per Node.js
ENV PORT=8080
# Avendo esposto la porta 8080, devo personalizzare anche la porta di NextJs:
ENV NODE_ENV=production
# In un'applicazione Node.js (inclusi framework come Next.js, Express, ecc.), la variabile NODE_ENV definisce il contesto di esecuzione. 
# Le tre modalità comuni sono: "development", "production", "test"
#
# Effetti pratici di NODE_ENV=production
# 1. Disattiva funzionalità di sviluppo:
#     Console di debug, stack trace estesi
#     Fast refresh / hot reload (es. in Next.js)
#     Logging più leggero
# 2. Ottimizza performance:
#     Next.js serve asset ottimizzati (JS/CSS minificati)
#     Express disabilita stack trace e messaggi di errore dettagliati
#     Librerie come React abilitano ottimizzazioni di produzione (es. niente warning runtime)
# 3. Riduce bundle size (Next.js, Webpack, ecc.)
# 4. Importa solo codice di produzione: alcune librerie (es. debug, dotenv, chalk, ecc.) usano NODE_ENV per non caricare moduli inutili in produzione.

# Step 9: Esegue il server in modalità produzione
# CMD ["npm", "start"]
# CMD ["npm", "start"] # richiede in package.json lo script {"start": "next start -p 8080"}
# Avvia l'app Next.js
CMD ["node", ".next/standalone/server.js"]
