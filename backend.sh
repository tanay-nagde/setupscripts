#!/bin/bash

# Exit script on error
set -e

# Create project folder and initialize npm
mkdir backend && cd backend
npm init -y

# Install dependencies
npm install express mongoose cors dotenv bcrypt jsonwebtoken cookie-parser uuid zod

# Install dev dependencies
npm install -D typescript ts-node-dev @types/express @types/mongoose @types/cors @types/node @types/jsonwebtoken @types/bcrypt @types/cookie-parser

# Modify package.json to use ESM (ES6 Modules) and add scripts
npx json -I -f package.json -e '
  this.type="module";
  this.scripts={
    "dev": "ts-node-dev --loader ts-node/esm --respawn src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  }
'

# Initialize TypeScript
npx tsc --init

# Modify tsconfig.json for ESM
npx json -I -f tsconfig.json -e '
  this.compilerOptions={
    "target": "ES6",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": true
  }
'

# Create folder structure
mkdir src
touch src/index.ts
echo 'import express from "express";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Backend is running...");
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));' > src/index.ts

echo "✅ Backend setup complete! Run 'npm run dev' to start the server."
