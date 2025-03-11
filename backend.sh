#!/bin/bash

# Step 1: Initialize a new Node.js project
rm -rf package.json package-lock.json node_modules tsconfig.json
npm init -y

# Step 2: Install dependencies (latest stable versions)
npm install express mongoose dotenv cors bcrypt jsonwebtoken cookie-parser
npm install -D typescript ts-node-dev @types/node @types/express @types/mongoose @types/jsonwebtoken @types/bcrypt

# Step 3: Overwrite tsconfig.json
npx tsc --init
npx json -I -f tsconfig.json -e '
this.compilerOptions={
  "target": "ES2020",
  "module": "ESNext",
  "rootDir": "./src",
  "outDir": "./dist",
  "strict": true,
  "moduleResolution": "Node",
  "esModuleInterop": true,
  "forceConsistentCasingInFileNames": true,
  "skipLibCheck": true
}'

# Step 4: Create basic folder structure
mkdir -p src/controllers src/routes src/models src/middleware src/config
touch src/index.ts src/config/db.ts src/routes/auth.ts src/controllers/authController.ts

# Step 5: Add basic Express server (ESM syntax)
cat > src/index.ts <<EOF
import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import cookieParser from "cookie-parser";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());
app.use(cookieParser());

app.get("/", (req, res) => res.send("API is running..."));

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
EOF

# Step 6: Add scripts to package.json
npx json -I -f package.json -e '
this.scripts={
  "dev": "ts-node-dev --respawn --transpile-only src/index.ts",
  "build": "tsc",
  "start": "node dist/index.js"
}'

echo "✅ Backend setup complete!"
